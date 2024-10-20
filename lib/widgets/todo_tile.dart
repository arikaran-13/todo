
import 'package:flutter/material.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/provider/task_provider.dart';
import 'package:todo/routes/routes.dart';

class TodoTile extends StatefulWidget {

   Todo todo;
   TaskProvider taskProvider;

   TodoTile({super.key,required this.todo,required this.taskProvider});

  @override
  State<TodoTile> createState() => _TodoTileState();
}

class _TodoTileState extends State<TodoTile> {

  @override
  Widget build(BuildContext context) {
    final  todo = widget.todo;
    final  taskProvider = widget.taskProvider;
    final longPressStatus = todo.isLongPress;

    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed(
          TodoAppRoutes.newTask,
          arguments: todo
        );
      },
      onLongPress: (){
        taskProvider.toggleLongPressStatus(todo.taskId);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.yellow,
            border: Border.all(
              color: longPressStatus? Colors.black : Colors.yellow,
              width: longPressStatus? 2.0 : 0
            )
          ),
          padding: const EdgeInsets.all(10),
          child: ListTile(
            leading: Checkbox(
                value: todo.isCompleted,
                onChanged: (val){
                 taskProvider.setTaskCompletionStatus(todo.taskId);
              },
              activeColor: Colors.black,
            ),
            title: Text(
                todo.taskName,
                style: TextStyle(
                  fontSize: 20.0,
                  decoration: todo.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none
                ),
            ),
          ),
        ),
      ),
    );
  }
}
