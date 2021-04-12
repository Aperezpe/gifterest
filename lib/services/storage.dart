import 'dart:io';
import 'package:bonobo/ui/models/person.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'storage_path.dart';

import 'package:firebase_storage/firebase_storage.dart';

abstract class Storage {
  void putProfileImage({@required File image, Person person});
  Future<String> getProfileImageURL({Person person});
  Future<String> getDefaultProfileImageUrl();
  Future<void> deleteProfileImage({Person person});
  UploadTask uploadTask;
}

class FirebaseFriendStorage implements Storage {
  final String storageBucket = 'gs://important-dates-reminders.appspot.com';
  FirebaseStorage _storage;
  final String uid;

  @override
  UploadTask uploadTask;

  String friendPath(Person person) =>
      StoragePath.friendProfileImage(uid, person);

  FirebaseFriendStorage({@required this.uid}) {
    _storage = FirebaseStorage.instanceFor(bucket: storageBucket);
  }

  @override
  void putProfileImage({@required File image, @required Person person}) =>
      uploadTask = _storage.ref().child(friendPath(person)).putFile(image);

  @override
  Future<String> getProfileImageURL({@required Person person}) async =>
      await _storage.ref().child(friendPath(person)).getDownloadURL();

  @override
  Future<String> getDefaultProfileImageUrl() async => await _storage
      .ref()
      .child(StoragePath.defaultProfileImage)
      .getDownloadURL();

  @override
  Future<void> deleteProfileImage({@required Person person}) async {
    if (!person.imageUrl.contains("placeholder")) {
      final ref = _storage.ref(friendPath(person));
      ref.delete();
    }
  }
}

class FirebaseUserStorage implements Storage {
  final String storageBucket = 'gs://important-dates-reminders.appspot.com';
  FirebaseStorage _storage;
  UploadTask uploadTask;
  final String uid;
  // final Person person;

  String get userPath => StoragePath.userProfileImage(uid);

  FirebaseUserStorage({@required this.uid}) {
    _storage = FirebaseStorage.instanceFor(bucket: storageBucket);
  }
  @override
  void putProfileImage({@required File image, Person person}) =>
      uploadTask = _storage.ref().child(userPath).putFile(image);

  @override
  Future<String> getProfileImageURL({Person person}) async =>
      await _storage.ref().child(userPath).getDownloadURL();

  @override
  Future<String> getDefaultProfileImageUrl() async => await _storage
      .ref()
      .child(StoragePath.defaultProfileImage)
      .getDownloadURL();

  @override
  Future<void> deleteProfileImage({@required Person person}) async {
    if (!person.imageUrl.contains("placeholder")) {
      final ref = _storage.ref(userPath);
      ref.delete();
    }
  }
}
