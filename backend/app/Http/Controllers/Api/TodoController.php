<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\Todo;

use function PHPUnit\Framework\isEmpty;

class TodoController extends Controller
{
    // Create Todo
    public function createToDo(Request $request)
    {
        $title = $request->input('title');
        $body = $request->input('body');

        $validatedData = Validator::make($request->all(), [
            'title' => 'required',
            'body' => 'required',
        ]);
        if ($validatedData->fails()) {
            return response()->json(['errors' => $validatedData->errors()]);
        }

        $todo = Todo::create([
            'title' => $title,
            'body' => $body
        ]);

        return response()->json([
            'message' => 'Todo Created Successfully',
            'title' => $title,
        ], 201);
    }



    // Show All Todo
    public function showTodo()
    {
        $todo = Todo::orderBy('id', 'desc')->get();
        return response()->json([
            'data' =>  $todo,
            'message' => 'Show All Data',
        ], 200);
    }

    // Update Todo
    public function updateTodo(Request $request, $id)
    {
        $todo = Todo::find($id);

        $title = $request->title;
        $body = $request->body;

        $todo->title = $title;
        $todo->body = $body;

        $todo->update();

        return response()->json([
            'data' =>  $todo,
            'message' => 'Todo Updated Successfully',
        ], 200);
    }

    // Delete Todo
    public function deleteTodo($id)
    {
        $todo = Todo::find($id);
        $todo->delete();
        return response()->json([
            'data' =>  $todo,
            'message' => 'Delete Todo Successfully',
        ], 204);
    }

    // Show single todo
    public function showSingleTodo($id)
    {
        $todo = Todo::find($id);
        return response()->json([
            'data' =>  $todo,
        ], 200);
    }

    // Search todo
    public function searchTodo(Request $request)
    {
        $srch_data = $request->srch_data;

        $search_result = Todo::where('title', 'like', '%' . $srch_data . '%')->orWhere('body', 'like', '%' . $srch_data . '%')->get();

        if ($search_result->isEmpty()) {
            return response()->json([
                'data' =>  $search_result,
                'message' =>  'Data not found!',
            ], 404);
        } else {
            return response()->json([
                'data' =>  $search_result,
            ], 200);
        }
    }
}
