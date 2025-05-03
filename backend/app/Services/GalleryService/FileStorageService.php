<?php

namespace App\Services\GalleryService;

use App\Helpers\ResponseError;
use App\Models\Gallery;
use App\Services\CoreService;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Throwable;

class FileStorageService extends CoreService
{
    public function getStorageFiles($type, int $perPage = 10): LengthAwarePaginator
    {
        return Gallery::where('type', $type)
            ->orderByDesc('id')
            ->paginate($perPage);
    }

    public function deleteFileFromStorage(?array $ids = []): array
    {
        try {

            foreach (Gallery::find(is_array($ids) ? $ids : []) as $gallery) {
                $gallery->delete();
            }

            return ['status' => true, 'code' => ResponseError::NO_ERROR, 'data' => []];
        } catch (Throwable $e) {
            $this->error($e);
            return [
                'status' => false,
                'code' => ResponseError::ERROR_503,
                'message' => __('errors.' . ResponseError::ERROR_503, locale: $this->language)
            ];
        }
    }

    protected function getModelClass(): string
    {
        return Gallery::class;
    }
}
