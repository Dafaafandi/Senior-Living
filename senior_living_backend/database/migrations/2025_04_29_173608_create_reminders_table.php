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
        Schema::create('reminders', function (Blueprint $table) {
            $table->id();

            // Foreign key ke tabel patients
            $table->foreignId('patient_id')
                  ->constrained('patients') // Ke tabel 'patients'
                  ->cascadeOnDelete(); // Jika pasien dihapus, pengingatnya juga dihapus

            $table->string('medication_name'); // Nama obat
            $table->string('dosage')->nullable(); // Dosis (cth: "1 tablet", "5ml")
            $table->string('frequency')->nullable(); // Frekuensi (cth: "3x Sehari", "Pagi", "Sebelum Tidur")
            $table->time('time')->nullable(); // Waktu spesifik pengingat (jam & menit)

            $table->timestamps(); // created_at dan updated_at
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('reminders');
    }
};
