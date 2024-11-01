
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
            backgroundColor: Colors.yellow[200],
            body: GestureDetector(
              onTap: (){ // this on tap ensures that if i click any area in body then it will unselect all selected item
                taskProvider.toggleLongPressStatusForAllSelectedTasks();
              },
              child: ListView.builder(
                itemCount: inCompletedTodos.length,
                itemBuilder: (context,index){
                  return TodoTile(
                    todo: inCompletedTodos[index],
                    taskProvider: taskProvider,
                  );
                },
              ),
            ),
          );
        }

    );
  }
}
