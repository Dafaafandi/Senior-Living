<?php
namespace App\Filament\Resources\HospitalVisitResource\Api\Handlers;

use Illuminate\Http\Request;
use Rupadana\ApiService\Http\Handlers;
use App\Filament\Resources\HospitalVisitResource;
use App\Filament\Resources\HospitalVisitResource\Api\Requests\CreateHospitalVisitRequest;

class CreateHandler extends Handlers {
    public static string | null $uri = '/';
    public static string | null $resource = HospitalVisitResource::class;

        public static bool $public = true;
    public static function getMethod()
    {
        return Handlers::POST;
    }

    public static function getModel() {
        return static::$resource::getModel();
    }

    /**
     * Create HospitalVisit
     *
     * @param CreateHospitalVisitRequest $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function handler(CreateHospitalVisitRequest $request)
    {
        $model = new (static::getModel());

        $model->fill($request->all());

        $model->save();

        return static::sendSuccessResponse($model, "Successfully Create Resource");
    }
}
