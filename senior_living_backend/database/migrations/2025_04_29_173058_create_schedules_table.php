<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('schedules', function (Blueprint $table) {
            $table->id();

            // Foreign key ke tabel patients
            $table->foreignId('patient_id')
                  ->constrained('patients') // Ke tabel 'patients'
                  ->cascadeOnDelete(); // Jika pasien dihapus, jadwalnya juga dihapus

            $table->string('activity_name'); // Nama aktivitas/kegiatan
            $table->dateTime('schedule_date'); // Tanggal & Waktu jadwal
            $table->text('description')->nullable(); // Deskripsi/keterangan tambahan

            $table->timestamps(); // created_at dan updated_at
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('schedules');
    }
};
