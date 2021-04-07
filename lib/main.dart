import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<String>("tasksBox");
  runApp(MaterialApp(
    home: MyApp(),
    theme: ThemeData(primaryColor: Color(0xff0D3257)),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _textFieldController = TextEditingController();
  Box<String> tasksBox;

  @override
  void initState() {
    super.initState();
    tasksBox = Hive.box("tasksBox");
  }

  void onDeleteTask(int index) {
    tasksBox.deleteAt(index);
    return;
  }

  void onAddTask() {
    if (_textFieldController.text.isNotEmpty) {
      tasksBox.add(_textFieldController.text);
      Navigator.pop(context);
      _textFieldController.clear();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TODO"),
        brightness: Brightness.dark,
      ),
      body: ValueListenableBuilder(
        valueListenable: tasksBox.listenable(),
        builder: (BuildContext context, Box<String> value, Widget child) {
          if (tasksBox.length > 0) {
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: tasksBox.length,
              itemBuilder: (context, index) {
                print(tasksBox.getAt(index));
                return ListTile(
                  title: Text(tasksBox.getAt(index)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => onDeleteTask(index),
                  ),
                );
              },
            );
          } else {
            return EmptyList();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff0D3257),
        onPressed: () => showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add New Task'),
                content: TextField(
                    controller: _textFieldController,
                    decoration: InputDecoration(hintText: "Enter task"),
                    autofocus: true),
                actions: <Widget>[
                  TextButton(
                    child: Text('SAVE'),
                    onPressed: () => onAddTask(),
                  ),
                ],
              );
            }),
        child: Icon(Icons.add),
      ),
    );
  }
}

class EmptyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              child: Icon(Icons.inbox_outlined,
                  size: 80.0, color: Color(0xff0D3257))),
          Container(
            padding: EdgeInsets.only(top: 4.0),
            child: Text(
              "Don't have any tasks",
              style: TextStyle(fontSize: 20.0),
            ),
          )
        ],
      ),
    );
  }
}
