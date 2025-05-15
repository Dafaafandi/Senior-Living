<?php

namespace App\Filament\Resources\HospitalVisitResource\Pages;

use App\Filament\Resources\HospitalVisitResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListHospitalVisits extends ListRecords
{
    protected static string $resource = HospitalVisitResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}
