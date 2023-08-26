import 'package:flutter/material.dart';

void main() => runApp(ToDoApp());

// Die Hauptklasse der App, die jetzt ein StatefulWidget ist, um den Zustand des Themas zu verwalten.
class ToDoApp extends StatefulWidget {
  @override
  _ToDoAppState createState() => _ToDoAppState();
}

class _ToDoAppState extends State<ToDoApp> {
  // Zustandsvariable, um zu überprüfen, ob der Dunkelmodus aktiviert ist.
  bool isDarkMode = false;

  // Methode, um das Thema zu wechseln.
  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo List',
      // Auswahl des Themas basierend auf dem isDarkMode-Zustand.
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: ToDoListScreen(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
    );
  }
}

class ToDoListScreen extends StatefulWidget {
  // Funktion und Zustandsvariable, die vom übergeordneten Widget übergeben werden.
  final Function toggleTheme;
  final bool isDarkMode;

  ToDoListScreen({required this.toggleTheme, required this.isDarkMode});

  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  bool isDarkMode = false;
  // Liste, die alle Aufgaben enthält.
  List<Task> tasks = [];
  List<Task> get _openTasks => tasks.where((task) => !task.isDone).toList();
  List<Task> get _doneTasks => tasks.where((task) => task.isDone).toList();

  // Methode zum Anzeigen eines Dialogs zum Hinzufügen/Bearbeiten von Aufgaben.
  Future<void> _showTaskDialog({Task? task, int? index}) async {
    String? taskTitle = task?.title;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              task == null ? 'Neue Aufgabe hinzufügen' : 'Aufgabe bearbeiten'),
          content: TextField(
            onChanged: (value) => taskTitle = value,
            decoration: InputDecoration(
              hintText: 'Aufgabentitel',
            ),
            controller: TextEditingController(text: task?.title),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text(task == null ? 'Hinzufügen' : 'Aktualisieren'),
              onPressed: () {
                setState(() {
                  if (task == null) {
                    tasks.add(Task(title: taskTitle!));
                  } else {
                    tasks[index!].title = taskTitle!;
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget _buildTaskItem(Task task) {
    return ListTile(
      title: Text(
        task.title,
        style: TextStyle(
          color: widget.isDarkMode ? Colors.white : null,
        ),
      ),
      trailing: Checkbox(
        value: task.isDone,
        onChanged: (value) {
          setState(() {
            task.isDone = value!;
          });
        },
      ),
      onTap: () {
        _showTaskDialog(task: task);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo List'),
        actions: <Widget>[
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme as void Function()?,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _openTasks.length + _doneTasks.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Offene Aufgaben",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            );
          } else if (index <= _openTasks.length) {
            final task = _openTasks[index - 1];
            return _buildTaskItem(task);
          } else if (index == _openTasks.length + 1) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Erledigte Aufgaben",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            );
          } else {
            final task = _doneTasks[index - _openTasks.length - 2];
            return _buildTaskItem(task);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showTaskDialog();
        },
      ),
    );
  }
}

class Task {
  String title;
  bool isDone;

  Task({required this.title, this.isDone = false});
}
