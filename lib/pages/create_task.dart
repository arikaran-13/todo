import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/schedule-notification.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/provider/task_provider.dart';
import 'package:todo/storage/todo_storage.dart';

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
  String taskId = '';
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
    if (!isInitialised) {
      var todoObj = ModalRoute
          .of(context)!
          .settings
          .arguments;
      if (todoObj != null) {
        var todo = todoObj as Todo;
        taskId = todo.taskId;
        _taskNameController.text = todo.taskName;
        _dateController.text = todo.dueDate;
        _timeController.text = todo.dueTime;
        formattedRemainderTime = todo.remainderTime;
        formattedRemainderDate = todo.remainderDate;
        isInitialised = true;
      }
    }
  }

  void _showDateTimePicker() async {
    var pickedDate = await showDatePicker(
        context: context, firstDate: DateTime.now(), lastDate: DateTime(6000));
    if (pickedDate == null) return;
    _dateController.text =
    '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
  }

  void _showTimePicker() async {
    var pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (pickedTime == null) return;
    var formattedMin = pickedTime.minute <= 9
        ? '0${pickedTime.minute}'
        : '${pickedTime.minute}';
    _timeController.text = '${pickedTime.hour}:$formattedMin';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(builder: (context, taskProvider, child) {
      return Scaffold(
        backgroundColor: Colors.deepPurple.shade300,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white
          ),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
          title: const Text(
            "Create Task",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 0.0,
          actions: [
            if (isInitialised)
              Checkbox(
                  checkColor: Colors.black,
                  activeColor: Colors.white,
                  side: const BorderSide(
                    color: Colors.white
                  ),
                  value: taskProvider.isTodoTaskCompleted(taskId),
                  onChanged: (b) {
                    taskProvider.setTaskCompletionStatus(taskId);
                  }),
            if (isInitialised)
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete_rounded,
                      size: 30.0,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (taskId.isNotEmpty &&
                          TodoStorage.isTodoTaskExisting(taskId)) {
                        taskProvider.removeTask(taskId);
                      }
                      Navigator.of(context).pop();
                    },
                  ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
          child: Form(
            key: _key,
            child: ListView(
              children: [
                _buildLabel("What you need to do?"),
                _buildTextField(_taskNameController, "Enter Task Name"),
                const SizedBox(height: 40),
                _buildLabel("Due date and time"),
                Row(
                  children: [
                    Expanded(
                      child: _buildDateTimeField(
                        _dateController,
                        "Select due date",
                        _showDateTimePicker,
                        Icons.calendar_today,
                      ),
                    ),
                    if (_dateController.text.isNotEmpty)
                      Expanded(
                        child: _buildDateTimeField(
                          _timeController,
                          "Select time",
                          _showTimePicker,
                          Icons.access_time,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        await showDatePickerForRemainder();
                        int year, month, day, hour, min;
                        if (pickedDate != null) {
                          year = pickedDate!.year;
                          month = pickedDate!.month;
                          day = pickedDate!.day;
                        } else {
                          year = DateTime
                              .now()
                              .year;
                          month = DateTime
                              .now()
                              .month;
                          day = DateTime
                              .now()
                              .day;
                        }
                        if (pickedTime != null) {
                          hour = pickedTime!.hour;
                          min = pickedTime!.minute;
                        } else {
                          hour = 9;
                          min = 30;
                        }
                        scheduleNotification.setSelectedMin = min;
                        scheduleNotification.setSelectedHour = hour;
                        scheduleNotification.setSelectedDay = day;
                        scheduleNotification.setSelectedYear = year;
                        scheduleNotification.setSelectedMonth = month;
                        scheduleNotification.setSelectedDateAndTimeSelected =
                        true;
                      },
                      label: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          isRemainderDateAndNotEmpty()
                              ? "Remind me at $formattedRemainderTime\non $formattedRemainderDate"
                              : "Set Reminder",
                        ),
                      ),
                      icon: const Icon(
                        Icons.notifications_active_outlined,
                        size: 20.0,
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurple,
                      ),
                    ),
                    if (isRemainderDateAndNotEmpty())
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            formattedRemainderDate = '';
                            formattedRemainderTime = '';
                          });
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          onPressed: () {
            _createNewTask(taskProvider, taskId ?? '', scheduleNotification);
            Navigator.pop(context);
          },
          heroTag: "FAB_create_new_task",
          child: const Icon(Icons.check),
        ),
      );
    });
  }

  Padding _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  TextFormField _buildTextField(TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: 18.0, color: Colors.white),
      maxLines: null,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white10,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDateTimeField(TextEditingController controller, String hint,
      Function() onTap, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.white,
        style: const TextStyle(fontSize: 18.0, color: Colors.white),
        readOnly: true,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white12,
          prefixIcon: Icon(icon, color: Colors.white),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  bool isRemainderDateAndNotEmpty() {
    return formattedRemainderDate.isNotEmpty ||
        formattedRemainderTime.isNotEmpty;
  }

  void _createNewTask(TaskProvider taskProvider, String taskId,
      ScheduleNotification scheduleNotification) {
    var taskName = _taskNameController.text;
    var date = _dateController.text;
    var time = _timeController.text;
    if (taskName.isNotEmpty) {
      taskProvider.createOrUpdateTodo(
          taskName,
          date,
          time,
          taskId,
          formattedRemainderDate,
          formattedRemainderTime,
          scheduleNotification);
    }
  }

  Future<void> showDatePickerForRemainder() async {
    pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    pickedTime =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    formattedRemainderTime = "${pickedTime?.hour}:${pickedTime!.minute < 10 ? '0${pickedTime?.minute}' : '${pickedTime?.minute}'}";
    formattedRemainderDate = '${getWeekOfTheDay(pickedDate!.weekday)}, ${pickedDate?.day} ${getMonthName(pickedDate!.month)}';
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
}
