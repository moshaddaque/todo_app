import 'package:flutter/material.dart';
import 'package:todo_app/TodoDetailScreen/todo_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class Todo {
  String title;
  String description;
  bool isDone;

  Todo({required this.title, this.description = "", this.isDone = false});
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Todo> todos = <Todo>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
        actions: [
          IconButton(
            onPressed: () {
              _removeAll();
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: _buildTodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodo();
        },
        child: const Icon(
          Icons.add,
          size: 35,
        ),
      ),
    );
  }

  // build todo_list
  ListView _buildTodoList() {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return todoItem(todo, index);
      },
    );
  }

  // todo_item
  Container todoItem(todo, int index) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black12,
          width: 1,
        ),
      ),
      child: ListTile(
        // checkbox
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Transform.scale(
            scale: 1.5,
            child: Checkbox(
              checkColor: Colors.green,
              side: const BorderSide(color: Colors.black45, width: 2),
              autofocus: true,
              value: todo.isDone,
              onChanged: (bool? value) {
                setState(() {
                  todo.isDone = value ?? false;
                });
              },
            ),
          ),
        ),

        // title
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),

        // navigate another page
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TodoDetailScreen(
              index: index,
              todo: todo,
              updateTodo: _updateTodo,
            ),
          ));
        },

        // show dialog for edit
        onLongPress: () => _editTodo(index),

        // delete list item
        trailing: IconButton(
          onPressed: () {
            _removeTodo(index);
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.redAccent,
            size: 30,
          ),
        ),
      ),
    );
  }

  // add todo_item
  void _addTodo() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController titleController = TextEditingController();
        TextEditingController descriptionController = TextEditingController();
        return AlertDialog(
          title: const Text("Add a new task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Write Title",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: "Write Description",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  todos.add(
                    Todo(
                      title: titleController.text,
                      description: descriptionController.text,
                    ),
                  );
                });
              },
              child: const Text("Save"),
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceBetween,
        );
      },
    );
  }

  // remove todo_item
  void _removeTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
  }

  // remove all todo_item
  void _removeAll() {
    setState(() {
      todos.clear();
    });
  }

  void _updateTodo(int index, Todo updateTodo) {
    setState(() {
      todos[index] = updateTodo;
    });
  }

  void _editTodo(int index) {
    Todo todo = todos[index];
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    titleController.text = todo.title;
    descriptionController.text = todo.description;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update Your Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Update task Title',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Update Description',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (titleController.text.isNotEmpty) {
                  setState(() {
                    todo.title = titleController.text;
                    if (descriptionController.text.isEmpty) {
                      descriptionController.text = "";
                    }
                    todo.description = descriptionController.text;
                  });
                }
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }
}
