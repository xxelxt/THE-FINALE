<?php

namespace App\Http\Requests\DeliveryManSetting;

use App\Http\Requests\BaseRequest;
use App\Models\DeliveryManSetting;
use Illuminate\Validation\Rule;

class DeliveryManRequest extends BaseRequest
{
    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules(): array
    {
        return [
            'type_of_technique' => ['nullable', 'string', Rule::in(DeliveryManSetting::TYPE_OF_TECHNIQUES)],
            'brand' => 'nullable|string',
            'model' => 'nullable|string',
            'number' => 'nullable|string',
            'color' => 'nullable|string',
            'online' => 'nullable|boolean',
            'width' => 'nullable|integer|min:0',
            'height' => 'nullable|integer|min:0',
            'length' => 'nullable|integer|min:0',
            'kg' => 'nullable|integer|min:0',
            'location' => 'array',
            'location.latitude' => is_array(request('location')) ? 'required|numeric' : 'numeric',
            'location.longitude' => is_array(request('location')) ? 'required|numeric' : 'numeric',
            'images' => 'array',
            'images.*' => 'string',
        ];
    }
}
