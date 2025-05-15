<?php

namespace App\Filament\Resources\PatientResource\Api\Handlers;

use App\Filament\Resources\SettingResource;
use App\Filament\Resources\PatientResource;
use Rupadana\ApiService\Http\Handlers;
use Spatie\QueryBuilder\QueryBuilder;
use Illuminate\Http\Request;
use App\Filament\Resources\PatientResource\Api\Transformers\PatientTransformer;

class DetailHandler extends Handlers
{
    public static string | null $uri = '/{id}';
    public static string | null $resource = PatientResource::class;


    /**
     * Show Patient
     *
     * @param Request $request
     * @return PatientTransformer
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

        return new PatientTransformer($query);
    }
}
