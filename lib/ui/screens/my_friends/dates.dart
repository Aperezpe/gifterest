class Dates {
  // Gets remaining days for event Inclusiveley
  static int getRemainingDays(DateTime eventTime) {
    final now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    DateTime eventNow = DateTime(now.year, eventTime.month, eventTime.day);

    if (eventNow.isBefore(now)) {
      eventNow = DateTime(now.year + 1, eventTime.month, eventTime.day);
      return eventNow.difference(now).inDays;
    }
    return eventNow.difference(now).inDays;
  }
}
