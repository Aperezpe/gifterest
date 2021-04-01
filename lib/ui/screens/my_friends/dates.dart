class Dates {
  // Gets remaining days for event Exclusively
  static int getRemainingDays(DateTime eventTime) {
    final now = DateTime.now();
    DateTime eventNow = DateTime(now.year, eventTime.month, eventTime.day);

    if (eventNow.isBefore(now)) {
      eventNow = DateTime(now.year + 1, eventTime.month, eventTime.day);
      return eventNow.difference(now).inDays;
      // return eventNow.difference(now).inDays + 1; // Inclusive
    }
    return eventNow.difference(now).inDays;
    // return eventNow.difference(now).inDays + 1; // Inclusive
  }
}
