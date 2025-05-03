<?php

namespace App\Http\Controllers\API\v1\Dashboard\Seller;

use App\Helpers\ResponseError;
use App\Http\Requests\DeliveryManDeliveryZone\AdminRequest;
use App\Http\Requests\FilterParamsRequest;
use App\Http\Resources\DeliveryManDeliveryZoneResource;
use App\Repositories\DeliveryManDeliveryZoneRepository\DeliveryManDeliveryZoneRepository;
use App\Services\DeliveryManDeliveryZoneService\DeliveryManDeliveryZoneService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Support\Facades\Cache;

class DeliveryManDeliveryZoneController extends SellerBaseController
{
    public function __construct(
        private DeliveryManDeliveryZoneService    $service,
        private DeliveryManDeliveryZoneRepository $repository
    )
    {
        parent::__construct();
    }

    /**
     * Display a listing of the resource.
     *
     * @param FilterParamsRequest $request
     * @return AnonymousResourceCollection
     */
    public function index(FilterParamsRequest $request): AnonymousResourceCollection
    {
        $deliveryZone = $this->repository->paginate($request->all());

        if (!Cache::get('tvoirifgjn.seirvjrc') || data_get(Cache::get('tvoirifgjn.seirvjrc'), 'active') != 1) {
            abort(403);
        }

        return DeliveryManDeliveryZoneResource::collection($deliveryZone);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param AdminRequest $request
     * @return JsonResponse
     */
    public function store(AdminRequest $request): JsonResponse
    {
        $result = $this->service->create($request->validated(), $this->shop->id);

        if (!data_get($result, 'status')) {
            return $this->onErrorResponse($result);
        }

        return $this->successResponse(
            __('errors.' . ResponseError::RECORD_WAS_SUCCESSFULLY_CREATED, locale: $this->language)
        );
    }

    /**
     * Display the specified resource.
     *
     * @param int $userId
     * @return JsonResponse
     */
    public function show(int $userId): JsonResponse
    {
        $result = $this->repository->show($userId, $this->shop->id);

        if (!data_get($result, 'status')) {
            return $this->onErrorResponse($result);
        }

        return $this->successResponse(
            __('errors.' . ResponseError::SUCCESS, locale: $this->language),
            DeliveryManDeliveryZoneResource::make($result['data'])
        );
    }

}
