<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany; // Import jika perlu relasi one-to-many

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
        'user_id', // Pastikan user_id bisa diisi massal
        'photo',
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

    // Tambahkan relasi lain jika perlu (Reminders, HospitalVisits)
}
