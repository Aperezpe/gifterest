import 'package:gifterest/ui/models/person.dart';
import 'package:gifterest/ui/screens/friend/event_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../extensions/string_capitalize.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data);
  }

  Future<void> setOrUpdateData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data, SetOptions(merge: true));
  }

  Future<void> updateData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.update(data);
  }

  Future<void> deleteDocument({String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
  }

  Stream<List<T>> queryInterestsStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentId),
    @required Person person,
  }) {
    CollectionReference ref = FirebaseFirestore.instance.collection(path);
    Query query;

    // Query interests by friend age
    if (person.age < 3) {
      query = ref.where('age_range', isEqualTo: [0, 2]);
    } else if (person.age >= 3 && person.age < 12) {
      query = ref.where('age_range', isEqualTo: [3, 11]);
    } else {
      query = ref.where('age_range', isEqualTo: [12, 100]);
    }

    /// When friend gender is Other, GET all interests
    /// Otherwise, Get interests with gender "" + friend gender
    if (person.gender == "Other") {
      query = query.where('gender', whereIn: ["", "Male", "Female"]);
    } else {
      query = query.where('gender', whereIn: ["", person.gender.capitalize()]);
    }

    final snapshots = query.snapshots();
    return snapshots.map((snapshots) => snapshots.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .toList());
  }

  // Query product stream by event OR categories
  // Events that need to be checked: Anniversary, Babyshower, Valentines
  // Events are inside the product/categories array
  Stream<List<T>> queryProductsStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentId),
    @required List<dynamic> interests,
    @required int age,
    String gender,
    EventType eventType,
  }) {
    CollectionReference ref = FirebaseFirestore.instance.collection(path);
    Query query;

    switch (eventType) {

      /// Query by BabyShower or Anniversary. If not given, then just query
      /// by the friend's interests
      case EventType.babyShower:
        query = ref.where('categories', arrayContains: "Babyshower");
        break;
      case EventType.anniversary:
        query = ref.where('categories', arrayContains: "Anniversary");
        break;
      case EventType.valentines:
        query = ref.where('categories', arrayContains: "Valentines");
        break;
      default:
        query = ref.where('categories', arrayContainsAny: interests);
        break;
    }

    // Only query by age on Any, since other events are age irrelevant
    if (eventType == EventType.any || eventType == null) {
      if (age < 3) {
        query = query.where('age_range', isEqualTo: [0, 2]);
      } else if (age >= 3 && age < 12) {
        query = query.where('age_range', isEqualTo: [3, 11]);
      } else {
        query = query.where('age_range', isEqualTo: [12, 100]);
      }
    }

    final snapshots = query.snapshots();

    return snapshots.map((snapshots) => snapshots.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .toList());
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentId),
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshots) => snapshots.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .toList());
  }

  Stream<T> documentStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data),
  }) {
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();

    return snapshots.map((snapshot) => builder(snapshot.data()));
    // return builder(snapshots.asyncMap((event) => null));
  }
}
