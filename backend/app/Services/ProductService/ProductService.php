<?php

namespace App\Services\ProductService;

use App\Helpers\ResponseError;
use App\Models\Category;
use App\Models\Product;
use App\Models\Settings;
use App\Models\Stock;
use App\Services\CoreService;
use App\Services\Interfaces\ProductServiceInterface;
use App\Traits\SetTranslations;
use DB;
use Exception;
use Throwable;

class ProductService extends CoreService implements ProductServiceInterface
{
    use SetTranslations;

    public function multipleKitchenUpdate(array $filter)
    {
        DB::table('products')
            ->when(isset($filter['shop_id']), fn($q) => $q->where('shop_id', $filter['shop_id']))
            ->whereIn('category_id', (array)$filter['category_ids'])
            ->update([
                'kitchen_id' => $filter['kitchen_id']
            ]);
    }

    /**
     * @param string $uuid
     * @param array $data
     * @return array
     */
    public function update(string $uuid, array $data): array
    {
        try {

            if (
                !empty(data_get($data, 'category_id')) &&
                $this->checkIsParentCategory((int)data_get($data, 'category_id'))
            ) {
                return [
                    'status' => false,
                    'code' => ResponseError::ERROR_501,
                    'message' => __('errors.' . ResponseError::CATEGORY_IS_PARENT, locale: $this->language)
                ];
            }

            if (data_get($data, 'addon') && data_get($data, 'addons.*')) {
                return [
                    'status' => false,
                    'code' => ResponseError::ERROR_501,
                    'message' => __('errors.' . ResponseError::ATTACH_FOR_ADDON, locale: $this->language)
                ];
            }

            /** @var Product|null $product */
            $product = $this->model()->where('uuid', $uuid)->first();

            if (empty($product)) {
                return [
                    'status' => false,
                    'code' => ResponseError::ERROR_404,
                    'message' => __('errors.' . ResponseError::ERROR_404, locale: $this->language)
                ];
            }

            if (data_get($data, 'min_qty') &&
                data_get($data, 'max_qty') &&
                data_get($data, 'min_qty') > data_get($data, 'max_qty')
            ) {
                return [
                    'status' => false,
                    'code' => ResponseError::ERROR_400,
                    'message' => 'max qty must be more than min qty'
                ];
            }

            if (data_get($data, 'min_qty') > 1000000) {
                data_set($data, 'min_qty', 1000000);
            }

            if (data_get($data, 'max_qty') > 1000000) {
                data_set($data, 'max_qty', 1000000);
            }

            $data['status_note'] = null;

            $product->update($data);

            $this->setTranslations($product, $data);

            if (data_get($data, 'meta')) {
                $product->setMetaTags($data);
            }

            if (data_get($data, 'images.0')) {
                $product->galleries()->delete();
                $product->update(['img' => data_get($data, 'images.0')]);
                $product->uploads(data_get($data, 'images'));
            }

            if (data_get($data, 'inventory_items.0')) {
                $product->inventoryItems()->delete();
                foreach ($data['inventory_items'] as $inventoryItem) {
                    $product->inventoryItems()->create($inventoryItem);
                }
            }

            return [
                'status' => true,
                'code' => ResponseError::NO_ERROR,
                'data' => $product->loadMissing([
                    'translations',
                    'metaTags',
                    'stocks.addons',
                    'stocks.addons.addon.translation' => fn($q) => $q->where('locale', $this->language),
                ])
            ];
        } catch (Throwable $e) {
            return [
                'status' => false,
                'code' => ResponseError::ERROR_502,
                'message' => $e->getMessage()
            ];
        }
    }

    private function checkIsParentCategory(int|string|null $categoryId): bool
    {
        $parentCategory = Category::firstWhere('parent_id', $categoryId);

        return !!data_get($parentCategory, 'id');
    }

    public function delete(?array $ids = [], ?int $shopId = null): array
    {
        $products = Product::whereIn('id', $ids)
            ->when($shopId, fn($q) => $q->where('shop_id', $shopId))
            ->get();

        $errorIds = [];

        foreach ($products as $product) {
            try {
                $product->delete();
            } catch (Throwable $e) {
                if (!empty($e->getMessage())) { // this if only for vercel test demo
                    $errorIds[] = $product->id;
                }
            }
        }

        if (count($errorIds) === 0) {
            return ['status' => true, 'code' => ResponseError::NO_ERROR];
        }

        return [
            'status' => false,
            'code' => ResponseError::ERROR_505,
            'message' => __(
                'errors.' . ResponseError::CANT_DELETE_IDS,
                [
                    'ids' => implode(', ', $errorIds)
                ],
                $this->language
            )
        ];
    }

    /**
     * @param array $data
     * @return array
     */
    public function create(array $data): array
    {
        try {

            $product = DB::transaction(function () use ($data) {
                if (
                    !empty(data_get($data, 'category_id')) &&
                    $this->checkIsParentCategory((int)data_get($data, 'category_id'))
                ) {
                    throw new Exception(__('errors.' . ResponseError::CATEGORY_IS_PARENT, locale: $this->language));
                }

                if (data_get($data, 'addon') && data_get($data, 'addons.*')) {
                    throw new Exception(__('errors.' . ResponseError::ATTACH_FOR_ADDON, locale: $this->language));
                }

                /** @var Product $product */
                if (data_get($data, 'min_qty') > 1000000) {
                    data_set($data, 'min_qty', 1000000);
                }

                if (data_get($data, 'max_qty') > 1000000) {
                    data_set($data, 'max_qty', 1000000);
                }

                $autoApprove = Settings::where('key', 'product_auto_approve')->first()?->value;

                if ($autoApprove) {
                    $data['status'] = Product::PUBLISHED;
                    $data['active'] = true;
                }

                $product = $this->model()->create($data);

                $this->setTranslations($product, $data);

                if (data_get($data, 'meta')) {
                    $product->setMetaTags($data);
                }

                if (data_get($data, 'images.0')) {
                    $product->update(['img' => data_get($data, 'images.0')]);
                    $product->uploads(data_get($data, 'images'));
                }

                if (data_get($data, 'inventory_items.0')) {
                    foreach ($data['inventory_items'] as $inventoryItem) {
                        $product->inventoryItems()->create($inventoryItem);
                    }
                }

                return $product;
            });

            return [
                'status' => true,
                'code' => ResponseError::NO_ERROR,
                'data' => $product
            ];
        } catch (Throwable $e) {
            $this->error($e);
            return [
                'status' => false,
                'code' => ResponseError::ERROR_501,
                'message' => $e->getMessage()
            ];
        }
    }

    /**
     * @param Stock $stock
     * @param array $ids
     * @return array
     */
    public function syncAddons(Stock $stock, array $ids): array
    {
        $errIds = [];

        if (count($ids) === 0) {
            $stock->addons()->delete();
            return $errIds;
        }

        try {

            $stock = $stock->loadMissing(['countable']);

            $stock->addons()->delete();

            foreach ($ids as $id) {

                /** @var Product $product */
                $product = Product::with('stock')->where('id', $id)->first();

                if (
                    !$product->stock->addon ||
                    $product->shop_id !== $stock->countable?->shop_id ||
                    $product->stock?->bonus
                ) {
                    $errIds[] = $id;
                    continue;
                }

                $stock->addons()->create([
                    'addon_id' => $id
                ]);

            }

        } catch (Throwable $e) {

            $this->error($e);
            $errIds = $ids;
        }

        return $errIds;
    }

    protected function getModelClass(): string
    {
        return Product::class;
    }
}
