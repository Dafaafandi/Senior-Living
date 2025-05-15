<?php

namespace App\Filament\Widgets;

use App\Models\Patient;      // Import model Patient
use App\Models\Checkup;     // Import model Checkup
use App\Models\Schedule;    // Import model Schedule
use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class AppStatsOverview extends BaseWidget
{
    protected function getStats(): array
    {
        return [
            Stat::make('Total Pasien', Patient::count()) // Menghitung jumlah pasien
                ->description('Jumlah pasien terdaftar')
                ->descriptionIcon('heroicon-m-user-group') // Ikon deskripsi
                ->color('success'), // Warna tema

            Stat::make('Total Pemeriksaan', Checkup::count()) // Menghitung jumlah checkup
                ->description('Jumlah data pemeriksaan')
                ->descriptionIcon('heroicon-m-heart')
                ->color('warning'),

            Stat::make('Total Jadwal', Schedule::count()) // Menghitung jumlah jadwal
                ->description('Jumlah jadwal tercatat')
                ->descriptionIcon('heroicon-m-calendar-days')
                ->color('info'),
        ];
    }
}
