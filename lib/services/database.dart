import 'package:bonobo/services/api_path.dart';
import 'package:bonobo/services/firestore_service.dart';
import 'package:bonobo/ui/screens/interests/models/interest.dart';
import 'package:bonobo/ui/screens/my_friends/models/friend.dart';
import 'package:flutter/material.dart';

abstract class Database {
  Future<void> setFriend(Friend friend);
  Future<void> deleteFriend(Friend friend);
  Stream<List<Friend>> friendsStream();
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
  final _service = FirestoreService.instance;

  Future<void> setFriend(Friend friend) async => await _service.setData(
        path: APIPath.friend(uid, friend.id),
        data: friend.toMap(),
      );

  Future<void> deleteFriend(Friend friend) async =>
      await _service.deleteData(path: APIPath.friend(uid, friend.id));

  Stream<List<Friend>> friendsStream() => _service.collectionStream(
        path: APIPath.friends(uid),
        builder: (data, documentId) => Friend.fromMap(data, documentId),
      );

  Stream<List<Interest>> interestStream() => _service.collectionStream(
        path: APIPath.interests(),
        builder: (data, nameId) => Interest.fromMap(data, nameId),
      );
}
