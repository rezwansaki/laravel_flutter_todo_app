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
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: data['data'].length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                      child: Text(data['data'][index]['title'][0])),
                  title: Text(data['data'][index]['body']),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
