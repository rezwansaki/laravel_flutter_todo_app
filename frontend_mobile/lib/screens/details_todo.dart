import 'package:flutter/material.dart';

class DetailsTodo extends StatelessWidget {
  final Map data;
  const DetailsTodo({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(data['id'].toString()),
              Text(data['title'].toString()),
              Text(data['body'].toString())
            ],
          )),
    );
  }
}
