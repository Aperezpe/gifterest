import 'dart:io';
import 'package:bonobo/ui/models/person.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'storage_path.dart';

import 'package:firebase_storage/firebase_storage.dart';

abstract class Storage {
  void putFriendProfileImage();
  Future<String> getFriendProfileImageURL();
  Future<String> getDefaultProfileImageUrl();
  Future<void> deleteFriendProfileImage();

  void putUserProfileImage();
  Future<String> getUserProfileImageURL();
  Future<void> deleteUserProfileImage();
}

class FirebaseStorageService implements Storage {
  final String storageBucket = 'gs://important-dates-reminders.appspot.com';
  FirebaseStorage _storage;
  UploadTask uploadTask;
  final String uid;
  final Person person;

  FirebaseStorageService({@required this.uid, @required this.person}) {
    _storage = FirebaseStorage.instanceFor(bucket: storageBucket);
  }
  @override
  void putFriendProfileImage({@required File image}) => uploadTask = _storage
      .ref()
      .child(StoragePath.friendProfileImage(uid, person))
      .putFile(image);
  @override
  Future<String> getFriendProfileImageURL() async => await _storage
      .ref()
      .child(StoragePath.friendProfileImage(uid, person))
      .getDownloadURL();
  @override
  Future<String> getDefaultProfileImageUrl() async => await _storage
      .ref()
      .child(StoragePath.defaultProfileImage)
      .getDownloadURL();
  @override
  Future<void> deleteFriendProfileImage() async {
    if (!person.imageUrl.contains("placeholder")) {
      final ref = _storage.ref(StoragePath.friendProfileImage(uid, person));
      ref.delete();
    }
  }

  @override
  Future<void> deleteUserProfileImage() {
    // TODO: implement deleteUserProfileImage
    throw UnimplementedError();
  }

  @override
  Future<String> getUserProfileImageURL() {
    // TODO: implement getUserProfileImageURL
    throw UnimplementedError();
  }

  @override
  void putUserProfileImage() {
    // TODO: implement putUserProfileImage
  }
}
