

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
    return _todos.where((todo)=>!todo.isCompleted).toList();
  }

  List<Todo> getCompletedTodos(){
    return _todos.where((todo)=>todo.isCompleted).toList();
  }

  void toggleLongPressStatus(String taskId){
    var todo = getTaskById(taskId);
    todo.setLongPressStatus= !todo.isLongPress;
    notifyListeners();
  }

  bool isAnyTodoTaskLongPressed(){
    return _todos.any((todo)=>todo.isLongPress);
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
     var todo = getTaskById(taskId);
     todo.setCompletedStatus = !todo.isCompleted;
     notifyListeners();
  }

  void clearRemainderInfo({String? taskId}) {
    if(taskId!.isNotEmpty) {
      var todo = getTaskById(taskId);
      todo.setRemainderDate = '';
      todo.setRemainderTime = '';

    }
    notifyListeners();
  }

  Todo getTaskById(String taskId){
    Todo? todo = TodoStorage.getTodoTaskById(taskId);
    if(todo==null){
      log.e("Cannot find todo tasks for $taskId");
    }
    return todo!;
  }

  void removeTask(String taskId){
    if(isTaskExisting(taskId)){
      var delete = getTaskById(taskId);
      _todos.remove(delete);
    }
    else{
      log.e("Cannot delete , Task $taskId not found");
    }
    notifyListeners();
  }

  bool isTaskExisting(String taskId){
    return _todos.any((todo)=>todo.taskId==taskId);
  }

  bool isAnyTodoTaskCompleted(){
    return _todos.any((todo)=>todo.isCompleted);
  }
  void updateTodo(String taskName, String dueDate, String dueTime,String taskId,String remainderDate , String remainderTime,ScheduleNotification scheduleNotification) {
    var existingTodo = getTaskById(taskId);
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

  void checkAllLongPressedTasks() {
    _todos.where((todo)=>todo.isLongPress).forEach((todo)=> todo.setCompletedStatus = !todo.isCompleted);
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