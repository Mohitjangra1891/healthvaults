String getDay(int day) {
  switch (day) {
    case 0:
      return "Sunday";
    case 1:
      return "Monday";
    case 2:
      return "Tuesday";
    case 3:
      return "Wednesday";
    case 4:
      return "Thursday";
    case 5:
      return "Friday";
    case 6:
      return "Saturday";
    default:
      return "";
  }
}

int getTodayDayIndex() {
  final now = DateTime.now();
  // Dart's DateTime.weekday returns 1 for Monday, ..., 7 for Sunday.
  // We want 0 for Sunday, ..., 6 for Saturday.
  return (now.weekday % 7);
}

// Assuming 'Constants' is a class with a static 'getDay' method and 'Utils'
// is a class with a static 'getTodayDayIndex' method in your original Kotlin code.
// In Flutter, you would directly call the functions defined above.
String getTodayDayName() {
  return getDay(getTodayDayIndex());
}
