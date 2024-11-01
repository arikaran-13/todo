import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/task_provider.dart';
import '../routes/routes.dart';
import '../widgets/todo_tile.dart';

class CompletedTasks extends StatefulWidget {
  const CompletedTasks({super.key});

  @override
  State<CompletedTasks> createState() => _CompletedTasksState();
}

class _CompletedTasksState extends State<CompletedTasks> {

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
        builder: (context,taskProvider,child) {
          var completedTodos = taskProvider.getCompletedTodos();
          return  Scaffold(
            backgroundColor: Colors.yellow[200],
            body: GestureDetector(
              onTap: (){
                taskProvider.toggleLongPressStatusForAllSelectedTasks();
              },
              child: ListView.builder(
                itemCount: completedTodos.length,
                itemBuilder: (context,index){
                  return TodoTile(
                    todo: completedTodos[index],
                    taskProvider: taskProvider,
                  );
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.yellow,
              onPressed: (){
                Navigator.of(context).pushNamed(
                    TodoAppRoutes.newTask
                );
              },
              child: const Icon(Icons.add),
            ),
          );
        }
    );
  }
  }
