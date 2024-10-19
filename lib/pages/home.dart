import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/widgets/todo_tile.dart';
import 'package:todo/provider/task_provider.dart';
import 'package:todo/routes/routes.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context,taskProvider,child) {
        return  Scaffold(
            backgroundColor: Colors.yellow[200],
            appBar: AppBar(
              title: const Text("Todo"),
              backgroundColor: Colors.yellow,
              elevation: 0,
              actions: [
                if(taskProvider.isAnyTodoTaskLongPressed()) IconButton(
                    onPressed: (){
                      taskProvider.checkAllLongPressedTasks();
                    },
                    icon: const Icon(
                      Icons.check_box,
                      size: 30.0,
                    )
                ),
                if(taskProvider.isAnyTodoTaskLongPressed())  IconButton(
                    onPressed: (){
                      taskProvider.removeAllTaskLongPressed();
                    },
                    icon: const Icon(
                        Icons.delete_rounded,
                        size: 30.0,
                    )
                ),

              ],
            ),
            body: ListView.builder(
                itemCount: taskProvider.getLengthOfTodos(),
                itemBuilder: (context,index){
                  return TodoTile(
                    todo: taskProvider.todos[index],
                    taskProvider: taskProvider,
                  );
                },
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
