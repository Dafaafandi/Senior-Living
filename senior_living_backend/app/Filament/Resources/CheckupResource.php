<?php

namespace App\Filament\Resources;

use App\Filament\Resources\CheckupResource\Pages;
// use App\Filament\Resources\CheckupResource\RelationManagers;
use App\Models\Checkup;
use App\Models\Patient; // Import Patient model
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class CheckupResource extends Resource
{
    protected static ?string $model = Checkup::class;

    protected static ?string $navigationIcon = 'heroicon-o-heart'; // Ganti ikon jika perlu
    protected static ?string $navigationGroup = 'Manajemen Pasien'; // Masukkan ke grup yang sama

    // Atur agar nama model tampil lebih ramah
    protected static ?string $modelLabel = 'Pemeriksaan';
    protected static ?string $pluralModelLabel = 'Pemeriksaan';


    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Select::make('patient_id')
                    ->label('Pasien')
                    ->relationship('patient', 'name') // Relasi ke pasien, tampilkan nama
                    ->searchable(['name', 'address']) // Cari berdasarkan nama atau alamat pasien
                    ->preload()
                    ->required()
                    ->placeholder('Pilih Pasien'),
                Forms\Components\DateTimePicker::make('checkup_date')
                    ->label('Tanggal & Waktu Periksa')
                    ->native(false) // Pakai picker Filament
                    ->default(now()) // Default waktu sekarang
                    ->required(),
                Forms\Components\TextInput::make('blood_pressure')
                    ->label('Tekanan Darah (cth: 120/80)')
                    ->maxLength(20),
                Forms\Components\TextInput::make('oxygen_saturation')
                    ->label('Saturasi Oksigen (%)')
                    ->numeric() // Hanya angka
                    ->minValue(0)
                    ->maxValue(100),
                Forms\Components\TextInput::make('blood_sugar')
                    ->label('Gula Darah (mg/dL)')
                    ->numeric(),
                Forms\Components\TextInput::make('cholesterol')
                    ->label('Kolesterol (mg/dL)')
                    ->numeric(),
                Forms\Components\TextInput::make('uric_acid')
                    ->label('Asam Urat (mg/dL)')
                    ->numeric()
                    ->step(0.1) // Untuk input desimal
                    ->inputMode('decimal'), // Keyboard desimal di mobile
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
                Tables\Columns\TextColumn::make('checkup_date')
                    ->label('Waktu Periksa')
                    ->dateTime('d M Y H:i') // Format tanggal & waktu
                    ->sortable(),
                Tables\Columns\TextColumn::make('blood_pressure')
                    ->label('Tensi')
                    ->searchable(),
                Tables\Columns\TextColumn::make('oxygen_saturation')
                    ->label('SpO2(%)')
                    ->sortable(),
                Tables\Columns\TextColumn::make('blood_sugar')
                    ->label('Gula(mg/dL)')
                    ->sortable(),
                 Tables\Columns\TextColumn::make('cholesterol')
                     ->label('Kolest(mg/dL)')
                     ->sortable()
                     ->toggleable(isToggledHiddenByDefault: true), // Sembunyikan default
                 Tables\Columns\TextColumn::make('uric_acid')
                     ->label('As. Urat(mg/dL)')
                     ->sortable()
                     ->toggleable(isToggledHiddenByDefault: true), // Sembunyikan default
                Tables\Columns\TextColumn::make('created_at')
                    ->dateTime('d M Y H:i')
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
             ->defaultSort('checkup_date', 'desc') // Urutkan default berdasarkan tanggal terbaru
            ->filters([
                // Tambahkan filter jika perlu, misal filter berdasarkan rentang tanggal
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
            'index' => Pages\ListCheckups::route('/'),
            'create' => Pages\CreateCheckup::route('/create'),
            'edit' => Pages\EditCheckup::route('/{record}/edit'),
        ];
    }
}
