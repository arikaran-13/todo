import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/provider/task_provider.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final _key = GlobalKey<FormState>();
  final _taskNameController = TextEditingController();
  final _dateController = TextEditingController();
  bool isInitialised = false;
  String? taskId;

  @override
  void dispose() {
    _taskNameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(!isInitialised){
      var todoObj = ModalRoute.of(context)!.settings.arguments;
      if(todoObj != null){
        var todo = todoObj as Todo;
        taskId = todo.taskId;
        _taskNameController.text = todo.taskName;
        _dateController.text = todo.dueDate;
        isInitialised=true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<TaskProvider>(
        builder: (context,taskProvider,child){
          return Scaffold(
            backgroundColor: Colors.yellow[200],
            appBar: AppBar(
              backgroundColor: Colors.yellow,
              title: const Text("New Task"),
              elevation: 0.0,
              actions: [
                if(isInitialised)Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                    child: IconButton(
                        icon: const Icon(Icons.delete_rounded,
                        size: 30.0,
                        ),
                    onPressed: (){
                        taskProvider.removeTask(taskId??"");
                        Navigator.of(context).pop();
                    },
                    )
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
              child: Form(
                  key: _key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "What you need to do?",
                        style: _textStyleForLabel(),
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        controller: _taskNameController,
                        style: const TextStyle(
                            fontSize: 20.0
                        ),
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: "Enter Task Name",
                        ),
                      ),

                      const SizedBox(height: 50),
                      Text(
                          "Due date",
                          style: _textStyleForLabel()
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _dateController,
                              style: const TextStyle(
                                  fontSize: 20.0
                              ),
                              decoration: const InputDecoration(
                                  hintText: "Enter Due date"
                              ),
                              onTap: _showDatePicker,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0,0,5.0,0),
                              child: IconButton(
                                  icon: const Icon(
                                      Icons.calendar_month,
                                      size: 30,
                                  ),
                                  onPressed: ()=>_showDatePicker(),
                              )
                          ),
                        ],
                      )
                    ],
                  )
              ),
            ),
            floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.yellow,
                onPressed: () {
                  _createNewTask(taskProvider,taskId??'');
                  Navigator.pop(context);

                  },
                child: const Icon(Icons.check),
            ),
          );
        }
    );
  }

  TextStyle _textStyleForLabel(){
    return const TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.bold
    );
  }

  void _showDatePicker(){
    showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(6000)
    ).then((value)=>{
      if(value != null){
        _dateController.text = '${value.day}/${value.month}/${value.year}',
      }
    });
  }

  void _createNewTask(TaskProvider taskProvider,String taskId){
     var taskName = _taskNameController.text;
     var date = _dateController.text;
     if(taskName.isNotEmpty){
       taskProvider.createOrUpdateTodo(taskName, date,taskId);
     }

  }
}
