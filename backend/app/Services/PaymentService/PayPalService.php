<?php
declare(strict_types=1);

namespace App\Services\PaymentService;

use App\Models\Order;
use App\Models\Payment;
use App\Models\PaymentPayload;
use App\Models\PaymentProcess;
use App\Models\Payout;
use App\Models\Settings;
use App\Models\Shop;
use App\Models\Subscription;
use App\Models\Transaction;
use DB;
use Exception;
use GuzzleHttp\Client;
use GuzzleHttp\Exception\GuzzleException;
use Illuminate\Database\Eloquent\Model;
use Str;
use Throwable;

class PayPalService extends BaseService
{
    /**
     * @param array $data
     * @return PaymentProcess
     * @throws GuzzleException
     * @throws Throwable
     */
    public function processTransaction(array $data): PaymentProcess
    {
        $payment = Payment::where('tag', Payment::TAG_PAY_PAL)->first();
        $paymentPayload = PaymentPayload::where('payment_id', $payment?->id)->first();
        $payload = $paymentPayload?->payload;
        [$key, $before] = $this->getPayload($data, $payload);
        $currency = Str::upper(data_get($before, 'currency'));
        $modelId = data_get($before, 'model_id');
        $totalPrice = round((float)data_get($before, 'total_price'), 2);

        $data = $this->getData($payload, $currency, $totalPrice, $key, $modelId);

        return PaymentProcess::updateOrCreate([
            'user_id' => auth('sanctum')->id(),
            'model_type' => data_get($before, 'model_type'),
            'model_id' => $modelId,
        ], [
            'id' => data_get($data, 'response.id'),
            'data' => array_merge([
                'url' => data_get($data, 'url'),
                'payment_id' => $payment->id,
            ], $before)
        ]);

    }

    /**
     * @param $payload
     * @param $currency
     * @param $totalPrice
     * @param $key
     * @param $modelId
     * @return array
     * @throws Throwable
     */
    public function getData($payload, $currency, $totalPrice, $key, $modelId): array
    {
        $url = 'https://api-m.sandbox.paypal.com';
        $clientId = data_get($payload, 'paypal_sandbox_client_id');
        $clientSecret = data_get($payload, 'paypal_sandbox_client_secret');

        if (data_get($payload, 'paypal_mode', 'sandbox') === 'live') {
            $url = 'https://api-m.paypal.com';
            $clientId = data_get($payload, 'paypal_live_client_id');
            $clientSecret = data_get($payload, 'paypal_live_client_secret');
        }

        $provider = new Client();
        $responseAuth = $provider->post("$url/v1/oauth2/token", [
            'auth' => [
                $clientId,
                $clientSecret,
            ],
            'form_params' => [
                'grant_type' => 'client_credentials',
            ]
        ]);

        $responseAuth = json_decode($responseAuth->getBody()->getContents(), true);

        $tokenType = data_get($responseAuth, 'token_type', 'Bearer');
        $accessToken = data_get($responseAuth, 'access_token');
        $host = request()->getSchemeAndHttpHost();
        $title = Settings::where('key', 'title')->first()?->title ?? env('APP_NAME');

        $response = $provider->post("$url/v2/checkout/orders", [
            'json' => [
                'intent' => 'CAPTURE',
                'purchase_units' => [
                    [
                        'amount' => [
                            'currency_code' => $currency,
                            'value' => ceil($totalPrice)
                        ]
                    ]
                ],
                'payment_source' => [
                    'paypal' => [
                        'experience_context' => [
                            'payment_method_preference' => 'IMMEDIATE_PAYMENT_REQUIRED',
                            'brand_name' => $title,
                            'locale' => 'en-US',
                            'landing_page' => 'LOGIN',
                            'shipping_preference' => 'NO_SHIPPING',
                            'user_action' => 'PAY_NOW',
                            'return_url' => "$host/order-stripe-success?$key=$modelId",
                            'cancel_url' => "$host/order-stripe-success?$key=$modelId"
                        ]
                    ]
                ]
            ],
            'headers' => [
                'Accept-Language' => 'en_US',
                'Content-Type' => 'application/json',
                'Authorization' => "$tokenType $accessToken",
            ],
        ]);

        $response = json_decode($response->getBody()->getContents(), true);

        if (data_get($response, 'error')) {

            $message = data_get($response, 'message', 'Something went wrong');

            $message = implode(',', is_array($message) ? $message : [$message]);

            throw new Exception($message, 400);
        }

        $links = collect(data_get($response, 'links'));

        $checkoutNowUrl = $links->where('rel', 'approve')->first()['href'] ?? null;
        $checkoutNowUrl = $checkoutNowUrl ?? $links->where('rel', 'payer-action')->first()['href'] ?? null;
        $checkoutNowUrl = $checkoutNowUrl ?? $links->first()['href'] ?? null;

        return [
            'response' => $response,
            'url' => $checkoutNowUrl,
        ];
    }

