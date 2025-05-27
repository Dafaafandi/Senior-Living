<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Carbon\Carbon;

class Patient extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'birth_date',
        'gender',
        'address',
        'medical_history',
        'photo',
        'user_id',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'birth_date' => 'date', // Otomatis cast ke objek Carbon/Date
    ];

    /**
     * Mendapatkan user (admin) yang mengelola pasien ini.
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Mendapatkan data checkup pasien ini (jika diperlukan nanti).
     */
    public function checkups(): HasMany
    {
         return $this->hasMany(Checkup::class); // Ganti Checkup::class dengan nama model checkup Anda nanti
    }

     /**
      * Mendapatkan data jadwal pasien ini (jika diperlukan nanti).
      */
     public function schedules(): HasMany
     {
         return $this->hasMany(Schedule::class); // Ganti Schedule::class dengan nama model schedule Anda nanti
     }

    /**
     * Mendapatkan data kunjungan rumah sakit pasien ini.
     */
    public function hospitalVisits(): HasMany
    {
        return $this->hasMany(HospitalVisit::class);
    }

    /**
     * Mendapatkan data pengingat pasien ini.
     */
    public function reminders(): HasMany
    {
        return $this->hasMany(Reminder::class);
    }

    /**
     * Get the patient's age.
     * Returns null if birth_date is not set or invalid.
     */
    public function getAgeAttribute(): ?int
    {
        try {
            return $this->birth_date ? Carbon::parse($this->birth_date)->age : null;
        } catch (\Exception $e) {
            \Log::error("Error calculating age for patient {$this->id}: {$e->getMessage()}");
            return null;
        }
    }
}
