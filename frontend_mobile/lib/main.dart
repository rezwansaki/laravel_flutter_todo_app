import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/screens/home_page.dart';
import 'package:todo_app/screens/register_page.dart';

Future main() async {
  if (kReleaseMode) {
    await dotenv.load(fileName: ".env");
  } else {
    await dotenv.load(fileName: ".env.dev");
  }

  //...runapp
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (_, child) {
          return MaterialApp(
            // to hide debug banner
            debugShowCheckedModeBanner: false,
            title: 'Todo App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
            ),
            home: FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Some error has Occurred');
                } else if (snapshot.hasData) {
                  final token = snapshot.data!.getString('token');
                  if (token != null) {
                    return const HomePage();
                  } else {
                    return const RegisterPage();
                  }
                } else {
                  return const RegisterPage();
                }
              },
            ),
          );
        },
        child: const HomePage());
  }
}
