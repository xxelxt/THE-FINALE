<?php

namespace App\Helpers;

use App\Models\Order;
use App\Models\ParcelOrderSetting;
use App\Models\Shop;
use App\Models\User;
use DB;
use Illuminate\Pagination\LengthAwarePaginator;

class Utility
{
    const MONDAY = 'monday';
    const TUESDAY = 'tuesday';
    const WEDNESDAY = 'wednesday';
    const THURSDAY = 'thursday';
    const FRIDAY = 'friday';
    const SATURDAY = 'saturday';
    const SUNDAY = 'sunday';

    const DAYS = [
        self::MONDAY => self::MONDAY,
        self::TUESDAY => self::TUESDAY,
        self::WEDNESDAY => self::WEDNESDAY,
        self::THURSDAY => self::THURSDAY,
        self::FRIDAY => self::FRIDAY,
        self::SATURDAY => self::SATURDAY,
        self::SUNDAY => self::SUNDAY,
    ];

    /* Pagination for array */
    public static function paginate($items, $perPage, $page = null, $options = []): LengthAwarePaginator
    {
        return new LengthAwarePaginator($items?->forPage($page, $perPage), $items?->count() ?? 0, $perPage, $page, $options);
    }

    public static function groupRating($reviews): array
    {
        $result = [
            1 => 0.0,
            2 => 0.0,
            3 => 0.0,
            4 => 0.0,
            5 => 0.0,
        ];

        foreach ($reviews as $review) {

            $rating = (int)data_get($review, 'rating');

            if (data_get($result, $rating)) {
                $result[$rating] += data_get($review, 'count');
                continue;
            }

            $result[$rating] = data_get($review, 'count');
        }

        return $result;
    }

    public static function getDriverAccessibleOrderIds(array $filter = []): array
    {
        $orderIds = [];

        if (!data_get($filter, 'empty-deliveryman')) {
            return $orderIds;
        }

        $isDriverPage = request()->is('api/v1/dashboard/deliveryman/*');

        $deliveryMan = User::with(['deliveryManDeliveryZone'])
            ->has('deliveryManDeliveryZone')
            ->find(data_get($filter, 'deliveryman', $isDriverPage ? auth('sanctum')->id() : null));

        if (empty($deliveryMan)) {
            return $orderIds;
        }

        /** @var User $deliveryMan */
        $shopBanIds = DB::table('driver_shop_bans')
            ->where('user_id', $deliveryMan->id)
            ->select(['shop_id'])
            ->pluck('shop_id')
            ->toArray();

        Order::whereNull('deliveryman')
            ->whereIn('status', [Order::STATUS_READY, Order::STATUS_ACCEPTED, Order::STATUS_ON_A_WAY])
            ->whereNotNull('location')
            ->where('delivery_type', Order::DELIVERY)
            ->when(data_get($filter, 'shop_ids'), fn($q, $shopIds) => $q->whereIn('shop_id', (array)$shopIds))
            ->when(count($shopBanIds) > 0, fn($q) => $q->whereNotIn('shop_id', $shopBanIds))
            ->get()
            ->map(function (Order $order) use ($deliveryMan, &$orderIds) {

                if (
                    Utility::pointInPolygon($order->location, $deliveryMan?->deliveryManDeliveryZone->address)
                ) {
                    $orderIds[] = $order->id;
                }

                return null;
            });

        return $orderIds;
    }

    public static function pointInPolygon(array $point, array $polygon): bool
    {
        $lat = $point['latitude'];
        $long = $point['longitude'];

        $inside = false;
        $count = count($polygon);

        for ($i = 0, $j = $count - 1; $i < $count; $j = $i++) {
            $lati = $polygon[$i][0];
            $longi = $polygon[$i][1];
            $latj = $polygon[$j][0];
            $longj = $polygon[$j][1];

            $intersect = (($longi > $long) != ($longj > $long))
                && ($lat < ($latj - $lati) * ($long - $longi) / ($longj - $longi) + $lati);

            if ($intersect) {
                $inside = !$inside;
            }
        }

        return $inside;
    }

    /**
     * @param ParcelOrderSetting $type
     * @param float|null $km
     * @param float|null $rate
     * @return float|null
     */
    public function getParcelPriceByDistance(ParcelOrderSetting $type, ?float $km, ?float $rate): ?float
    {
        $price = $type->special ? $type->special_price : $type->price;
        $pricePerKm = $type->special ? $type->special_price_per_km : $type->price_per_km;

        return round(($price + ($pricePerKm * $km)) * $rate, 2);
    }

    /**
     * @param float|null $km
     * @param Shop|null $shop
     * @param float|null $rate
     * @return float|null
     */
    public function getPriceByDistance(?float $km, ?Shop $shop, ?float $rate): ?float
    {
        $price = data_get($shop, 'price', 0);
        $pricePerKm = data_get($shop, 'price_per_km');

        return round(($price + ($pricePerKm * $km)) * $rate, 2);
    }

    /**
     * @param array $origin , Адрес селлера (откуда)
     * @param array $destination , Адрес клиента (куда)
     * @return float|int|null
     */
    public function getDistance(array $origin, array $destination): float|int|null
    {
        if (
            !data_get($origin, 'latitude') && !data_get($origin, 'longitude') &&
            !data_get($destination, 'latitude') && !data_get($destination, 'longitude')
        ) {
            return 0;
        }

        $originLat = $this->toRadian(data_get($origin, 'latitude'));
        $originLong = $this->toRadian(data_get($origin, 'longitude'));
        $destinationLat = $this->toRadian(data_get($destination, 'latitude'));
        $destinationLong = $this->toRadian(data_get($destination, 'longitude'));

        $deltaLat = $destinationLat - $originLat;
        $deltaLon = $originLong - $destinationLong;

        $delta = pow(sin($deltaLat / 2), 2);
        $cos = cos($destinationLong) * cos($destinationLat);

        $sqrt = ($delta + $cos * pow(sin($deltaLon / 2), 2));
        $asin = 2 * asin(sqrt($sqrt));

        $earthRadius = 6371; // if you need in miles 3963

        return (string)$asin != 'NAN' ? round($asin * $earthRadius, 2) : 1;
    }

    private function toRadian($degree = 0): ?float
    {
        return $degree * pi() / 180;
    }

}
