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
        'patient_id',    // Foreign key to patients table
        'checkup_date',  // Date of health checkup
        'blood_pressure', // Format: systolic/diastolic (e.g., 120/80)
        'oxygen_saturation', // SpO2 percentage (0-100)
        'blood_sugar',   // Blood sugar level in mg/dL
        'cholesterol',   // Cholesterol level in mg/dL
        'uric_acid',    // Uric acid level in mg/dL
        'notes',        // Optional notes about the checkup
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'checkup_date' => 'datetime', // Cast ke objek Carbon
        'uric_acid' => 'decimal:1', // Cast asam urat ke desimal 1 angka di belakang koma
        'blood_sugar' => 'integer',     // Added casting
        'cholesterol' => 'integer',     // Added casting
        'oxygen_saturation' => 'integer' // Added casting
    ];

    /**
     * Mendapatkan data pasien yang memiliki checkup ini.
     */
    public function patient(): BelongsTo
    {
        return $this->belongsTo(Patient::class);
    }
}
