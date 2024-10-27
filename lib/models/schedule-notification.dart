class ScheduleNotification{
  int year;
  int month;
  int day;
  int hour;
  int min;

  ScheduleNotification({
    int selectedYear = 0,
    int selectedMonth = 0,
    int selectedDay = 0,
    int selectedHour = 0,
    int selectedMin =0
  }):  year = selectedYear ,
        month = selectedMonth ,
        day = selectedDay,
        hour = selectedHour,
        min = selectedMin;

  int get selectedYear => year;
  int get selectedMonth => month;
  int get selectedDay => day;
  int get selectedHour => hour;
  int get selectedMin => min;

  set setSelectedYear(int selectedYear) => year;
  set setSelectedMonth(int selectedMonth) => month;
  set setSelectedDay(int selectedDay)=> day;
  set setSelectedHour(int selectedHour)=> hour;
  set setSelectedMin(int selectedMin)=> min;




}