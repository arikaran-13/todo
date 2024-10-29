
import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  String _taskid;
  @HiveField(1)
  String _taskName;
  @HiveField(2)
  bool _isCompleted;
  @HiveField(3)
  bool _isLongPress;
  @HiveField(4)
  String _dueDate;
  @HiveField(5)
  String _dueTime;
  @HiveField(6)
  String _remainderDate;
  @HiveField(7)
  String _remainderTime;

  Todo({
     String taskName = '',
     bool isCompleted = false,
     bool isLongPress = false,
     String taskId = '',
     String dueDate = '',
     String dueTime = '',
    String remainderDate ='',
    String remainderTime = ''
}): _taskid = taskId,
    _taskName = taskName,
    _isCompleted = isCompleted,
    _isLongPress = isLongPress,
    _dueDate = dueDate,
    _remainderDate = remainderDate,
    _remainderTime = remainderTime,
    _dueTime = dueTime;


  String get taskId => _taskid;
  bool get isCompleted => _isCompleted;
  bool get isLongPress => _isLongPress;
  String get taskName => _taskName;
  String get dueDate => _dueDate;
  String get dueTime => _dueTime;
  String get remainderDate => _remainderDate;
  String get remainderTime => _remainderTime;

  set setCompletedStatus(bool status) => _isCompleted = status;
  set setLongPressStatus(bool status) => _isLongPress = status;
  set setTaskName(String taskName) => _taskName = taskName;
  set setDueDate(String dueDate) => _dueDate = dueDate;
  set setDueTime(String dueTime) => _dueTime = dueTime;
  set setRemainderDate(String remainderDate) => _remainderDate = remainderDate;
  set setRemainderTime(String remainderTime) => _remainderTime = remainderTime;

  @override
  String toString() {
    return 'Todo(taskId: $taskId taskName: $taskName taskCompletionStatus: $isCompleted)';
  }

}