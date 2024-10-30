
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:todo/models/todo.dart';

class TodoStorage {

  static Box<Todo>todoBox = Hive.box("todoBox");
  static var log = Logger();

  static void saveTodo(String taskId,Todo newTodo){
    try {
      todoBox.put(taskId,newTodo);
    }catch(e){
      log.e("Error occurred , Cannot save into hive todoBox: $e");
    }
  }

  static Todo? getTodoTaskById(String todoTaskId){
    int count =  getAllTodos().where((todo)=>todo.taskId == todoTaskId).toList().length;
    late Todo? todo;
    if(count>1){
     log.w("More than one todo task found for same taskId $todoTaskId");
    }
    try {
      todo = todoBox.get(todoTaskId);
    }catch(e) {
      log.i("Error occurred cannot retrieve task for id $todoTaskId");
    }
    if(todo==null){
      log.w("Error occurred , Cannot find todo task for id $todoTaskId");
    }
    return todo;
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

  static void toggleTodoTaskStatus(Todo todo) {
    todoBox.put(todo.taskId, todo);
  }


}