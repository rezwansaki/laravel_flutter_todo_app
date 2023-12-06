import 'package:flutter/material.dart';

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
      ),
    );
  }
}
