<?php
namespace App\Filament\Resources\HospitalVisitResource\Api\Handlers;

use Illuminate\Http\Request;
use Rupadana\ApiService\Http\Handlers;
use App\Filament\Resources\HospitalVisitResource;
use App\Filament\Resources\HospitalVisitResource\Api\Requests\UpdateHospitalVisitRequest;

class UpdateHandler extends Handlers {
    public static string | null $uri = '/{id}';
    public static string | null $resource = HospitalVisitResource::class;

    public static function getMethod()
    {
        return Handlers::PUT;
    }

    public static function getModel() {
        return static::$resource::getModel();
    }


    /**
     * Update HospitalVisit
     *
     * @param UpdateHospitalVisitRequest $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function handler(UpdateHospitalVisitRequest $request)
    {
        $id = $request->route('id');

        $model = static::getModel()::find($id);

        if (!$model) return static::sendNotFoundResponse();

        $model->fill($request->all());

        $model->save();

        return static::sendSuccessResponse($model, "Successfully Update Resource");
    }
}