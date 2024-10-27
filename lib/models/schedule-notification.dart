class ScheduleNotification{
  int year;
  int month;
  int day;
  int hour;
  int min;
  bool isScheduledDateAndTimeSelected = false;
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

  set setSelectedYear(int selectedYear) => year = selectedYear;
  set setSelectedMonth(int selectedMonth) => month = selectedMonth;
  set setSelectedDay(int selectedDay) => day = selectedDay;
  set setSelectedHour(int selectedHour) => hour = selectedHour;
  set setSelectedMin(int selectedMin) => min = selectedMin;
  set setSelectedDateAndTimeSelected(bool status) => isScheduledDateAndTimeSelected = status;





}