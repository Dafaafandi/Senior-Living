<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\PatientApiController;
use App\Http\Controllers\Api\CheckupApiController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// Authentication Routes
Route::post('/login', [AuthController::class, 'login']);
Route::post('/register', [AuthController::class, 'register']);

// Protected Routes
Route::middleware('auth:sanctum')->group(function () {
    // User Routes
    Route::get('/user', [AuthController::class, 'user']);
    Route::post('/logout', [AuthController::class, 'logout']);

    // Patient Routes
    Route::get('/patients', [PatientApiController::class, 'index']);

    // Checkup Routes - CRUD operations
    Route::get('/checkups', [CheckupApiController::class, 'index']);
    Route::post('/checkups', [CheckupApiController::class, 'store']);
    Route::get('/checkups/{checkup}', [CheckupApiController::class, 'show']);
    Route::put('/checkups/{checkup}', [CheckupApiController::class, 'update']);
    Route::delete('/checkups/{checkup}', [CheckupApiController::class, 'destroy']);
    Route::delete('/checkups/{checkup}', [CheckupApiController::class, 'destroy']);
});
