<?php
namespace App\Filament\Resources\CheckupResource\Api\Handlers;

use Illuminate\Http\Request;
use Rupadana\ApiService\Http\Handlers;
use App\Filament\Resources\CheckupResource;
use App\Filament\Resources\CheckupResource\Api\Requests\UpdateCheckupRequest;

class UpdateHandler extends Handlers {
    public static string | null $uri = '/{id}';
    public static string | null $resource = CheckupResource::class;

    public static function getMethod()
    {
        return Handlers::PUT;
    }

    public static function getModel() {
        return static::$resource::getModel();
    }


    /**
     * Update Checkup
     *
     * @param UpdateCheckupRequest $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function handler(UpdateCheckupRequest $request)
    {
        $id = $request->route('id');

        $model = static::getModel()::find($id);

        if (!$model) return static::sendNotFoundResponse();

        $model->fill($request->all());

        $model->save();

        return static::sendSuccessResponse($model, "Successfully Update Resource");
    }
}