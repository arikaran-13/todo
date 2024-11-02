import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/todo.dart';

import '../../provider/task_provider.dart';
import '../../routes/routes.dart';
import '../../widgets/todo_tile.dart';

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
            backgroundColor: Colors.deepPurple.shade300,
            body: GestureDetector(
              onTap: (){
                taskProvider.toggleLongPressStatusForAllSelectedTasks();
              },
              child: buildScaffoldBodyBasedOnCompleteTodos(completedTodos, taskProvider)
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: (){
                  Navigator.of(context).pushNamed(
                      TodoAppRoutes.newTask
                  );
                },
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              heroTag: "FAB_completed_task",
            ),
          );
        }
    );
  }
  
  Widget buildScaffoldBodyBasedOnCompleteTodos(List<Todo>completedTodos,TaskProvider taskProvider){
    if(completedTodos.isEmpty){
      return const Center(
          child: Text(
            "No completed todos",
            style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold
            ),
          )
      );
    }
    return ListView.builder(
      itemCount: completedTodos.length,
      itemBuilder: (context,index){
        return TodoTile(
          todo: completedTodos[index],
          taskProvider: taskProvider,
        );
      },
    );
  }
  }
