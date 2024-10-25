

import 'package:flutter/cupertino.dart';
import '../models/todo.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

class TaskProvider extends ChangeNotifier{

  final List<Todo> _todos = [new Todo(taskId: "id1",taskName: "Eat Dinner")];

  var log = Logger();
  var uuid = const Uuid();

  List<Todo> get todos => _todos;

  int getLengthOfTodos(){
    return _todos.length;
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
    _todos.removeWhere((todo)=>todo.isLongPress);
    notifyListeners();
  }

  void toggleLongPressStatusForAllSelectedTasks(){
    _todos.where((todo)=>todo.isLongPress).forEach((todo)=>todo.setLongPressStatus = !todo.isLongPress);
    notifyListeners();
  }

  void createOrUpdateTodo(
      String taskName,
      String dueDate,
      String dueTime,
      String taskId,
      String remainderDate,
      String remainderTime
      ){
    if(isTaskExisting(taskId)){
      updateTodo(taskName,dueDate,dueTime,taskId,remainderDate,remainderTime);
      return;
    }
    taskName = taskName.trim();
    var todo = Todo(taskName: taskName,taskId: uuid.v4());
    if(dueDate.isNotEmpty)todo.setDueDate = dueDate;
    if(dueTime.isNotEmpty)todo.setDueTime = dueTime;
    if(remainderDate.isNotEmpty)todo.setRemainderDate = remainderDate;
    if(remainderTime.isNotEmpty)todo.setRemainderTime = remainderTime;
    _todos.add(todo);
    print('updated ${todo.remainderDate}');
    log.i("Todo task ${todo.taskId} is created");
    notifyListeners();
  }

  void setTaskCompletionStatus(String taskId){
     var todo = getTaskById(taskId);
     todo.setCompletedStatus = !todo.isCompleted;
     notifyListeners();
  }




  void clearRemainderInfo({String? taskId}) {
    if(taskId!.isNotEmpty) {
      print('inside clear');
      var todo = getTaskById(taskId!);
      todo.setRemainderDate = '';
      todo.setRemainderTime = '';

    }
    print('notofy');
    notifyListeners();
  }

  Todo getTaskById(String taskId){
    var task = _todos.where((todo) => todo.taskId == taskId).toList();
    if(task.length>1){
      log.e('There is more than one task with same task id');
    }
    if(task.isEmpty){
      log.e("Cannot able to find the match for task id $taskId");
    }
    return task[0];
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

  void updateTodo(String taskName, String dueDate, String dueTime,String taskId,String remainderDate , String remainderTime) {
    var todo = getTaskById(taskId);
    todo.setTaskName = taskName;
    todo.setDueDate = dueDate;
    todo.setDueTime = dueTime;
    todo.setRemainderTime = remainderTime;
    todo.setRemainderDate = remainderDate;
    print('updated ${todo.remainderDate}');
    notifyListeners();
  }

  void checkAllLongPressedTasks() {
    _todos.where((todo)=>todo.isLongPress).forEach((todo)=> todo.setCompletedStatus = !todo.isCompleted);
    notifyListeners();
  }



}