<?php

namespace App\Filament\Resources;

use App\Filament\Resources\ScheduleResource\Pages;
// use App\Filament\Resources\ScheduleResource\RelationManagers;
use App\Models\Schedule;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class ScheduleResource extends Resource
{
    protected static ?string $model = Schedule::class;

    protected static ?string $navigationIcon = 'heroicon-o-calendar-days'; // Ganti ikon jika perlu
    protected static ?string $navigationGroup = 'Manajemen Pasien'; // Masukkan ke grup yang sama

    // Atur agar nama model tampil lebih ramah
    protected static ?string $modelLabel = 'Jadwal';
    protected static ?string $pluralModelLabel = 'Jadwal';

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
                Forms\Components\TextInput::make('activity_name')
                    ->label('Nama Aktivitas/Jadwal')
                    ->required()
                    ->maxLength(255),
                Forms\Components\DateTimePicker::make('schedule_date')
                    ->label('Tanggal & Waktu Jadwal')
                    ->native(false) // Pakai picker Filament
                    ->seconds(false) // Sembunyikan input detik
                    ->required(),
                Forms\Components\Textarea::make('description')
                    ->label('Deskripsi (Opsional)')
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
                Tables\Columns\TextColumn::make('activity_name')
                    ->label('Aktivitas')
                    ->searchable(),
                Tables\Columns\TextColumn::make('schedule_date')
                    ->label('Waktu Jadwal')
                    ->dateTime('d M Y H:i') // Format tanggal & waktu
                    ->sortable(),
                Tables\Columns\TextColumn::make('description')
                    ->label('Deskripsi')
                    ->limit(50) // Batasi panjang teks di tabel
                    ->tooltip(fn (Schedule $record): ?string => $record->description) // Tampilkan full teks saat hover
                    ->toggleable(isToggledHiddenByDefault: true),
                Tables\Columns\TextColumn::make('created_at')
                    ->dateTime('d M Y H:i')
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->defaultSort('schedule_date', 'asc') // Urutkan default berdasarkan jadwal terdekat
            ->filters([
                Tables\Filters\SelectFilter::make('patient')
                    ->relationship('patient', 'name')
                    ->searchable()
                    ->preload()
                    ->label('Filter Pasien'),
                // Mungkin perlu filter rentang tanggal
                Tables\Filters\Filter::make('schedule_date')
                    ->form([
                        Forms\Components\DatePicker::make('scheduled_after')
                            ->label('Jadwal Setelah Tanggal')
                            ->native(false),
                        Forms\Components\DatePicker::make('scheduled_before')
                            ->label('Jadwal Sebelum Tanggal')
                            ->native(false),
                    ])
                    ->query(function (Builder $query, array $data): Builder {
                        return $query
                            ->when(
                                $data['scheduled_after'],
                                fn (Builder $query, $date): Builder => $query->whereDate('schedule_date', '>=', $date),
                            )
                            ->when(
                                $data['scheduled_before'],
                                fn (Builder $query, $date): Builder => $query->whereDate('schedule_date', '<=', $date),
                            );
                    })
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
            'index' => Pages\ListSchedules::route('/'),
            'create' => Pages\CreateSchedule::route('/create'),
            'edit' => Pages\EditSchedule::route('/{record}/edit'),
        ];
    }
}
