<?php

namespace App\Filament\Resources\HospitalVisitResource\Api\Handlers;

use App\Filament\Resources\SettingResource;
use App\Filament\Resources\HospitalVisitResource;
use Rupadana\ApiService\Http\Handlers;
use Spatie\QueryBuilder\QueryBuilder;
use Illuminate\Http\Request;
use App\Filament\Resources\HospitalVisitResource\Api\Transformers\HospitalVisitTransformer;

class DetailHandler extends Handlers
{
    public static string | null $uri = '/{id}';
    public static string | null $resource = HospitalVisitResource::class;


    /**
     * Show HospitalVisit
     *
     * @param Request $request
     * @return HospitalVisitTransformer
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

        return new HospitalVisitTransformer($query);
    }
}
