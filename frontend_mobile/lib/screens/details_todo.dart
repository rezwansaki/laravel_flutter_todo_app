import 'package:flutter/material.dart';

class DetailsTodo extends StatelessWidget {
  final Map data;
  const DetailsTodo({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo - Details'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                'Todo id: ${data['id']}',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                'Todo title: ${data['title']}',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                'Todo body: ${data['body']}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          )),
    );
  }
}
