import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/storage/todo_storage.dart';
import 'package:todo/widgets/todo_tile.dart';
import 'package:todo/provider/task_provider.dart';
import 'package:todo/routes/routes.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var selectedIndex =0;
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context,taskProvider,child) {
        var inCompletedTodos = taskProvider.getInCompletedTodos();
        return  Scaffold(
            backgroundColor: Colors.yellow[200],
            appBar: AppBar(
              title: const Text("Todo(s)"),
              backgroundColor: Colors.yellow,
              elevation: 0,
              centerTitle: true,
              actions: _buildAppBarActions(taskProvider),
            ),
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

  void showAlertDialogBoxForCheckAllTaskButton(TaskProvider taskProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Confirm Action",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Do you want to change the status of the selected task(s)?",
            style: TextStyle(fontSize: 17.0),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "No",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amberAccent),
              onPressed: () {
                taskProvider.checkAllLongPressedTasks();
                Navigator.of(context).pop();
              },
              child: const Text(
                  "Yes",
                style: TextStyle(
                  color: Colors.black
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  void showAlertDialogBoxForToDeleteTodoTasks(TaskProvider taskProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Confirm Action",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Delete selected tasks?",
            style: TextStyle(fontSize: 17.0),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "No",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                taskProvider.removeAllTaskLongPressed();
                Navigator.of(context).pop();
              },
              child: const Text(
                  "Yes",
                style: TextStyle(
                  color: Colors.black
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildAppBarActions(TaskProvider taskProvider){
    return [
      //Todo: remove this button after development
      IconButton(icon: Icon(Icons.delete_forever),
        onPressed: (){
          TodoStorage.deleteAll();
        },),
      if(taskProvider.isIncompleteTodoTasksLongPressed())
        Checkbox(
          value: taskProvider.isAnyTodoTaskCompleted(),
          onChanged: (val){
            showAlertDialogBoxForCheckAllTaskButton(taskProvider);
          },
        ),
      if(taskProvider.isIncompleteTodoTasksLongPressed())IconButton(
          onPressed: (){
            showAlertDialogBoxForToDeleteTodoTasks(taskProvider);
          },
          icon: const Icon(
            Icons.delete_rounded,
            size: 28.0,
          )
      ),
      IconButton(
          onPressed: (){
            Navigator.of(context).pushNamed(TodoAppRoutes.completedTask);
          },
          icon: const Icon(Icons.check_circle_outline)
      )
    ];
  }

}
