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
            'blood_pressure' => 'nullable|string|max:255',
            'oxygen_saturation' => 'nullable|integer|min:0|max:100',
            'blood_sugar_level' => 'nullable|numeric',
            'cholesterol_level' => 'nullable|numeric',
            'uric_acid_level' => 'nullable|numeric',
            'notes' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors(),
                'message' => 'Validasi data gagal'
            ], 422);
        }

        try {
            $checkup = Checkup::create([
                'patient_id' => $request->patient_id,
                'checkup_date' => $request->checkup_date,
                'blood_pressure' => $request->blood_pressure,
                'oxygen_saturation' => $request->oxygen_saturation,
                'blood_sugar' => $request->blood_sugar_level,
                'cholesterol' => $request->cholesterol_level,
                'uric_acid' => $request->uric_acid_level,
                'notes' => $request->notes,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Catatan kesehatan berhasil disimpan',
                'data' => $checkup
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menyimpan catatan kesehatan.',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Checkup $checkup)
    {
        return response()->json([
            'success' => true,
            'data' => $checkup,
            'message' => 'Detail catatan kesehatan berhasil diambil.'
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Checkup $checkup)
    {
        // Uncomment for authorization
        // if (Auth::id() != $checkup->patient->user_id) {
        //     return response()->json(['success' => false, 'message' => 'Tidak diizinkan'], 403);
        // }

        $validator = Validator::make($request->all(), [
            'checkup_date' => 'sometimes|required|date_format:Y-m-d',
            'blood_pressure' => 'nullable|string|max:255',
            'oxygen_saturation' => 'nullable|integer|min:0|max:100',
            'blood_sugar_level' => 'nullable|numeric',
            'cholesterol_level' => 'nullable|numeric',
            'uric_acid_level' => 'nullable|numeric',
            'notes' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors(),
                'message' => 'Validasi data gagal'
            ], 422);
        }

        try {
            $updateData = array_filter([
                'checkup_date' => $request->checkup_date,
                'blood_pressure' => $request->blood_pressure,
                'oxygen_saturation' => $request->oxygen_saturation,
                'blood_sugar' => $request->blood_sugar_level,
                'cholesterol' => $request->cholesterol_level,
                'uric_acid' => $request->uric_acid_level,
                'notes' => $request->notes,
            ], fn($value) => !is_null($value));

            $checkup->update($updateData);

            return response()->json([
                'success' => true,
                'message' => 'Catatan kesehatan berhasil diperbarui',
                'data' => $checkup->fresh()
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal memperbarui catatan kesehatan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Checkup $checkup)
    {
        // TODO: Add authorization
        // if (Auth::id() != $checkup->patient->user_id) {
        //     return response()->json([
        //         'success' => false,
        //         'message' => 'Tidak diizinkan menghapus catatan ini'
        //     ], 403);
        // }

        try {
            $deletedId = $checkup->id; // Store ID before deletion
            $checkup->delete();

            return response()->json([
                'success' => true,
                'message' => 'Catatan kesehatan berhasil dihapus',
                'data' => ['id' => $deletedId]
            ], 200);

        } catch (\Exception $e) {
            \Log::error('Error deleting checkup: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus catatan kesehatan',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
