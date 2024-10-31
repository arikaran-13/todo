

import 'package:flutter/cupertino.dart';
import 'package:todo/models/schedule-notification.dart';
import 'package:todo/storage/todo_storage.dart';
import '../models/todo.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import '../notification/notification.dart';

class TaskProvider extends ChangeNotifier{

  List<Todo> _todos = TodoStorage.getAllTodos();
  var log = Logger();
  var uuid = const Uuid();
  List<Todo> get todos => _todos;

  void reloadTodos(){
    _todos = TodoStorage.getAllTodos();
  }

  int getLengthOfTodos(){
    return _todos.length;
  }

  List<Todo> getInCompletedTodos(){
    return TodoStorage.inCompleteTodos();
  }

  List<Todo> getCompletedTodos(){
    return TodoStorage.completedTodos();
  }

  //TODO: need to update this
  void toggleLongPressStatus(String taskId){
    TodoStorage.toggleLongPressedStatusForTaskId(taskId);
    reloadTodos(); // check whether its needed or not
    notifyListeners();
  }


  bool isAnyTodoTaskLongPressed(){
    return TodoStorage.anyTodoTaskLongPressed();
  }

  void removeAllTaskLongPressed(){
    TodoStorage.deleteAllTodoLongPressedTasks();
    reloadTodos();
    notifyListeners();
  }

  void toggleLongPressStatusForAllSelectedTasks(){
    TodoStorage.updateAllTodoLongPressStatus();
    notifyListeners();
  }

  void createOrUpdateTodo(
      String taskName,
      String dueDate,
      String dueTime,
      String taskId,
      String remainderDate,
      String remainderTime,
      ScheduleNotification scheduleNotification
      ){
    if(isTaskExisting(taskId)){
      updateTodo(taskName,dueDate,dueTime,taskId,remainderDate,remainderTime,scheduleNotification);
      return;
    }
    Todo newTodo = createNewTodo(taskName,dueDate,dueTime,remainderDate,remainderTime);
    TodoStorage.saveTodo(newTodo.taskId,newTodo);
    createNotification(newTodo,scheduleNotification);
    reloadTodos();
    notifyListeners();
  }

  void setTaskCompletionStatus(String taskId){
     TodoStorage.updateTodoTaskCompletionStatusForParticularTaskId(taskId);
     notifyListeners();
  }

  //TODO: need to update this with hive
  void clearRemainderInfo({String? taskId}) {
    if(taskId!.isNotEmpty) {
      Todo? todo = getTaskById(taskId);
      if(todo == null)return;
      todo.setRemainderDate = '';
      todo.setRemainderTime = '';

    }
    notifyListeners();
  }

  Todo? getTaskById(String taskId){
    Todo? todo = TodoStorage.getTodoTaskById(taskId);
    if(todo==null){
      log.e("Cannot find todo tasks for $taskId");
    }
    return todo;
  }

  bool isTodoTaskCompleted(String taskId){
   Todo? todo =  getTaskById(taskId);
   if(todo == null){
     return false; // if the task is not present then its already deleted
   }
   return todo.isCompleted;
  }



  void removeTask(String taskId) {
    if (taskId.isNotEmpty && TodoStorage.isTodoTaskExisting(taskId)) {
      TodoStorage.deleteTodo(taskId);
      reloadTodos();
      notifyListeners();
    } else {
      log.w("Cannot delete todo task: Task not found for id: $taskId");
    }
  }

  bool isTaskExisting(String taskId){
    return TodoStorage.isTodoTaskExisting(taskId);
  }


  bool isAnyTodoTaskCompleted(){
    return TodoStorage.anyTaskCompleted();
  }

  void updateTodo(String taskName, String dueDate, String dueTime,String taskId,String remainderDate , String remainderTime,ScheduleNotification scheduleNotification) {
    Todo? existingTodo = getTaskById(taskId);
    if(existingTodo == null){
      return;
    }
    existingTodo.setTaskName = taskName;
    existingTodo.setDueDate = dueDate;
    existingTodo.setDueTime = dueTime;
    existingTodo.setRemainderTime = remainderTime;
    existingTodo.setRemainderDate = remainderDate;
    TodoStorage.updateTodoByTaskId(taskId, existingTodo);
    reloadTodos();
    createNotification(existingTodo, scheduleNotification);
    notifyListeners();
  }

  //TODO: need to update this
  void checkAllLongPressedTasks() {
    TodoStorage.toggleAllLongPressedTaskCompletedStatus();
    reloadTodos(); // check this is needed
    notifyListeners();
  }

  Todo createNewTodo(String taskName, String dueDate, String dueTime, String remainderDate, String remainderTime) {
    taskName = taskName.trim();
    var todo = Todo(taskName: taskName,taskId: uuid.v4());
    if(dueDate.isNotEmpty)todo.setDueDate = dueDate;
    if(dueTime.isNotEmpty)todo.setDueTime = dueTime;
    if(remainderDate.isNotEmpty)todo.setRemainderDate = remainderDate;
    if(remainderTime.isNotEmpty)todo.setRemainderTime = remainderTime;
    return todo;
  }

  void createNotification(Todo todo, ScheduleNotification scheduleNotification) {
    DateTime dateTime = DateTime(scheduleNotification.year,scheduleNotification.month,scheduleNotification.day,scheduleNotification.hour,scheduleNotification.min);
    if(!scheduleNotification.isScheduledDateAndTimeSelected){
      log.e("Remainder not set for task ${todo.taskName}");
      return;
    }
    if(dateTime.isAfter(DateTime.now())) {
     NotificationService().scheduleNotification(
         id: 0, // todo: for each task we need to generate the unique notification id
         title: "⏰ Reminder: ${todo.taskName}",
         body: "Don't forget! Finish '${todo.taskName}' by ${todo
             .dueDate} at ${todo.dueTime}. You've got this! 💪",
         scheduledDateTime: dateTime
     );
   }
   else{
     log.e("Remainder date time is in future/past");
   }
  }

  void updateTodoTaskLongPressStatusByTaskId(String taskId, bool longPressStatus) {
     TodoStorage.updateTodoTask(taskId,longPressStatus);
     notifyListeners();
  }


}