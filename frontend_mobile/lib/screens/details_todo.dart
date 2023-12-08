import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsTodo extends StatelessWidget {
  final Map data;
  const DetailsTodo({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Search',
            onPressed: () {
              // go back
              Navigator.pop(context);
            },
          ),
          title: const Text('Todo - Details'),
        ),
        body: Padding(
            padding: EdgeInsets.all(8.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Todo id: ${data['id']}',
                    style: TextStyle(fontSize: 15.sp),
                  ),
                ),
                Text(
                  'Todo title: ${data['title']}',
                  style: TextStyle(fontSize: 14.sp),
                ),
                Text(
                  'Todo body: ${data['body']}',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            )),
      ),
    );
  }
}
