import 'dart:io';
import 'package:bonobo/ui/screens/my_friends/models/friend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'storage_path.dart';

import 'package:firebase_storage/firebase_storage.dart';

abstract class Storage {
  void uploadProfileImage();
}

class FirebaseStorageService implements Storage {
  final String storageBucket = 'gs://important-dates-reminders.appspot.com';
  FirebaseStorage _storage;
  StorageUploadTask uploadTask;
  final String uid;
  final Friend friend;

  // String profileImagePath;

  FirebaseStorageService({@required this.uid, @required this.friend}) {
    _storage = FirebaseStorage(storageBucket: storageBucket);
    // profileImagePath = StoragePath.profileImage(uid, friend);
  }

  void uploadProfileImage({@required File image}) => uploadTask = _storage
      .ref()
      .child(StoragePath.profileImage(uid, friend))
      .putFile(image);

  Future<String> downloadProfileImageURL() async => await _storage
      .ref()
      .child(StoragePath.profileImage(uid, friend))
      .getDownloadURL();
}
