import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_app/constant/variables.dart';

class AuthController {
  static Future<http.Response> register(
      String name, String email, String password) async {
    Map data = {
      "name": name,
      "email": email,
      "password": password,
    };
    var body = json.encode(data);
    var url = Uri.parse('$API_BASE_URL/register');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    //print(response.body);
    return response;
  }

  static Future<http.Response> login(String email, String password) async {
    Map data = {
      "email": email,
      "password": password,
    };
    var body = json.encode(data);
    var url = Uri.parse('$API_BASE_URL/login');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    // ignore: avoid_print
    print(response.body);
    return response;
  }
}
