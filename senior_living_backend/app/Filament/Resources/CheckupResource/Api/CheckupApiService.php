<?php
namespace App\Filament\Resources\CheckupResource\Api;

use Rupadana\ApiService\ApiService;
use App\Filament\Resources\CheckupResource;
use Illuminate\Routing\Router;


class CheckupApiService extends ApiService
{
    protected static string | null $resource = CheckupResource::class;

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
