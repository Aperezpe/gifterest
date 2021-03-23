import 'package:bonobo/ui/screens/friend/event_type.dart';
import 'package:bonobo/ui/screens/my_friends/models/friend.dart';
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

  Future<void> deleteData({String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
  }

  Stream<List<T>> queryInterestsStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentId),
    @required Friend friend,
  }) {
    CollectionReference ref = FirebaseFirestore.instance.collection(path);
    Query query;

    // Query interests by friend age
    if (friend.age < 3) {
      query = ref.where('age_range', isEqualTo: [0, 2]);
    } else if (friend.age >= 3 && friend.age < 12) {
      query = ref.where('age_range', isEqualTo: [3, 11]);
    } else {
      query = ref.where('age_range', isEqualTo: [12, 100]);
    }

    /// When friend gender is Other, GET all interests
    /// Otherwise, Get interests with gender "" + friend gender
    if (friend.gender == "Other") {
      query = query.where('gender', whereIn: ["", "Male", "Female"]);
    } else {
      query = query.where('gender', whereIn: ["", friend.gender.capitalize()]);
    }

    final snapshots = query.snapshots();
    return snapshots.map((snapshots) => snapshots.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .toList());
  }

  // Query product stream by event OR categories
  Stream<List<T>> queryProductsStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentId),
    @required Friend friend,
    EventType eventType,
  }) {
    CollectionReference ref = FirebaseFirestore.instance.collection(path);
    Query query;

    switch (eventType) {
      // TODO: possibly create a girl baby shower and boy baby shower
      // because this will show both since friend.gender is not relevant

      /// Query by BabyShower of Anniversary. If not given, then just query
      /// by the friend's interests
      case EventType.babyShower:
        query = ref.where('event', isEqualTo: "Babyshower");
        break;
      case EventType.anniversary:
        query = ref
            .where('event', isEqualTo: "Anniversary")
            .where('gender', whereIn: [friend.gender, ""]);
        break;
      default:
        query = ref.where('categories', arrayContainsAny: friend.interests);
        break;
    }

    // Babyshower does not need to query by age
    if (eventType == EventType.any) {
      if (friend.age < 3) {
        query = query.where('age_range', isEqualTo: [0, 2]);
      } else if (friend.age >= 3 && friend.age < 12) {
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
}
