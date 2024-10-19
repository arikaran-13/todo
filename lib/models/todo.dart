
class Todo {
  String _taskid;
  String _taskName;
  bool _isCompleted;
  bool _isLongPress;
  String _dueDate;

  Todo({
     String taskName = '',
     bool isCompleted = false,
     bool isLongPress = false,
     String taskId = '',
     String dueDate = '',
}): _taskid = taskId,
    _taskName = taskName,
    _isCompleted = isCompleted,
    _isLongPress = isLongPress,
    _dueDate = dueDate;


  String get taskId => _taskid;
  bool get isCompleted => _isCompleted;
  bool get isLongPress => _isLongPress;
  String get taskName => _taskName;
  String get dueDate => _dueDate;

  set setCompletedStatus(bool status) => _isCompleted = status;
  set setLongPressStatus(bool status) => _isLongPress = status;
  set setTaskName(String taskName) => _taskName = taskName;
  set setDueDate(String dueDate) => _dueDate = dueDate;

}