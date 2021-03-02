import 'dart:io';
import 'package:bonobo/ui/screens/my_friends/models/friend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'storage_path.dart';

import 'package:firebase_storage/firebase_storage.dart';

abstract class Storage {
  void putFriendProfileImage();
  Future<String> getFriendProfileImageURL();
  Future<String> getDefaultProfileUrl();
  Future<void> deleteFriendProfileImage();
}

class FirebaseStorageService implements Storage {
  final String storageBucket = 'gs://important-dates-reminders.appspot.com';
  FirebaseStorage _storage;
  UploadTask uploadTask;
  final String uid;
  final Friend friend;

  FirebaseStorageService({@required this.uid, @required this.friend}) {
    _storage = FirebaseStorage.instanceFor(bucket: storageBucket);
  }

  void putFriendProfileImage({@required File image}) => uploadTask = _storage
      .ref()
      .child(StoragePath.friendProfileImage(uid, friend))
      .putFile(image);

  Future<String> getFriendProfileImageURL() async => await _storage
      .ref()
      .child(StoragePath.friendProfileImage(uid, friend))
      .getDownloadURL();

  Future<String> getDefaultProfileUrl() async => await _storage
      .ref()
      .child(StoragePath.defaultProfileImage())
      .getDownloadURL();

  Future<void> deleteFriendProfileImage() async {
    if (!friend.imageUrl.contains("placeholder")) {
      final ref = _storage.ref(StoragePath.friendProfileImage(uid, friend));
      ref.delete();
    }
  }
}
