<?php

namespace App\Models;

use Eloquent;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Carbon;

/**
 * App\Models\Notification
 *
 * @property int $id
 * @property string $type
 * @property array $payload
 * @property boolean $active - Внутри таблицы notification_user
 * @property Carbon $created_at
 * @property Carbon $updated_at
 * @property Carbon $deleted_at
 * @method static Builder|Tag newModelQuery()
 * @method static Builder|Tag newQuery()
 * @method static Builder|Tag query()
 * @method static Builder|Tag whereCreatedAt($value)
 * @method static Builder|Tag whereId($value)
 * @method static Builder|Tag whereUpdatedAt($value)
 * @mixin Eloquent
 */
class Notification extends Model
{
    use HasFactory, SoftDeletes;

    public const PUSH = 'push';
    public const DISCOUNT = 'discount';
    public const ORDER_VERIFY = 'order_verify';
    public const ORDER_STATUSES = 'order_statuses';
    public const TYPES = [
        self::PUSH => self::PUSH,
        self::DISCOUNT => self::DISCOUNT,
        self::ORDER_VERIFY => self::ORDER_VERIFY,
        self::ORDER_STATUSES => self::ORDER_STATUSES,
    ];
    protected $guarded = ['id'];
    protected $casts = [
        'payload' => 'array',
        'created_at' => 'datetime:Y-m-d H:i:s',
        'updated_at' => 'datetime:Y-m-d H:i:s',
    ];

    public function users(): BelongsToMany
    {
        return $this->belongsToMany(User::class, NotificationUser::class)
            ->as('notification')
            ->withPivot('active');
    }
}
