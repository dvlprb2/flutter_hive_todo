import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_tutorials/task.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('todo_box');
  runApp(MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0xff0D3257)),
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Box<Task> tasksBox;
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tasksBox = Hive.box('todo_box');
  }

  void onAddTask() {
    if (_textEditingController.text.isNotEmpty) {
      final newTask = Task(_textEditingController.text, false);
      tasksBox.add(newTask);
      Navigator.pop(context);
      _textEditingController.clear();
      return;
    }
  }

  void onUpdateTask(int index, Task task) {
    tasksBox.putAt(index, Task(task.title, !task.completed));
    return;
  }

  void onDeleteTask(int index) {
    tasksBox.deleteAt(index);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO'),
        brightness: Brightness.dark,
      ),
      body: ValueListenableBuilder(
        valueListenable: tasksBox.listenable(),
        builder: (context, value, child) {
          if (tasksBox.length > 0) {
            return ListView.separated(
              itemBuilder: (context, index) {
                final task = tasksBox.get(index);

                return ListTile(
                  title: Text(task.title),
                  leading: Checkbox(
                      activeColor: Color(0x800d3257),
                      value: task.completed,
                      onChanged: (bool value) => onUpdateTask(index, task)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => onDeleteTask(index),
                  ),
                );
              },
              itemCount: tasksBox.length,
              separatorBuilder: (context, index) => Divider(),
            );
          } else {
            return EmptyList();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff0D3257),
        child: Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Add New Task'),
              content: TextField(
                controller: _textEditingController,
                decoration: InputDecoration(hintText: "Enter task"),
                autofocus: true,
              ),
              actions: [
                TextButton(onPressed: () => onAddTask(), child: Text('SAVE'))
              ],
            );
          },
        ),
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
