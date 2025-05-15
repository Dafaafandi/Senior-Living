<?php
namespace App\Filament\Resources\PatientResource\Api\Handlers;

use Illuminate\Http\Request;
use Rupadana\ApiService\Http\Handlers;
use App\Filament\Resources\PatientResource;
use App\Filament\Resources\PatientResource\Api\Requests\CreatePatientRequest;

class CreateHandler extends Handlers {
    public static string | null $uri = '/';
    public static string | null $resource = PatientResource::class;

    public static function getMethod()
    {
        return Handlers::POST;
    }

    public static function getModel() {
        return static::$resource::getModel();
    }

    /**
     * Create Patient
     *
     * @param CreatePatientRequest $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function handler(CreatePatientRequest $request)
    {
        $model = new (static::getModel());

        $model->fill($request->all());

        $model->save();

        return static::sendSuccessResponse($model, "Successfully Create Resource");
    }
}