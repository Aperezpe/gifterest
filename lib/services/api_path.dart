class APIPath {
  static String friend(String uid, String friendId) =>
      'users/$uid/friends/$friendId';
  static String friends(String uid) => 'users/$uid/friends';
  static String friendInterests(String uid, String friendId) =>
      'users/$uid/friends/$friendId/interests';
  static String interests() => 'interests';
}
