

import 'package:flutter/cupertino.dart';
import '../models/todo.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

class TaskProvider extends ChangeNotifier{

  final List<Todo> _todos = [new Todo(taskId: "id1",taskName: "Eat Dinner")];

  var log = Logger();
  var uuid = Uuid();

  List<Todo> get todos => _todos;

  int getLengthOfTodos(){
    print("length : ${_todos.length}");
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

  void createOrUpdateTodo(String taskName,String dueDate,String taskId){
    if(isTaskExisting(taskId)){
      updateTodo(taskName,dueDate,taskId);
      return;
    }
    taskName = taskName.trim();
    var todo = Todo(taskName: taskName,taskId: uuid.v4());
    if(dueDate.isNotEmpty)todo.setDueDate = dueDate;
    _todos.add(todo);
    log.i("Todo task ${todo.taskId} is created");
    notifyListeners();
  }

  void setTaskCompletionStatus(String taskId){
     var todo = getTaskById(taskId);
     todo.setCompletedStatus = !todo.isCompleted;
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

  void updateTodo(String taskName, String dueDate, String taskId) {
    var todo = getTaskById(taskId);
    todo.setTaskName = taskName;
    todo.setDueDate = dueDate;
    notifyListeners();
  }

  void checkAllLongPressedTasks() {
    _todos.where((todo)=>todo.isLongPress).forEach((todo)=> todo.setCompletedStatus = !todo.isCompleted);
    notifyListeners();
  }

}