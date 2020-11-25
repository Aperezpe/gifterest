class APIPath {
  static String interests() => 'interests';

  static String products() => 'products';

  static String product(String productId) => 'products/$productId';

  static String events() => 'events';

  static String friend(
    String uid,
    String friendId,
  ) =>
      'users/$uid/friends/$friendId';

  static String friends(String uid) => 'users/$uid/friends';
}
