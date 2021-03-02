EventType getEventType(String eventName) {
  if (eventName == "Anniversary") {
    return EventType.anniversary;
  } else if (eventName == "Babyshower") {
    return EventType.babyShower;
  }
  return EventType.any;
}

enum EventType {
  babyShower,
  anniversary,
  any,
}
