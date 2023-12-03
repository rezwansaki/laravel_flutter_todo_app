import 'package:flutter/material.dart';

class SearchResultPage extends StatelessWidget {
  final Map data;
  const SearchResultPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Todo - Search Result'),
        ),
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: data['data'].length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading:
                  CircleAvatar(child: Text(data['data'][index]['title'][0])),
              title: Text(data['data'][index]['title']),
              onTap: () {},
            );
          },
        ));
  }
}
