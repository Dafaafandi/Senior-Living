<?php

namespace App\Filament\Resources\CheckupResource\Api\Requests;

use Illuminate\Foundation\Http\FormRequest;

class CreateCheckupRequest extends FormRequest
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
			'blood_pressure' => 'required|string',
			'oxygen_saturation' => 'required|integer',
			'blood_sugar' => 'required|integer',
			'cholesterol' => 'required|integer',
			'uric_acid' => 'required|numeric',
			'checkup_date' => 'required'
		];
    }
}
