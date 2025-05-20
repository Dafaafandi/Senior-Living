<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Checkup extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'patient_id',
        'blood_pressure',
        'oxygen_saturation',
        'blood_sugar',
        'cholesterol',
        'uric_acid',
        'checkup_date', // Tambahkan ini
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'checkup_date' => 'datetime', // Cast ke objek Carbon
        'uric_acid' => 'decimal:1', // Cast asam urat ke desimal 1 angka di belakang koma
    ];

    /**
     * Mendapatkan data pasien yang memiliki checkup ini.
     */
    public function patient(): BelongsTo
    {
        return $this->belongsTo(Patient::class);
    }
}
