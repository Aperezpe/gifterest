import 'dart:io';
import 'package:bonobo/ui/screens/my_friends/models/friend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'storage_path.dart';

import 'package:firebase_storage/firebase_storage.dart';

abstract class Storage {
  void uploadProfileImage();
  Future<String> downloadProfileImageURL();
  Future<String> loadDefaultProfileUrl();
}

class FirebaseStorageService implements Storage {
  final String storageBucket = 'gs://important-dates-reminders.appspot.com';
  FirebaseStorage _storage;
  StorageUploadTask uploadTask;
  final String uid;
  final Friend friend;

  FirebaseStorageService({@required this.uid, @required this.friend}) {
    _storage = FirebaseStorage(storageBucket: storageBucket);
  }

  void uploadProfileImage({@required File image}) => uploadTask = _storage
      .ref()
      .child(StoragePath.profileImage(uid, friend))
      .putFile(image);

  Future<String> downloadProfileImageURL() async => await _storage
      .ref()
      .child(StoragePath.profileImage(uid, friend))
      .getDownloadURL();

  Future<String> loadDefaultProfileUrl() async => await _storage
      .ref()
      .child(StoragePath.defaultProfileImage())
      .getDownloadURL();

  void deleteFriendDirectory({Friend friend}) async {
    final ref = _storage.ref();
    print(StoragePath.profileImage(uid, friend));
    final child = ref.child(StoragePath.profileImage(uid, friend));

    // await _storage.ref().child(StoragePath.profileImage(uid, friend)).delete();
    print("Todo bien?");
  }
}
