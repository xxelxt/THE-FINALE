<?php

namespace App\Models;

use Eloquent;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Cache;

/**
 * App\Models\OrderStatus
 *
 * @property int $id
 * @property array $name
 * @property boolean $active
 * @property int|null $sort
 * @property Carbon $created_at
 * @property Carbon $updated_at
 * @property Carbon $deleted_at
 * @method static Builder|OrderStatus newModelQuery()
 * @method static Builder|OrderStatus newQuery()
 * @method static Builder|OrderStatus query()
 * @method static Builder|OrderStatus whereCreatedAt($value)
 * @method static Builder|OrderStatus whereId($value)
 * @method static Builder|OrderStatus whereStockId($value)
 * @method static Builder|OrderStatus whereUpdatedAt($value)
 * @mixin Eloquent
 */
class OrderStatus extends Model
{
    use HasFactory, SoftDeletes;

const TTL = 864000000;
    public $timestamps = false; // 10000 day
    protected $guarded = ['id'];
    protected $casts = [
        'active' => 'boolean',
    ];

    public static function listNames()
    {
        return self::list()->where('active', '=', 1)->pluck('name', 'name')->toArray();
    }

    public static function list()
    {
        return Cache::remember('order-status-list', self::TTL, function () {
            return self::orderByDesc('sort')->get();
        });
    }

}
