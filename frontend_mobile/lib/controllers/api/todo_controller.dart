import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/constant/variables.dart';

class TodoController {
  static Future<http.Response> createTodo(String title, String tbody) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'token';
    final value = prefs.get(key) ?? 0; //value will store the token

    var url = Uri.parse('$API_BASE_URL/createToDo');

    http.Response response = await http.post(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "title": title,
      "body": tbody
    });
    return response;
  }

  // http://127.0.0.1:8000/api/showTodo - get request to read data without authenticated
  static Future<http.Response> showTodo() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'token';
    final value = prefs.get(key) ?? 0; //value will store the token

    var url = Uri.parse('$API_BASE_URL/showTodo');
    http.Response response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $value'},
    );
    return response;
  }

  // http://127.0.0.1:8000/api/updateTodo/{id} - put request to update data with authentication
  static Future<http.Response> updateTodo(
      int id, String title, String body) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'token';
    final value = prefs.get(key) ?? 0; //value will store the token

    var url = Uri.parse('$API_BASE_URL/updateTodo/ $id');

    http.Response response = await http.put(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "title": title,
      "body": body,
    });
    return response;
  }

  // http://127.0.0.1:8000/api/deleteTodo/{id} - delete request to delete data with authentication
  static Future<http.Response> deleteTodo(String delDataId) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'token';
    final value = prefs.get(key) ?? 0; //value will store the token

    final http.Response response = await http.delete(
      Uri.parse('$API_BASE_URL/deleteTodo/$delDataId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $value'
      },
    );
    return response;
  }

  // http://127.0.0.1:8000/api/searchTodo - get request to search data with authentication
  static Future<http.Response> searchTodo(String srchData) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'token';
    final value = prefs.get(key) ?? 0; //value will store the token

    var url = Uri.parse('$API_BASE_URL/searchTodo?srch_data=$srchData');

    http.Response response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $value'},
    );
    return response;
  }
}
