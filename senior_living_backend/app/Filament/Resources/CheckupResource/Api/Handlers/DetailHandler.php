<?php

namespace App\Filament\Resources\CheckupResource\Api\Handlers;

use App\Filament\Resources\SettingResource;
use App\Filament\Resources\CheckupResource;
use Rupadana\ApiService\Http\Handlers;
use Spatie\QueryBuilder\QueryBuilder;
use Illuminate\Http\Request;
use App\Filament\Resources\CheckupResource\Api\Transformers\CheckupTransformer;

class DetailHandler extends Handlers
{
    public static string | null $uri = '/{id}';
    public static string | null $resource = CheckupResource::class;


    /**
     * Show Checkup
     *
     * @param Request $request
     * @return CheckupTransformer
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

        return new CheckupTransformer($query);
    }
}
