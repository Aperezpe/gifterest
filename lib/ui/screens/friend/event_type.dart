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

extension ParseToString on EventType {
  String toShortString() {
    switch (this) {
      case EventType.anniversary:
        return "Anniversary";
      case EventType.babyShower:
        return "BabyShower";
      case EventType.valentines:
        return "Valentines";
      default:
        return "";
    }
  }
}

enum EventType {
  babyShower,
  anniversary,
  valentines,
  any,
}
