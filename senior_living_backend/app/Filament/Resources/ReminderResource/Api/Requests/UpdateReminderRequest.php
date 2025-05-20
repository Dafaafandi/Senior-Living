<?php

namespace App\Filament\Resources\ReminderResource\Api\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateReminderRequest extends FormRequest
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
			'medication_name' => 'required|string',
			'dosage' => 'required|string',
			'frequency' => 'required|string',
			'time' => 'required'
		];
    }
}
