<?php

namespace App\Http\Resources;

use App\Models\Transaction;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Throwable;

class TransactionResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param Request $request
     * @return array
     */
    public function toArray($request): array
    {
        /** @var Transaction|JsonResource $this */
        /** @var OrderResource|ParcelOrderResource $payable */

        try {
            $payable = 'App\\Http\\Resources\\' . str_replace('App\\Models\\', '', $this->payable_type) . 'Resource';
            $payable = $payable::make($this->whenLoaded('payable'));
        } catch (Throwable $e) {
            $payable = null;
        }

        return [
            'id' => $this->when($this->id, $this->id),
            'payable_id' => $this->when($this->payable_id, $this->payable_id),
            'price' => $this->when($this->price, $this->price),
            'payment_trx_id' => $this->when($this->payment_trx_id, $this->payment_trx_id),
            'parent_id' => $this->when($this->parent_id, $this->parent_id),
            'note' => $this->when($this->note, $this->note),
            'request' => $this->when($this->request, $this->request),
            'perform_time' => $this->when($this->perform_time, $this->perform_time),
            'refund_time' => $this->when($this->refund_time, $this->refund_time),
            'status' => $this->when($this->status, $this->status),
            'status_description' => $this->when($this->status_description, $this->status_description),
            'created_at' => $this->when($this->created_at, $this->created_at?->format('Y-m-d H:i:s') . 'Z'),
            'updated_at' => $this->when($this->updated_at, $this->updated_at?->format('Y-m-d H:i:s') . 'Z'),
            'deleted_at' => $this->when($this->deleted_at, $this->deleted_at?->format('Y-m-d H:i:s') . 'Z'),

            // Relations
            'user' => UserResource::make($this->whenLoaded('user')),
            'payment_system' => PaymentResource::make($this->whenLoaded('paymentSystem')),
            'payment_process' => PaymentProcessResource::make($this->whenLoaded('paymentProcess')),
            'children' => self::collection($this->whenLoaded('children')),
            'parent' => self::make($this->whenLoaded('parent')),

            'payable' => $payable,
        ];
    }
}
