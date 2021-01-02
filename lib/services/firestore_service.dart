import 'package:bonobo/ui/screens/my_friends/models/friend.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../extensions/string_capitalize.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    await reference.setData(data);
  }

  Future<void> deleteData({String path}) async {
    final reference = Firestore.instance.document(path);
    await reference.delete();
  }

  Stream<List<T>> queryInterestsStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentId),
    @required Friend friend,
  }) {
    CollectionReference ref = Firestore.instance.collection(path);
    Query query;

    // Query interests by friend age
    if (friend.age < 3) {
      query = ref.where('age_range', arrayContains: 0);
    } else if (friend.age >= 3 && friend.age < 12) {
      query = ref.where('age_range', arrayContains: 3);
    } else {
      query = ref.where('age_range', arrayContains: 12);
    }

    //TODO: Make sure that friend.gender is NEVER null
    query = query.where('gender', whereIn: [
      "any",
      friend.gender.capitalize(),
      friend.gender.unCapitalize()
    ]);

    final snapshots = query.snapshots();
    return snapshots.map((snapshots) => snapshots.documents
        .map((snapshot) => builder(snapshot.data, snapshot.documentID))
        .toList());
  }

  Stream<List<T>> queryProductsStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentId),
    @required Friend friend,
    @required int startPrice,
    @required int endPrice,
  }) {
    CollectionReference ref = Firestore.instance.collection(path);
    Query query;

    if (friend.age < 3) {
      query = ref.where('age_range', arrayContains: 0);
    } else if (friend.age >= 3 && friend.age < 12) {
      query = ref.where('age_range', arrayContains: 3);
    } else {
      query = ref.where('age_range', arrayContains: 100);
    }

    query = query
        .where('price', isGreaterThanOrEqualTo: startPrice)
        .where('price', isLessThanOrEqualTo: endPrice);

    final snapshots = query.snapshots();
    return snapshots.map((snapshots) => snapshots.documents
        .map((snapshot) => builder(snapshot.data, snapshot.documentID))
        .toList());
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentId),
  }) {
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshots) => snapshots.documents
        .map((snapshot) => builder(snapshot.data, snapshot.documentID))
        .toList());
  }
}
