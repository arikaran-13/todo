import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/schedule-notification.dart';
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
  final _timeController = TextEditingController();
  bool isInitialised = false;
  String? taskId;
  String formattedRemainderDate = '';
  String formattedRemainderTime = '';
  DateTime? pickedDate;
  TimeOfDay? pickedTime;
  bool isCompleted = false;
  ScheduleNotification scheduleNotification = ScheduleNotification();

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
        _timeController.text = todo.dueTime;
        formattedRemainderTime = todo.remainderTime;
        formattedRemainderDate = todo.remainderDate;
        print('todo remainder time and date ${todo.remainderDate}${todo.remainderTime}');
        isInitialised=true;
      }
    }
  }

  void _showDateTimePicker() async{
   var pickedDate = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(6000)
    );
   if(pickedDate==null)return;
   _dateController.text = '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
  }

  void _showTimePicker() async{
    var pickedTime =  await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if(pickedTime == null)return;
    var formattedMin = pickedTime.minute <= 9 ? '0${pickedTime.minute}': '${pickedTime.minute}';
    _timeController.text = '${pickedTime.hour}:$formattedMin';
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
                if(isInitialised)Checkbox(value: taskProvider.getTaskById(taskId!).isCompleted, onChanged: (b){
                    isCompleted = !isCompleted;
                    taskProvider.setTaskCompletionStatus(taskId!);
                }),
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
                          "Due date and time",
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
                                  hintText: "Select due date"
                              ),
                              onTap: _showDateTimePicker,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0,0,5.0,0),
                              child: IconButton(
                                  icon: const Icon(
                                      Icons.calendar_month,
                                      size: 30,
                                  ),
                                  onPressed: ()=>_showDateTimePicker(),
                              )
                          ),
                        ],
                      ),
                      const SizedBox(height: 30.0,),
                      Row(
                        children: [
                          if(_dateController.text.isNotEmpty)Expanded(
                            child: TextFormField(
                              onTap: _showTimePicker,
                              controller: _timeController,
                              style: const TextStyle(
                                  fontSize: 20.0
                              ),
                              decoration: const InputDecoration(
                                  hintText: "Select time"
                              ),
                            ),
                          ),
                          if(_dateController.text.isNotEmpty)Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                            child: IconButton(
                                onPressed: (){
                                   _showTimePicker();
                                },
                                icon: const Icon(
                                 Icons.access_time_filled_rounded,
                                 size: 30.0,
                                )
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        children :[ ElevatedButton.icon(
                            onPressed: () async{
                              await showDatePickerForRemainder();
                                int year, month, day, hour, min;
                                if (pickedDate != null) {
                                  year = pickedDate!.year;
                                  month = pickedDate!.month;
                                  day = pickedDate!.day;
                                } else {
                                  year = DateTime.now().year;
                                  month = DateTime.now().month;
                                  day = DateTime.now().day;
                                }
                                if (pickedTime != null) {
                                  hour = pickedTime!.hour;
                                  min = pickedTime!.minute;
                                } else {
                                  hour = 9; // Default hour
                                  min = 30; // Default minute
                                }
                                scheduleNotification.setSelectedMin = min;
                                scheduleNotification.setSelectedHour = hour;
                                scheduleNotification.setSelectedDay = day;
                                scheduleNotification.setSelectedYear = year;
                                scheduleNotification.setSelectedMonth = month;
                                scheduleNotification.setSelectedDateAndTimeSelected = true;
                            },
                            label: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                  isRemainderDateAndNotEmpty() ?
                                  "Remaind me $formattedRemainderTime\n$formattedRemainderDate":
                                    "Remaind me"
                              ),
                            ),
                          icon:  const Icon(
                              Icons.notifications_active_outlined,
                            size: 20.0,
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black, backgroundColor: Colors.yellow,
                          ),
                        ),
                          if (isRemainderDateAndNotEmpty())
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                              onPressed: (){
                                  setState(() {
                                    formattedRemainderDate = '';
                                    formattedRemainderTime = '';
                                  });
                                },
                            ),
                        ]
                      ),
                    ],
                  )
              ),
            ),
            floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.yellow,
                onPressed: () {
                  _createNewTask(taskProvider,taskId??'',scheduleNotification);
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

  bool isRemainderDateAndNotEmpty(){
    return (formattedRemainderDate.isNotEmpty || formattedRemainderTime.isNotEmpty);
  }

  bool isPickedDateAndTimeNotEmpty(){
    bool res = pickedDate != null || pickedTime!=null;
    return res ;
  }

  void _createNewTask(TaskProvider taskProvider,String taskId,ScheduleNotification scheduleNotification){
     var taskName = _taskNameController.text;
     var date = _dateController.text;
     var time = _timeController.text;
     if(taskName.isNotEmpty){
       taskProvider.createOrUpdateTodo(
           taskName,
           date,
           time,
           taskId,
           formattedRemainderDate,
           formattedRemainderTime,
           scheduleNotification
       );
     }
  }

  Future<void> showDatePickerForRemainder() async{
    pickedDate = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(6000));
    pickedTime = await showTimePicker(
       context: context,
       initialTime: const TimeOfDay(hour: 12,minute: 0)
   );
   formattedRemainderTime = "${pickedTime?.hour}:${pickedTime!.minute < 10 ? '0${pickedTime?.minute}' : '${pickedTime?.minute}'}";
   formattedRemainderDate = '${getWeekOfTheDay(pickedDate!.weekday)}, ${pickedDate?.day} ${getMonthName(pickedDate!.month)}';
  }

  String getWeekOfTheDay(int weekDay){
    switch (weekDay){
      case 1:
        return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return "Thu";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";
      default:{
        return "";
      }
    }
  }

  String getMonthName(int month) {
    switch (month) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "Aug";
      case 9:
        return "Sept";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
      default:
        return "";
    }
  }
}
