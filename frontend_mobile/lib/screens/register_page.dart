import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/controllers/api/auth_controller.dart';
import 'package:todo_app/screens/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _email = '';
  String _password = '';
  String _name = '';

  createAccountPressed() async {
    // ignore: avoid_print
    print('$_email - $_password - $_name');
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_email);
    if (emailValid) {
      http.Response response =
          await AuthController.register(_name, _email, _password);
      jsonDecode(response.body);
      //print(response.statusCode);
      if (response.statusCode == 201) {
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const LoginPage(),
            ));
      } else {
        _showMyDialog('Alert Message', 'Failed to register!');
      }
    } else {
      _showMyDialog('Alert Message', 'Email not valid!');
    }
  }

  // Alert message
  Future<void> _showMyDialog(String title, String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(color: Colors.black),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  msg,
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
          title: Text(
            'Registration',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20.sp,
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Name',
                  ),
                  onChanged: (value) {
                    _name = value;
                  },
                ),
                SizedBox(
                  height: 30.h,
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
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
                    hintText: 'Password',
                  ),
                  onChanged: (value) {
                    _password = value;
                  },
                ),
                SizedBox(
                  height: 40.h,
                ),
                ElevatedButton(
                  child: const Text('Create Account'),
                  onPressed: () => createAccountPressed(),
                ),
                SizedBox(
                  height: 40.h,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const LoginPage(),
                        ));
                  },
                  child: const Text(
                    'already have an account',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
