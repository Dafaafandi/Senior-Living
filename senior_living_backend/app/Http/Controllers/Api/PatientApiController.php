<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Patient;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\ValidationException;

class PatientApiController extends Controller
{
    public function index()
    {
        $patients = Patient::with('user')->get();
        return response()->json([
            'success' => true,
            'data' => $patients
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'birth_date' => 'required|date',
            'gender' => 'required|in:male,female',
            'address' => 'required|string',
            'medical_history' => 'nullable|string',
            'photo' => 'nullable|image|max:2048'
        ]);

        if ($request->hasFile('photo')) {
            $path = $request->file('photo')->store('patients', 'public');
            $validated['photo'] = $path;
        }

        $validated['user_id'] = auth()->id();
        $patient = Patient::create($validated);

        return response()->json([
            'success' => true,
            'data' => array_merge($patient->toArray(), ['age' => $patient->age])
        ], 201);
    }

    public function show(Patient $patient)
    {
        return response()->json([
            'success' => true,
            'data' => array_merge($patient->toArray(), ['age' => $patient->age])
        ]);
    }

    public function update(Request $request, Patient $patient)
    {
        $validated = $request->validate([
            'name' => 'sometimes|string|max:255',
            'birth_date' => 'sometimes|date',
            'gender' => 'sometimes|in:male,female',
            'address' => 'sometimes|string',
            'medical_history' => 'nullable|string',
            'photo' => 'nullable|image|max:2048'
        ]);

        if ($request->hasFile('photo')) {
            if ($patient->photo) {
                Storage::disk('public')->delete($patient->photo);
            }
            $path = $request->file('photo')->store('patients', 'public');
            $validated['photo'] = $path;
        }

        $patient->update($validated);

        return response()->json([
            'success' => true,
            'data' => array_merge($patient->toArray(), ['age' => $patient->age])
        ]);
    }

    public function destroy(Patient $patient)
    {
        if ($patient->photo) {
            Storage::disk('public')->delete($patient->photo);
        }

        $patient->delete();

        return response()->json([
            'success' => true,
            'message' => 'Patient deleted successfully'
        ]);
    }
}
