EventType getEventType(String eventName) {
  if (eventName == "Anniversary") {
    return EventType.anniversary;
  } else if (eventName == "Babyshower") {
    return EventType.babyShower;
  } else if (eventName == "Valentines") {
    return EventType.valentines;
  }
  return EventType.any;
}

enum EventType {
  babyShower,
  anniversary,
  valentines,
  any,
}
