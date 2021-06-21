class APIPath {
  static String interests() => 'interests';

  static String products() => 'products';

  static String product(String productId) => 'products/$productId';

  static String events() => 'events';

  static String genders() => 'genders';

  static String favorites(String uid) => 'users/$uid/favorites';

  static String favorite(String uid, String productId) =>
      'users/$uid/favorites/$productId';

  static String friend(
    String uid,
    String friendId,
  ) =>
      'users/$uid/friends/$friendId';

  static String user(String uid) => 'users/$uid';

  static String friends(String uid) => 'users/$uid/friends';

  static String friendSpecialEvents(String uid, String friendId) =>
      'users/$uid/friends/$friendId/special_events';

  static String specialEvents(String uid) => 'users/$uid/special_events';

  static String specialEvent(String uid, String specialEventId) =>
      'users/$uid/special_events/$specialEventId';

  static String rootSpecialEvent(String specialEventId) =>
      'root_special_events/$specialEventId';
}
