<?php

namespace App\Filament\Resources\ScheduleResource\Api\Handlers;

use App\Filament\Resources\SettingResource;
use App\Filament\Resources\ScheduleResource;
use Rupadana\ApiService\Http\Handlers;
use Spatie\QueryBuilder\QueryBuilder;
use Illuminate\Http\Request;
use App\Filament\Resources\ScheduleResource\Api\Transformers\ScheduleTransformer;

class DetailHandler extends Handlers
{
    public static string | null $uri = '/{id}';
    public static string | null $resource = ScheduleResource::class;

    public static bool $public = true;

    /**
     * Show Schedule
     *
     * @param Request $request
     * @return ScheduleTransformer
     */
    public function handler(Request $request)
    {
        $id = $request->route('id');

        $query = static::getEloquentQuery();

        $query = QueryBuilder::for(
            $query->where(static::getKeyName(), $id)
        )
            ->first();

        if (!$query) return static::sendNotFoundResponse();

        return new ScheduleTransformer($query);
    }
}
