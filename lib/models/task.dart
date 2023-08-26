// models/task.dart

// Eine Klasse, die eine einzelne Aufgabe repräsentiert.
class Task {
  final String title; // Der Titel der Aufgabe.
  bool
      isDone; // Ein Boolean, der angibt, ob die Aufgabe erledigt ist oder nicht.

  // Ein Konstruktor, um eine neue Aufgabe zu erstellen.
  // Der Titel ist erforderlich, während "isDone" standardmäßig auf "false" gesetzt wird.
  Task({required this.title, this.isDone = false});
}
