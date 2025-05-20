<?php
namespace App\Filament\Resources\CheckupResource\Api\Handlers;

use Illuminate\Http\Request;
use Rupadana\ApiService\Http\Handlers;
use App\Filament\Resources\CheckupResource;
use App\Filament\Resources\CheckupResource\Api\Requests\CreateCheckupRequest;

class CreateHandler extends Handlers {
    public static string | null $uri = '/';
    public static string | null $resource = CheckupResource::class;

    public static bool $public = true;
    public static function getMethod()
    {
        return Handlers::POST;
    }

    public static function getModel() {
        return static::$resource::getModel();
    }

    /**
     * Create Checkup
     *
     * @param CreateCheckupRequest $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function handler(CreateCheckupRequest $request)
    {
        $model = new (static::getModel());

        $model->fill($request->all());

        $model->save();

        return static::sendSuccessResponse($model, "Successfully Create Resource");
    }
}
