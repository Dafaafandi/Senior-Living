<?php

namespace App\Filament\Resources;

use App\Filament\Resources\ReminderResource\Pages;
// use App\Filament\Resources\ReminderResource\RelationManagers;
use App\Models\Reminder;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class ReminderResource extends Resource
{
    protected static ?string $model = Reminder::class;

    protected static ?string $navigationIcon = 'heroicon-o-bell-alert'; // Ganti ikon jika perlu
    protected static ?string $navigationGroup = 'Manajemen Pasien'; // Masukkan ke grup yang sama

    // Atur agar nama model tampil lebih ramah
    protected static ?string $modelLabel = 'Pengingat';
    protected static ?string $pluralModelLabel = 'Pengingat';

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
                Forms\Components\TextInput::make('medication_name')
                    ->label('Nama Obat/Pengingat')
                    ->required()
                    ->maxLength(255),
                Forms\Components\TextInput::make('dosage')
                    ->label('Dosis (cth: 1 tablet, 5ml)')
                    ->maxLength(100),
                Forms\Components\TextInput::make('frequency')
                    ->label('Frekuensi (cth: Pagi, 3x Sehari)')
                    ->maxLength(100),
                Forms\Components\TimePicker::make('time')
                    ->label('Waktu Pengingat (Jam:Menit)')
                    ->seconds(false) // Sembunyikan detik
                    ->native(false), // Pakai picker Filament
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
                Tables\Columns\TextColumn::make('medication_name')
                    ->label('Nama Obat/Pengingat')
                    ->searchable(),
                Tables\Columns\TextColumn::make('dosage')
                    ->label('Dosis'),
                Tables\Columns\TextColumn::make('frequency')
                    ->label('Frekuensi'),
                Tables\Columns\TextColumn::make('time')
                    ->label('Waktu')
                    ->time('H:i') // Format waktu HH:MM
                    ->sortable(),
                Tables\Columns\TextColumn::make('created_at')
                    ->dateTime('d M Y H:i')
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->defaultSort('time', 'asc') // Urutkan default berdasarkan waktu
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
            'index' => Pages\ListReminders::route('/'),
            'create' => Pages\CreateReminder::route('/create'),
            'edit' => Pages\EditReminder::route('/{record}/edit'),
        ];
    }
}
