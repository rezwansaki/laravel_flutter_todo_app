import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/controllers/api/auth_controller.dart';
import 'package:todo_app/screens/home_page.dart';
import 'package:todo_app/widgets/error_snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _password = '';
  loginPressed() async {
    if (_email.isNotEmpty && _password.isNotEmpty) {
      http.Response response = await AuthController.login(_email, _password);
      Map responseMap = jsonDecode(response.body);
      // ignore: avoid_print
      print(response.body);
      // print(response.statusCode);
      if (response.statusCode == 200) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setInt('user_id', responseMap['data']['id']);
        await preferences.setString('name', responseMap['data']['name']);
        await preferences.setString('email', responseMap['data']['email']);
        await preferences.setString('token', responseMap['access_token']);
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const HomePage(),
            ));
      } else {
        // ignore: use_build_context_synchronously
        errorSnackBar(context, responseMap.values.first);
      }
    } else {
      errorSnackBar(context, 'enter all required fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
          title: Text(
            'Login',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                ),
                style: const TextStyle(color: Colors.black),
                onChanged: (value) {
                  _email = value;
                },
              ),
              SizedBox(
                height: 30.h,
              ),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Enter your password',
                ),
                style: const TextStyle(color: Colors.black),
                onChanged: (value) {
                  _password = value;
                },
              ),
              SizedBox(
                height: 30.h,
              ),
              ElevatedButton(
                child: const Text('Login'),
                onPressed: () => loginPressed(),
              )
            ],
          ),
        ));
  }
}