    /**
     * @param array $data
     * @return array
     * @throws Exception
     * @throws Throwable
     */
    public function splitTransaction(array $data): array
    {
        $payment = Payment::where('tag', Payment::TAG_PAY_PAL)->first();
        $paymentPayload = PaymentPayload::where('payment_id', $payment?->id)->first();
        $payload = $paymentPayload?->payload;

        [$key, $before] = $this->getPayload($data, $payload);
        $modelId = data_get($before, 'model_id');
        $modelType = data_get($before, 'model_type');
        $modelClass = Str::replace('App\\Models\\', '', $modelType);

        $result = [];
        $split = $data['split'] ?? 1;

        $totalPrice = round((float)$before['total_price'] / $split, 2);
        $before['total_price'] = $totalPrice;

        if ($before['total_price'] <= 0) {
            throw new Exception('The minimum amount must be greater than 1' . $before['currency']);
        }

        DB::table('payment_process')
            ->where(['model_id' => $modelId, 'model_type' => $modelType])
            ->when(auth('sanctum')->id(), fn($q, $id) => $q->where('user_id', $id))
            ->delete();

        $transactions = Transaction::with([
            'children' => fn($q) => $q->where('status', Transaction::STATUS_PAID)
        ])
            ->where('payable_id', $modelId)
            ->where('payable_type', $modelType)
            ->where('status', '!=', Transaction::STATUS_PAID)
            ->get();

        foreach ($transactions as $trn) {
            /** @var Transaction $trn */
            if (!empty($trn->children)) {
                $trn->children()->update(['parent_id' => null]);
            }

            $trn->delete();
        }

        $order = $modelType::with(['transaction'])->find($modelId);

        /** @var Order $order */
        if ($order->transaction && $order->transaction->payment_sys_id !== $payment?->id) {
            $order->createManyTransaction($order->transaction->toArray());
        }

        $transaction = $order->createTransaction([
            'price' => $before['total_price'],
            'user_id' => $order->user_id,
            'payment_sys_id' => $payment?->id,
            'payment_trx_id' => null,
            'note' => "Split payment for $modelClass #$order->id",
            'perform_time' => now(),
            'status_description' => "Transaction for $modelClass #$order->id with split",
            'status' => Transaction::STATUS_SPLIT,
        ]);

        for ($i = 0; $split > $i; $i++) {

            $totalPrice = round(ceil($totalPrice), 2);

            $order->createManyTransaction([
                'price' => $totalPrice / 100,
                'user_id' => $order->user_id,
                'payment_sys_id' => $payment?->id,
                'payment_trx_id' => null,
                'note' => "Split payment for $modelClass #$order->id",
                'perform_time' => now(),
                'status_description' => "Transaction for $modelClass #$order->id with split",
                'status' => Transaction::STATUS_PROGRESS,
                'parent_id' => $transaction->id,
            ]);

            $data = $this->getData($payload, Str::upper($before['currency']), $totalPrice, $key, $modelId);

            $result[] = PaymentProcess::updateOrCreate([
                'user_id' => auth('sanctum')->id(),
                'model_type' => data_get($before, 'model_type'),
                'model_id' => $modelId,
            ], [
                'id' => data_get($data, 'response.id'),
                'data' => array_merge([
                    'url' => data_get($data, 'url'),
                    'payment_id' => $payment->id,
                ], $before)
            ]);
        }

        return $result;
    }

    /**
     * @param array $data
     * @param Shop|null $shop
     * @param $currency
     * @return Model|array|PaymentProcess
     * @throws Throwable
     */
    public function subscriptionProcessTransaction(array $data, ?Shop $shop, $currency): Model|array|PaymentProcess
    {
        $payment = Payment::where('tag', Payment::TAG_STRIPE)->first();
        $paymentPayload = PaymentPayload::where('payment_id', $payment?->id)->first();
        $payload = $paymentPayload?->payload;
        $subscription = Subscription::find(data_get($data, 'subscription_id'));
        $totalPrice = round($subscription->price, 2);
        $currency = Str::upper(data_get($paymentPayload?->payload, 'currency', $currency));
        $data = $this->getData($payload, $currency, $totalPrice, 'subscription_id', $subscription->id);

        return PaymentProcess::updateOrCreate([
            'user_id' => auth('sanctum')->id(),
            'model_id' => $subscription->id,
            'model_type' => get_class($subscription)
        ], [
            'id' => data_get($data, 'response.id'),
            'data' => [
                'url' => data_get($data, 'url'),
                'payment_id' => $payment->id,
                'price' => $totalPrice,
                'shop_id' => $shop?->id,
                'subscription_id' => $subscription->id
            ]
        ]);
    }

    protected function getModelClass(): string
    {
        return Payout::class;
    }

}
