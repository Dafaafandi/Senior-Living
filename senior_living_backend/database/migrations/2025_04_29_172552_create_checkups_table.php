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
        Schema::create('checkups', function (Blueprint $table) {
            $table->id();

            // Foreign key ke tabel patients
            $table->foreignId('patient_id')
                  ->constrained('patients') // Ke tabel 'patients'
                  ->cascadeOnDelete(); // Jika pasien dihapus, checkup-nya juga dihapus

            $table->string('blood_pressure')->nullable(); // Tekanan darah (cth: "120/80")
            $table->integer('oxygen_saturation')->nullable(); // Saturasi Oksigen (%)
            $table->integer('blood_sugar')->nullable(); // Gula Darah (mg/dL)
            $table->integer('cholesterol')->nullable(); // Kolesterol (mg/dL)
            $table->decimal('uric_acid', 4, 1)->nullable(); // Asam Urat (mg/dL, misal 5.7)

            $table->timestamp('checkup_date')->useCurrent(); // Tanggal & Waktu pemeriksaan, default waktu saat ini

            $table->timestamps(); // created_at dan updated_at
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('checkups');
    }
};
