<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Reminder extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'patient_id',
        'medication_name',
        'dosage',
        'frequency',
        'time',
    ];

    /**
     * The attributes that should be cast.
     *
     * casts untuk 'time' biasanya tidak diperlukan jika hanya HH:MM:SS,
     * tapi bisa ditambahkan jika perlu format khusus.
     *
     * @var array<string, string>
     */
    // protected $casts = [
    //     'time' => 'datetime:H:i', // Contoh jika ingin format H:i
    // ];

    /**
     * Mendapatkan data pasien yang memiliki pengingat ini.
     */
    public function patient(): BelongsTo
    {
        return $this->belongsTo(Patient::class);
    }
}
