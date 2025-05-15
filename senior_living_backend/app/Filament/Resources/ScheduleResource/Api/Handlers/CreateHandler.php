<?php
namespace App\Filament\Resources\ScheduleResource\Api\Handlers;

use Illuminate\Http\Request;
use Rupadana\ApiService\Http\Handlers;
use App\Filament\Resources\ScheduleResource;
use App\Filament\Resources\ScheduleResource\Api\Requests\CreateScheduleRequest;

class CreateHandler extends Handlers {
    public static string | null $uri = '/';
    public static string | null $resource = ScheduleResource::class;

    public static function getMethod()
    {
        return Handlers::POST;
    }

    public static function getModel() {
        return static::$resource::getModel();
    }

    /**
     * Create Schedule
     *
     * @param CreateScheduleRequest $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function handler(CreateScheduleRequest $request)
    {
        $model = new (static::getModel());

        $model->fill($request->all());

        $model->save();

        return static::sendSuccessResponse($model, "Successfully Create Resource");
    }
}