<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Checkup;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;

class CheckupApiController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        try {
            $query = Checkup::query();

            if ($request->has('patient_id')) {
                $query->where('patient_id', $request->patient_id);
            }

            $checkups = $query->orderBy('checkup_date', 'desc')->get();

            return response()->json([
                'success' => true,
                'data' => $checkups,
                'message' => 'Data catatan kesehatan berhasil diambil'
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data catatan kesehatan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'patient_id' => 'required|exists:patients,id',
            'checkup_date' => 'required|date_format:Y-m-d',
            'blood_pressure' => 'nullable|string|max:20',
            'blood_sugar_level' => 'nullable|string|max:50',
            'cholesterol_level' => 'nullable|string|max:50',
            'uric_acid_level' => 'nullable|string|max:50',
            'notes' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            $checkup = Checkup::create([
                'patient_id' => $request->patient_id,
                'checkup_date' => $request->checkup_date,
                'blood_pressure' => $request->blood_pressure,
                'blood_sugar_level' => $request->blood_sugar_level,
                'cholesterol_level' => $request->cholesterol_level,
                'uric_acid_level' => $request->uric_acid_level,
                'notes' => $request->notes,
            ]);

            return response()->json([
                'message' => 'Catatan kesehatan berhasil disimpan',
                'data' => $checkup
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Gagal menyimpan catatan kesehatan.',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
