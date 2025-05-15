<?php

namespace App\Filament\Pages;

use Filament\Pages\Page;

class InfoAplikasi extends Page
{
    protected static string $view = 'filament.pages.info-aplikasi';

    protected static ?string $navigationIcon = 'heroicon-o-information-circle';

    protected static ?string $navigationLabel = 'Info Aplikasi';

    protected ?string $heading = 'Informasi Aplikasi';
}
