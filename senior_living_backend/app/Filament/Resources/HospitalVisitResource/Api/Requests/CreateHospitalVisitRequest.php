<?php

namespace App\Filament\Resources\HospitalVisitResource\Api\Requests;

use Illuminate\Foundation\Http\FormRequest;

class CreateHospitalVisitRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
			'patient_id' => 'required',
			'visit_date' => 'required|date',
			'hospital_name' => 'required|string',
			'doctor_name' => 'required|string',
			'diagnosis' => 'required|string'
		];
    }
}
