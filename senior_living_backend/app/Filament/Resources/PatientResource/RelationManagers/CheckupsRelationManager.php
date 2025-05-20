<?php

namespace App\Filament\Resources\PatientResource\RelationManagers;

use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\RelationManagers\RelationManager;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class CheckupsRelationManager extends RelationManager
{
    protected static string $relationship = 'checkups';
    protected static ?string $recordTitleAttribute = 'checkup_date';

    public function form(Form $form): Form
    {
        return CheckupResource::form($form);
    }

    public function table(Table $table): Table
    {
        return $table
            ->heading('Riwayat Pemeriksaan')
            ->columns([
                Tables\Columns\TextColumn::make('checkup_date')
                    ->label('Waktu Periksa')
                    ->dateTime('d M Y H:i')
                    ->sortable(),
                Tables\Columns\TextColumn::make('blood_pressure')
                    ->label('Tensi'),
                Tables\Columns\TextColumn::make('oxygen_saturation')
                    ->label('SpO2(%)'),
                Tables\Columns\TextColumn::make('blood_sugar')
                    ->label('Gula(mg/dL)'),
                Tables\Columns\TextColumn::make('cholesterol')
                     ->label('Kolest(mg/dL)')
                     ->toggleable(isToggledHiddenByDefault: true),
                Tables\Columns\TextColumn::make('uric_acid')
                     ->label('As. Urat(mg/dL)')
                     ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([])
            ->headerActions([
                Tables\Actions\CreateAction::make(),
            ])
            ->actions([
                Tables\Actions\EditAction::make(),
                Tables\Actions\DeleteAction::make(),
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
}
