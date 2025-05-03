<?php

namespace App\Repositories;

use App\Models\Currency;
use App\Models\Language;
use App\Traits\Loggable;

abstract class CoreRepository
{
    use Loggable;

    protected object $model;
    protected $currency;
    protected $language;

    /**
     * CoreRepository constructor.
     */
    public function __construct()
    {
        $this->model = app($this->getModelClass());
        $this->language = $this->setLanguage();
        $this->currency = $this->setCurrency();
    }

    abstract protected function getModelClass();

    /**
     * Set default Language
     */
    protected function setLanguage()
    {
        return request(
            'lang',
            data_get(Language::where('default', 1)->first(['locale', 'default']), 'locale')
        );
    }

    /**
     * Set default Currency
     */
    protected function setCurrency()
    {
        return request(
            'currency_id',
            data_get(Currency::where('default', 1)->first(['id', 'default']), 'id')
        );
    }

    protected function model()
    {
        return clone $this->model;
    }

}
