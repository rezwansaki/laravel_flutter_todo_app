<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\TodoController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

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

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::post('/register', [AuthController::class, 'Register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');
Route::post('/createToDo', [TodoController::class, 'createToDo'])->middleware('auth:sanctum');
Route::get('/showTodo', [TodoController::class, 'showTodo'])->middleware('auth:sanctum');
Route::put('/updateTodo/{id}', [TodoController::class, 'updateTodo'])->middleware('auth:sanctum');
Route::delete('deleteTodo/{id}', [TodoController::class, 'deleteTodo'])->middleware('auth:sanctum');
Route::get('/showSingleTodo/{id}', [TodoController::class, 'showSingleTodo'])->middleware('auth:sanctum');
Route::get('/searchTodo', [TodoController::class, 'searchTodo'])->middleware('auth:sanctum');

// REST API List: 
// POST API for registration 
// http://127.0.0.1:8000/api/register
// POST API for login
// http://127.0.0.1:8000/api/login
// POST API for logout
// http://127.0.0.1:8000/api/logout
// POST API for creating a todo 
// http://127.0.0.1:8000/api/createToDo
// GET API to show all todos 
// http://127.0.0.1:8000/api/showTodo
// PUT API to update todo 
// http://127.0.0.1:8000/api/updateTodo/2
// DELETE API to delete a todo 
// http://127.0.0.1:8000/api/deleteTodo/2
// GET API to show a single todo 
// http://127.0.0.1:8000/api/showSingleTodo/2
// GET API to search from todo
// http://127.0.0.1:8000/api/searchTodo
