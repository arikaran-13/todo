
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:todo/models/todo.dart';

class TodoStorage {

  static Box<Todo>todoBox = Hive.box("todoBox");
  static final log = Logger();

  static void saveTodo(String taskId,Todo newTodo){
    try {
      todoBox.put(taskId,newTodo);
    }catch(e){
      log.e("Error occurred , Cannot save into hive todoBox: $e");
    }
  }

  static Todo? getTodoTaskById(String todoTaskId){
      if(todoTaskId.isEmpty || !isTodoTaskExisting(todoTaskId)){
        log.e("Todo task is not existing for task id: $todoTaskId");
      }
      return todoBox.get(todoTaskId);
    }

  static List<Todo> getAllTodos(){
   late List<Todo> todos;
    try {
      todos = todoBox.values.toList();
    }catch(e){
      log.e("Error occurred , cannot read tasks from hive todoBox : $e");
    }
    return todos;
  }

  static void deleteTodoByTaskId(String taskId){
    try {
      todoBox.delete(taskId);
    }catch(e){
      log.e("Error occurred while deleting todo task $taskId : $e");
    }
  }
  
  static void updateTodoByTaskId(String taskId,Todo existingTodo){
    List<Todo> todos = getAllTodos().where((todo)=>todo.taskId == taskId).toList();
    if(todos.length>1){
      log.i("cannot update task , for same task id $taskId multiple todo tasks present");
      return;
    }
    try {
      if(!getAllTodos().any((todo)=>todo.taskId==taskId)){
        log.i("Cannot update todo task as no existing task exist for id $taskId");
      }
      else {
        todoBox.put(taskId, existingTodo);
      }
    }catch(e){
      log.e("Error occurred while updating todo task $taskId");
    }
  }

  static void deleteAll() {
    Hive.deleteBoxFromDisk("todoBox");
    log.i("Deleted todo box");
  }

  static void updateTodoTask(String taskId, bool longPressStatus) {
   Todo? todo =  todoBox.get(taskId);
   if(todo == null){
     log.e("Task not exist for task id $taskId");
     return;
   }
   todo.setLongPressStatus = longPressStatus;
   todoBox.put(taskId, todo);
  }

  static void deleteAllTodoLongPressedTasks() {
    getAllTodos().where((todo)=>todo.isLongPress).forEach((todo){
      todoBox.delete(todo.taskId);
    });
  }

  static void updateAllTodoLongPressStatus() {
    getAllTodos().where((todo)=>todo.isLongPress).forEach((todo){
       todo.setLongPressStatus = !todo.isLongPress;
      todoBox.put(todo.taskId, todo);
    });
  }

  static List<Todo> inCompleteTodos(){
    return getAllTodos().where((todo)=>!todo.isCompleted).toList();
  }


  static List<Todo> completedTodos(){
    return getAllTodos().where((todo)=>todo.isCompleted).toList();
  }

  static bool anyTodoTaskLongPressed(){
    return getAllTodos().any((todo)=>todo.isLongPress);
  }

  static bool isCompletedTodoTasksLongPressed(){
    return getAllTodos().where((todo)=>todo.isCompleted).any((todo)=>todo.isLongPress);
  }


  static bool isInCompleteTodoTasksLongPressed(){
    return getAllTodos().where((todo)=>!todo.isCompleted).any((todo)=>todo.isLongPress);
  }

  static void deleteTodo(String taskId) {
    if (!isTodoTaskExisting(taskId)) {
      log.w("Cannot delete todo task: Task not found for id: $taskId");
      return;
    }
    todoBox.delete(taskId);
  }

  static bool isTodoTaskExisting(String taskId){
    return getAllTodos().any((todo)=>todo.taskId == taskId);
  }

  static bool anyTaskCompleted(){
    return getAllTodos().any((todo)=>todo.isCompleted);
  }

  static void toggleAllLongPressedTaskCompletedStatus(){
    getAllTodos().where((todo)=>todo.isLongPress).forEach((todo){
      todo.setCompletedStatus = !todo.isCompleted;
      todoBox.put(todo.taskId, todo);
    });
  }

  static void toggleLongPressedStatusForTaskId(String taskId){
    if(isTodoTaskExisting(taskId)){
      var todo = todoBox.get(taskId);
      todo?.setLongPressStatus = !todo.isLongPress;
      todoBox.put(taskId, todo!);
      print(todoBox.get(taskId));
    }
    else{
      log.i("Task not found for id $taskId");
    }
  }

  static void updateTodoTaskCompletionStatusForParticularTaskId(String taskId) {
    if(isTodoTaskExisting(taskId)){
       var todo = todoBox.get(taskId);
       todo?.setCompletedStatus = !todo.isCompleted;
       todoBox.put(taskId, todo!);
    }else{
      log.w("Task Not found for id: $taskId");
    }
  }



}