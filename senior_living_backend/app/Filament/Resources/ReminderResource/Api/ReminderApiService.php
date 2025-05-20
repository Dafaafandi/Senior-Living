<?php
namespace App\Filament\Resources\ReminderResource\Api;

use Rupadana\ApiService\ApiService;
use App\Filament\Resources\ReminderResource;
use Illuminate\Routing\Router;


class ReminderApiService extends ApiService
{
    protected static string | null $resource = ReminderResource::class;

    public static function handlers() : array
    {
        return [
            Handlers\CreateHandler::class,
            Handlers\UpdateHandler::class,
            Handlers\DeleteHandler::class,
            Handlers\PaginationHandler::class,
            Handlers\DetailHandler::class
        ];

    }
}
