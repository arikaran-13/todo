import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/pages/widgets/completed_tasks.dart';
import 'package:todo/pages/widgets/in_complete_tasks.dart';
import 'package:todo/storage/todo_storage.dart';
import 'package:todo/provider/task_provider.dart';
import 'package:todo/routes/routes.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var selectedIndex =0;

  final List<Widget>_widgets = [
    const InCompleteTasks(),
    const CompletedTasks(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context,taskProvider,child) {
        return  Scaffold(
            backgroundColor: Colors.deepPurple.shade300,
            appBar: AppBar(
              title: const Text(
                  "Todos",
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              actions: _buildAppBarActions(taskProvider),
            ),
            body: _widgets[selectedIndex],
          floatingActionButton: FloatingActionButton(
              onPressed: (){
                Navigator.of(context).pushNamed(
                    TodoAppRoutes.newTask
                );
              },
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add),
            heroTag: "FAB_home",
          ),
          bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.deepPurple,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white.withOpacity(0.8),
              currentIndex: selectedIndex,
              onTap: (currentSelectedIndex){
               setState(() {
                 selectedIndex = currentSelectedIndex;
               });
               taskProvider.toggleLongPressStatusForAllSelectedTasks(); // resetting long press status whenever switching between nav items
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                        Icons.home,
                      color: Colors.white,
                    ),
                    label: "Home"
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                        Icons.check_circle,
                      color: Colors.white,
                    ),
                    label: "Completed Todos"
                )
              ]
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
              child: Text(
                "No",
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              onPressed: () {
                taskProvider.checkAllLongPressedTasks();
                Navigator.of(context).pop();
              },
              child: const Text(
                  "Yes",
                style: TextStyle(
                  color: Colors.white
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
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
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
              child: Text(
                "No",
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              onPressed: () {
                taskProvider.removeAllTaskLongPressed();
                Navigator.of(context).pop();
              },
              child: const Text(
                  "Yes",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildAppBarActions(TaskProvider taskProvider){
       if(selectedIndex == 0){
         return _buildAppBarActionForIncompleteTasks(taskProvider);
       }
       return _buildAppBarActionForCompletedTasks(taskProvider);
  }

  List<Widget>_buildAppBarActionForIncompleteTasks(TaskProvider taskProvider){
    return [
      IconButton(icon: Icon(Icons.delete_forever),
        onPressed: (){
          TodoStorage.deleteAll();
        },),
      if(taskProvider.isIncompleteTodoTasksLongPressed())
        Checkbox(
          value: false,
          activeColor: Colors.white,
          checkColor: Colors.black,
          side: const BorderSide(
            color: Colors.white
          ),
          onChanged: (val){
            showAlertDialogBoxForCheckAllTaskButton(taskProvider);
          },
        ),
      if(taskProvider.isIncompleteTodoTasksLongPressed())
        IconButton(
            onPressed: (){
              showAlertDialogBoxForToDeleteTodoTasks(taskProvider);
            },
            icon: const Icon(
              Icons.delete_rounded,
              size: 28.0,
            )
        ),
    ];
  }

  List<Widget>_buildAppBarActionForCompletedTasks(TaskProvider taskProvider){
    return [
      IconButton(icon: Icon(Icons.delete_forever),
        onPressed: (){
          TodoStorage.deleteAll();
        },),
      if(taskProvider.isCompletedTodoTasksLongPressed())
        Checkbox(
          value: taskProvider.isAnyTodoTaskCompleted(),
          activeColor: Colors.white,
          checkColor: Colors.black,
          side: const BorderSide(
            color: Colors.white
          ),
          onChanged: (val){
            showAlertDialogBoxForCheckAllTaskButton(taskProvider);
          },
        ),
      if(taskProvider.isCompletedTodoTasksLongPressed())
        IconButton(
            onPressed: (){
              showAlertDialogBoxForToDeleteTodoTasks(taskProvider);
            },
            icon: const Icon(
              Icons.delete_rounded,
              size: 28.0,
            )
        ),
    ];
  }
}
