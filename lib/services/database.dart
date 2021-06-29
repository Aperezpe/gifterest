import 'package:bonobo/services/api_path.dart';
import 'package:bonobo/services/firestore_service.dart';
import 'package:bonobo/ui/models/app_user.dart';
import 'package:bonobo/ui/models/event.dart';
import 'package:bonobo/ui/models/friend.dart';
import 'package:bonobo/ui/models/gender.dart';
import 'package:bonobo/ui/models/interest.dart';
import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/models/product.dart';
import 'package:bonobo/ui/screens/friend/event_type.dart';
import 'package:bonobo/ui/screens/my_friends/models/root_special_event.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

abstract class Database {
  Future<void> saveUserToken(String token);
  Future<void> setPerson(Person person);
  Future<void> deleteFriend(Person person);
  Stream<List<Person>> friendsStream();
  Stream<Person> userStream();
  Stream<List<Interest>> interestStream();
  Stream<List<Product>> productsStream();
  Stream<List<Product>> queryUserProductsStream({
    @required int age,
    @required List<dynamic> interests,
    @required String gender,
  });
  Stream<List<Product>> queryFriendProductsStream({
    @required Friend friend,
    EventType eventType,
  });
  Stream<List<Event>> eventsStream();
  Stream<List<Interest>> queryInterestsStream(Person person);
  Stream<List<Gender>> genderStream();
  Stream<List<Product>> favoritesStream();

  Stream<List<SpecialEvent>> specialEventsStream();
  Future<void> setSpecialEvent(SpecialEvent specialEvent, Person person);
  Future<void> setRootSpecialEvent(
    RootSpecialEvent rootSpecialEvent,
    SpecialEvent specialEvent,
    Friend friend,
  );

  Future<void> deleteRootSpecialEvent(SpecialEvent specialEvent);
  Future<void> deleteSpecialEvent(SpecialEvent specialEvent);
  Future<void> setFavorite(Product product);
  Future<void> deleteFavorite(Product product);
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();
String documentUUID() => Uuid().v1();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
  final _service = FirestoreService.instance;

  @override
  Future<void> saveUserToken(String token) async {
    await _service.updateData(path: APIPath.user(uid), data: {
      'tokens': FieldValue.arrayUnion([token])
    });
  }

  @override
  Future<void> setRootSpecialEvent(
    RootSpecialEvent rootSpecialEvent,
    SpecialEvent specialEvent,
    Friend friend,
  ) async {
    await _service.updateData(
      path: APIPath.rootSpecialEvent(specialEvent.id),
      data: rootSpecialEvent.toMap(
        uid: uid,
        friendName: friend.name,
        gender: friend.gender,
      ),
    );
  }

  @override
  Stream<List<Interest>> interestStream() => _service.collectionStream(
        path: APIPath.interests(),
        builder: (data, documentId) => Interest.fromMap(data, documentId),
      );
  @override
  Stream<List<Interest>> queryInterestsStream(Person person) =>
      _service.queryInterestsStream(
        path: APIPath.interests(),
        person: person,
        builder: (data, documentId) => Interest.fromMap(data, documentId),
      );

  @override
  Stream<List<Product>> queryUserProductsStream({
    @required int age,
    @required List<dynamic> interests,
    @required String gender,
  }) =>
      _service.queryProductsStream(
        path: APIPath.products(),
        age: age,
        interests: interests,
        gender: gender,
        builder: (data, documentId) => Product.fromMap(data, documentId),
      );

  @override
  Stream<List<Product>> queryFriendProductsStream({
    @required Friend friend,
    EventType eventType,
  }) =>
      _service.queryProductsStream(
        path: APIPath.products(),
        age: friend.age,
        interests: friend.interests,
        gender: friend.gender,
        eventType: eventType,
        builder: (data, documentId) => Product.fromMap(data, documentId),
      );

  @override
  Stream<List<Product>> productsStream() => _service.collectionStream(
        path: APIPath.products(),
        builder: (data, documentId) => Product.fromMap(data, documentId),
      );
  @override
  Stream<List<Gender>> genderStream() => _service.collectionStream(
        path: APIPath.genders(),
        builder: (data, documentId) => Gender.fromMap(data, documentId),
      );
  @override
  Stream<List<Event>> eventsStream() => _service.collectionStream(
        path: APIPath.events(),
        builder: (data, nameId) => Event.fromMap(data, nameId),
      );

  @override
  Stream<List<Product>> favoritesStream() => _service.collectionStream(
        path: APIPath.favorites(uid),
        builder: (data, documentId) => Product.fromMap(data, documentId),
      );

  /// Sets friend or user depending on person object
  Future<Person> setPerson(Person person) async {
    if (person.id == uid) {
      await _service.setData(path: APIPath.user(uid), data: person.toMap());
      return person;
    } else {
      await _service.setData(
          path: APIPath.friend(uid, person.id), data: person.toMap());
      return person;
    }
  }

  @override
  Future<void> deleteFriend(Person person) async =>
      await _service.deleteData(path: APIPath.friend(uid, person.id));

  @override
  Stream<List<Friend>> friendsStream() => _service.collectionStream(
        path: APIPath.friends(uid),
        builder: (data, documentId) => Friend.fromMap(data, documentId),
      );

  @override
  Stream<AppUser> userStream() => _service.documentStream(
      path: APIPath.user(uid), builder: (data) => AppUser.fromMap(data, uid));

  @override
  Stream<List<SpecialEvent>> specialEventsStream() => _service.collectionStream(
        path: APIPath.specialEvents(uid),
        builder: (data, documentId) => SpecialEvent.fromMap(data, documentId),
      );
  @override
  Future<void> setSpecialEvent(SpecialEvent specialEvent, Person person) async {
    if (person == null) throw ("Friend can not be null");
    await _service.setData(
      path: APIPath.specialEvent(uid, specialEvent.id),
      data: specialEvent.toMap(person.id),
    );
  }

  @override
  Future<void> deleteRootSpecialEvent(SpecialEvent specialEvent) async =>
      await _service.deleteData(
          path: APIPath.rootSpecialEvent(specialEvent.id));

  @override
  Future<void> deleteSpecialEvent(SpecialEvent specialEvent) async =>
      await _service.deleteData(
          path: APIPath.specialEvent(uid, specialEvent.id));

  @override
  Future<void> setFavorite(Product product) async => await _service.setData(
        path: APIPath.favorite(uid, product.id),
        data: product.toMap(),
      );

  @override
  Future<void> deleteFavorite(Product product) async =>
      await _service.deleteData(path: APIPath.favorite(uid, product.id));
}
