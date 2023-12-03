import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/controllers/api/todo_controller.dart';
import 'package:todo_app/screens/details_todo.dart';
import 'package:todo_app/screens/register_page.dart';
import 'package:todo_app/widgets/error_snackbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  // create todo
  String _title = '';
  String _body = '';
  createTodoPressed() async {
    http.Response response = await TodoController.createTodo(_title, _body);
    Map responseMap = jsonDecode(response.body);
    if (response.statusCode == 201) {
      const snackBar = SnackBar(
        content: Text('Created Successfully!'),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      _titleController.clear();
      _bodyController.clear();
    } else {
      // ignore: use_build_context_synchronously
      errorSnackBar(context, responseMap.values.first[0]);
    }
  }

  // logout
  logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const RegisterPage(),
        ));
  }

  // to show all data from todos table
  Future showTodoPressed() async {
    http.Response response = await TodoController.showTodo();
    if (response.statusCode == 200) {
      Map responseMap = jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

  late Future futureData; // to call 'showTodoPressed' function

  @override
  void initState() {
    super.initState();
    futureData = showTodoPressed(); // automatically call when run the app
  }

  // update data
  late int id;
  String title = "";
  String body = "";
  updateTodoPressed() async {
    http.Response response = await TodoController.updateTodo(id, title, body);
    Map responseMap = jsonDecode(response.body);
    if (response.statusCode == 200) {
      const snackBar = SnackBar(
        content: Text('Update data successfully!'),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      // ignore: use_build_context_synchronously
      errorSnackBar(context, responseMap.values.first[0]);
    }
    // ignore: avoid_print
    //print('$id+$title+$body');
    return responseMap;
  }

  // delete data
  String delDataId = "";
  deleteTodoPressed() async {
    http.Response response = await TodoController.deleteTodo(delDataId);
    if (response.statusCode == 204) {
      const snackBar = SnackBar(
        content: Text('Delete data successfully!'),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      // ignore: use_build_context_synchronously
      errorSnackBar(context, 'Failed to delete!');
    }
    return response;
  }

  // search data
  String srchData = "d";
  searchTodoPressed() async {
    http.Response response = await TodoController.searchTodo(srchData);
    Map responseMap = jsonDecode(response.body);
    Route route =
        MaterialPageRoute(builder: (context) => DetailsTodo(data: responseMap));
    // ignore: use_build_context_synchronously
    Navigator.push(context, route);
    if (response.statusCode == 200) {
      const snackBar = SnackBar(
        content: Text('Search result!'),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      // ignore: use_build_context_synchronously
      errorSnackBar(context, 'Failed to delete!');
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: Text('Home Screen'),
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Title',
              ),
              onChanged: (value) {
                _title = value;
              },
              controller: _titleController,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Body',
              ),
              onChanged: (value) {
                _body = value;
              },
              controller: _bodyController,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => createTodoPressed(),
              child: const Text('Create Todo'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => logOut(),
              child: const Text('Logout'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                        children: [
                          TextField(
                            onChanged: (value) {
                              srchData = value;
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              searchTodoPressed();
                              Navigator.pop(context);
                            },
                            child: const Text('Search'),
                          )
                        ],
                      )),
              child: const Text('Search'),
            ),
            const SizedBox(height: 40),
            FutureBuilder(
              future: futureData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // print(snapshot.data.toString());
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!['length'],
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: CircleAvatar(
                            child: Text(
                                snapshot.data!['data'][index]['title'][0])),
                        title: Text(snapshot.data!['data'][index]['title']),
                        onTap: () {
                          Route route = MaterialPageRoute(
                              builder: (context) => DetailsTodo(
                                  data: snapshot.data!['data'][index]));
                          Navigator.push(context, route);
                        },
                        trailing: SizedBox(
                            width: 80,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => SimpleDialog(
                                              children: [
                                                TextField(
                                                  onChanged: (value) {
                                                    title = value;
                                                  },
                                                ),
                                                TextField(
                                                  onChanged: (value) {
                                                    body = value;
                                                  },
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      id = snapshot.data['data']
                                                          [index]['id'];
                                                      title = title;
                                                      body = body;
                                                    });
                                                    updateTodoPressed();
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Update'),
                                                )
                                              ],
                                            ));
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      delDataId = snapshot.data['data'][index]
                                              ['id']
                                          .toString();
                                    });
                                    deleteTodoPressed();
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            )),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  // ignore: avoid_print
                  print('data not found!');
                  return Text('${snapshot.error}');
                }
                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    ));
  }
}
