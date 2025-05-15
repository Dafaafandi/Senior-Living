<?php

namespace App\Filament\Resources;

use App\Filament\Resources\HospitalVisitResource\Pages;
// use App\Filament\Resources\HospitalVisitResource\RelationManagers;
use App\Models\HospitalVisit;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class HospitalVisitResource extends Resource
{
    protected static ?string $model = HospitalVisit::class;

    protected static ?string $navigationIcon = 'heroicon-o-building-office'; // Ganti ikon jika perlu
    protected static ?string $navigationGroup = 'Riwayat'; // Grup menu baru atau gabung ke yg ada

    // Atur agar nama model tampil lebih ramah
    protected static ?string $modelLabel = 'Kunjungan RS';
    protected static ?string $pluralModelLabel = 'Kunjungan RS';


    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Select::make('patient_id')
                    ->label('Pasien')
                    ->relationship('patient', 'name') // Relasi ke pasien, tampilkan nama
                    ->searchable(['name']) // Cari pasien berdasarkan nama
                    ->preload()
                    ->required()
                    ->placeholder('Pilih Pasien'),
                Forms\Components\DatePicker::make('visit_date')
                    ->label('Tanggal Kunjungan')
                    ->native(false) // Pakai picker Filament
                    ->required(),
                Forms\Components\TextInput::make('hospital_name')
                    ->label('Nama Rumah Sakit')
                    ->required()
                    ->maxLength(255),
                Forms\Components\TextInput::make('doctor_name')
                    ->label('Nama Dokter (Opsional)')
                    ->maxLength(255),
                Forms\Components\Textarea::make('diagnosis')
                    ->label('Diagnosis (Opsional)')
                    ->maxLength(65535)
                    ->columnSpanFull(), // Agar field ini lebar penuh
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('id')->sortable()->toggleable(isToggledHiddenByDefault: true),
                Tables\Columns\TextColumn::make('patient.name') // Tampilkan nama pasien
                    ->label('Pasien')
                    ->searchable()
                    ->sortable(),
                Tables\Columns\TextColumn::make('visit_date')
                    ->label('Tanggal Kunjungan')
                    ->date('d M Y') // Format tanggal
                    ->sortable(),
                Tables\Columns\TextColumn::make('hospital_name')
                    ->label('Rumah Sakit')
                    ->searchable(),
                Tables\Columns\TextColumn::make('doctor_name')
                    ->label('Dokter')
                    ->searchable()
                    ->placeholder('-'), // Tampilkan strip jika kosong
                Tables\Columns\TextColumn::make('diagnosis')
                    ->label('Diagnosis')
                    ->limit(50) // Batasi panjang teks
                    ->tooltip(fn (HospitalVisit $record): ?string => $record->diagnosis) // Tampilkan full teks saat hover
                    ->placeholder('-')
                    ->toggleable(isToggledHiddenByDefault: true), // Sembunyikan default
                Tables\Columns\TextColumn::make('created_at')
                    ->dateTime('d M Y H:i')
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->defaultSort('visit_date', 'desc') // Urutkan default berdasarkan tanggal terbaru
            ->filters([
                 Tables\Filters\SelectFilter::make('patient')
                     ->relationship('patient', 'name')
                     ->searchable()
                     ->preload()
                     ->label('Filter Pasien'),
            ])
            ->actions([
                Tables\Actions\EditAction::make(),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    Tables\Actions\DeleteBulkAction::make(),
                ]),
            ])
            ->emptyStateActions([
                Tables\Actions\CreateAction::make(),
            ]);
    }

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListHospitalVisits::route('/'),
            'create' => Pages\CreateHospitalVisit::route('/create'),
            'edit' => Pages\EditHospitalVisit::route('/{record}/edit'),
        ];
    }
}
