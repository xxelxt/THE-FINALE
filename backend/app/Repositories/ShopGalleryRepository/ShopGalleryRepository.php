<?php

namespace App\Repositories\ShopGalleryRepository;

use App\Models\ShopGallery;
use App\Repositories\CoreRepository;

class ShopGalleryRepository extends CoreRepository
{
    public function show(ShopGallery $model): ShopGallery
    {
        return $model->loadMissing(['galleries']);
    }

    protected function getModelClass(): string
    {
        return ShopGallery::class;
    }

}
