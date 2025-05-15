<x-filament-panels::page>
    <x-filament::section>
        <x-slot name="heading">
            Selamat Datang di Backend Senior Living
        </x-slot>

        <p class="mb-4">
            Ini adalah panel administrasi untuk mengelola data aplikasi Senior Living.
            Anda dapat mengelola data pasien, pemeriksaan, jadwal, pengingat, dan kunjungan rumah sakit melalui menu di samping.
        </p>

        <h3 class="text-lg font-semibold mb-2">Versi Komponen:</h3>
        <ul class="list-disc list-inside space-y-1 text-sm">
            <li>Laravel Framework: {{ app()->version() }}</li>
            <li>Filament Version: v3.2.0</li>
            <li>PHP Version: {{ phpversion() }}</li>
        </ul>
    </x-filament::section>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mt-6">
        <x-filament::section>
            <x-slot name="heading">
                Pasien
            </x-slot>
            <p>Kelola semua data pasien yang terdaftar dalam sistem.</p>
            <div class="mt-4">
                <x-filament::button
                    tag="a"
                    :href="route('filament.admin.resources.patients.index')"
                    icon="heroicon-m-arrow-right">
                    Lihat Pasien
                </x-filament::button>
            </div>
        </x-filament::section>

        <x-filament::section>
            <x-slot name="heading">
                Pemeriksaan
            </x-slot>
            <p>Catat dan lihat riwayat pemeriksaan kesehatan pasien.</p>
            <div class="mt-4">
                <x-filament::button
                    tag="a"
                    :href="route('filament.admin.resources.checkups.index')"
                    icon="heroicon-m-arrow-right">
                    Lihat Pemeriksaan
                </x-filament::button>
            </div>
        </x-filament::section>
    </div>
</x-filament-panels::page>
