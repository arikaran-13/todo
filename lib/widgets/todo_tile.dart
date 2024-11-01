
import 'package:flutter/material.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/provider/task_provider.dart';
import 'package:todo/routes/routes.dart';

class TodoTile extends StatefulWidget {

   final Todo todo;
   final TaskProvider taskProvider;

   const TodoTile({super.key,required this.todo,required this.taskProvider});

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
            borderRadius: BorderRadius.circular(15),
            color: Colors.deepPurple,
            border: Border.all(
              color: longPressStatus? Colors.white : Colors.deepPurple,
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
              activeColor: Colors.white,
              checkColor: Colors.black,
              side: const BorderSide(
                color: Colors.white
              ),
            ),
            title: Text(
                todo.taskName,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  decoration: todo.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationColor: Colors.white,
                  decorationThickness: 2.0
                ),
            ),
          ),
        ),
      ),
    );
  }
}
