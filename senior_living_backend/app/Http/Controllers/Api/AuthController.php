<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash; // Import Hash
use Illuminate\Validation\ValidationException; // Import ValidationException
use App\Models\User; // Import User model

class AuthController extends Controller
{
    /**
     * Handle user login request.
     */
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
            'device_name' => 'required|string', // Nama perangkat (e.g., "Abi Dafa Phone")
        ]);

        $user = User::where('email', $request->email)->first();

        // Cek user dan password
        if (! $user || ! Hash::check($request->password, $user->password)) {
            throw ValidationException::withMessages([
                'email' => ['Email atau password salah.'],
            ]);
        }

        // Buat token Sanctum
        $token = $user->createToken($request->device_name)->plainTextToken;

        // Kembalikan response berisi user dan token
        return response()->json([
            'message' => 'Login berhasil',
            'user' => $user, // Kirim data user
            'token' => $token, // Kirim token
        ]);
    }

    /**
     * Get authenticated user data.
     */
    public function user(Request $request)
    {
        // Mengembalikan data user yang sedang login (berdasarkan token)
        return response()->json($request->user());
    }

    /**
     * Handle user logout request.
     */
    public function logout(Request $request)
    {
        // Hapus token yang digunakan untuk request ini
        $request->user()->currentAccessToken()->delete();

        return response()->json(['message' => 'Logout berhasil']);
    }

    /**
     * Handle user registration request (Optional).
     */
    public function register(Request $request)
    {
         $request->validate([
             'name' => 'required|string|max:255',
             'email' => 'required|string|email|max:255|unique:users',
             'password' => 'required|string|min:8|confirmed', // Memerlukan field password_confirmation
             'device_name' => 'required|string',
         ]);

         $user = User::create([
             'name' => $request->name,
             'email' => $request->email,
             'password' => Hash::make($request->password),
         ]);

         $token = $user->createToken($request->device_name)->plainTextToken;

         return response()->json([
             'message' => 'Registrasi berhasil',
             'user' => $user,
             'token' => $token,
         ], 201); // Status 201 Created
    }
}
