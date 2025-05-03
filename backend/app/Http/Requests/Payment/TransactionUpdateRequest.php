<?php

namespace App\Http\Requests\Payment;

use App\Http\Requests\BaseRequest;
use App\Models\Transaction;
use Illuminate\Validation\Rule;

class TransactionUpdateRequest extends BaseRequest
{
    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules(): array
    {
        return [
            'token' => [
                Rule::exists('payment_process', 'id')
            ],
            'status' => ['required', Rule::in(Transaction::STATUSES)],
            'id' => 'int',
        ];
    }

}
