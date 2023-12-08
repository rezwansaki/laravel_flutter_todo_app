import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/controllers/api/todo_controller.dart';
import 'package:todo_app/screens/details_todo.dart';
import 'package:todo_app/screens/register_page.dart';
import 'package:todo_app/screens/search_result.dart';

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
      // refresh page after update
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));

      const snackBar = SnackBar(
        content: Text('Created Successfully!'),
        duration: Duration(seconds: 1),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      _titleController.clear();
      _bodyController.clear();
    } else {
      _showMyDialog("Alert Message", "Failed to create!");
    }
    return responseMap;
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
      return responseMap;
    } else {
      _showMyDialog(
          "Alert Message", "Failed to load data! Please, restart the app.");
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
      // refresh page after update
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));
    } else {
      _showMyDialog("Alert Message", "Failed to update!");
    }
    return responseMap;
  }

  // delete data
  String delDataId = "";
  deleteTodoPressed() async {
    http.Response response = await TodoController.deleteTodo(delDataId);
    if (response.statusCode == 204) {
      // refresh page after update
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));

      const snackBar = SnackBar(
        content: Text('Delete data successfully!'),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      _showMyDialog("Alert Message", "Failed to delete!");
    }
    return response;
  }

  // search data
  String srchData = "";
  searchTodoPressed() async {
    http.Response response = await TodoController.searchTodo(srchData);
    if (response.statusCode == 200) {
      Map responseMap = jsonDecode(response.body);
      Route route = MaterialPageRoute(
          builder: (context) => SearchResultPage(data: responseMap));
      // ignore: use_build_context_synchronously
      Navigator.push(context, route);
    } else {
      // if response.statusCode is 404 then
      // ignore: avoid_print
      print('Data not found!');
      // ignore: use_build_context_synchronously
      //errorSnackBar(context, 'Data not found!');
      // ignore: use_build_context_synchronously
      _showMyDialog("Alert Message", "Data not found!");
    }
    return response;
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
      debugShowCheckedModeBanner: false,
      title: 'Todo - Home',
      home: ScaffoldMessenger(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Todo - Home'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.search),
                tooltip: 'Search',
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => SimpleDialog(
                            children: [
                              const Center(
                                child: Text(
                                  'Search Data',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextField(
                                  autofocus: true,
                                  onChanged: (value) {
                                    srchData = value;
                                  },
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    searchTodoPressed();
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Search',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ));
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Logout',
                onPressed: () {
                  logOut();
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => SimpleDialog(
                  children: [
                    const Center(
                        child: Text(
                      'Create Todo',
                    )),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'Title',
                        ),
                        onChanged: (value) {
                          _title = value;
                        },
                        style: const TextStyle(color: Colors.black),
                        controller: _titleController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Body',
                        ),
                        onChanged: (value) {
                          _body = value;
                        },
                        style: const TextStyle(color: Colors.black),
                        controller: _bodyController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                          onPressed: () => {
                                createTodoPressed(),
                              },
                          child: const Text('Create')),
                    )
                  ],
                ),
              );
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future: futureData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data['data'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black12,
                                ),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                    child: Text(snapshot.data!['data'][index]
                                            ['id']
                                        .toString())),
                                title: Text(
                                    snapshot.data!['data'][index]['title']),
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
                                        Expanded(
                                          child: IconButton(
                                            onPressed: () {
                                              // passing data when press edit button
                                              title = snapshot.data!['data']
                                                  [index]['title'];
                                              body = snapshot.data!['data']
                                                  [index]['body'];
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      SimpleDialog(
                                                        children: [
                                                          const SizedBox(
                                                              height: 8),
                                                          const Center(
                                                              child: Text(
                                                            'Edit Todo',
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )),
                                                          const SizedBox(
                                                              height: 5),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(12.0),
                                                            child: TextField(
                                                              controller: TextEditingController(
                                                                  text: snapshot
                                                                              .data!['data']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'title']),
                                                              decoration:
                                                                  const InputDecoration(
                                                                      labelText:
                                                                          'Title'),
                                                              onChanged:
                                                                  (value) {
                                                                title = value;
                                                              },
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(12.0),
                                                            child: TextField(
                                                              controller: TextEditingController(
                                                                  text: snapshot
                                                                              .data!['data']
                                                                          [
                                                                          index]
                                                                      ['body']),
                                                              decoration:
                                                                  const InputDecoration(
                                                                      labelText:
                                                                          'Body'),
                                                              onChanged:
                                                                  (value) {
                                                                body = value;
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(12.0),
                                                            child:
                                                                ElevatedButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  id = snapshot
                                                                              .data[
                                                                          'data']
                                                                      [
                                                                      index]['id'];
                                                                  title = title;
                                                                  body = body;
                                                                });
                                                                updateTodoPressed();
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                'Update',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ));
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title:
                                                          const Text("Confirm"),
                                                      content:
                                                          const SingleChildScrollView(
                                                        child: ListBody(
                                                          children: <Widget>[
                                                            Text(
                                                                "Are you sure?")
                                                          ],
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        ElevatedButton(
                                                          child:
                                                              const Text("No"),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        ElevatedButton(
                                                          child:
                                                              const Text("Yes"),
                                                          onPressed: () {
                                                            setState(() {
                                                              delDataId = snapshot
                                                                  .data['data']
                                                                      [index]
                                                                      ['id']
                                                                  .toString();
                                                            });
                                                            deleteTodoPressed();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        // ignore: avoid_print
                        print('data not found!');
                        return Text('${snapshot.error}');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
