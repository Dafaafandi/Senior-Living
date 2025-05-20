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
        Schema::create('hospital_visits', function (Blueprint $table) {
            $table->id();

            // Foreign key ke tabel patients
            $table->foreignId('patient_id')
                  ->constrained('patients') // Ke tabel 'patients'
                  ->cascadeOnDelete(); // Jika pasien dihapus, riwayat kunjungannya juga dihapus

            $table->date('visit_date'); // Tanggal kunjungan
            $table->string('hospital_name'); // Nama rumah sakit
            $table->string('doctor_name')->nullable(); // Nama dokter (opsional)
            $table->text('diagnosis')->nullable(); // Diagnosis (opsional)

            $table->timestamps(); // created_at dan updated_at
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('hospital_visits');
    }
};
