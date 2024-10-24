
class Todo {
  String _taskid;
  String _taskName;
  bool _isCompleted;
  bool _isLongPress;
  String _dueDate;
  String _dueTime;
  String _remainderDate;
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

}