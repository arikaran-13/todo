
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/provider/task_provider.dart';

import '../../widgets/todo_tile.dart';

class InCompleteTasks extends StatefulWidget {
  const InCompleteTasks({super.key});

  @override
  State<InCompleteTasks> createState() => _InCompleteTasksState();
}

class _InCompleteTasksState extends State<InCompleteTasks> {
  @override
  Widget build(BuildContext context) {

    return Consumer<TaskProvider>(
        builder: (context,taskProvider,child){
          var inCompletedTodos = taskProvider.getInCompletedTodos();
          return Scaffold(
            backgroundColor: Colors.deepPurple[300],
            body: GestureDetector(
              onTap: (){ // this on tap ensures that if i click any area in body then it will unselect all selected item
                taskProvider.toggleLongPressStatusForAllSelectedTasks();
              },
              child: buildBodyForIncompleteTodos(inCompletedTodos,taskProvider),
            ),
          );
        }

    );
  }

  Widget buildBodyForIncompleteTodos(List<Todo> inCompletedTodos, TaskProvider taskProvider) {
    if (inCompletedTodos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                "assets/relax.png",
                height: 150.0,
                width: 150.0,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              "Nothing to do",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              "Enjoy your free time!",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: inCompletedTodos.length,
      itemBuilder: (context, index) {
        return TodoTile(
          todo: inCompletedTodos[index],
          taskProvider: taskProvider,
        );
      },
    );
  }
}
