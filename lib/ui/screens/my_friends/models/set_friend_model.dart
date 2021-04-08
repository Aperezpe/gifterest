import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/models/gender.dart';
import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/screens/my_friends/set_special_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../../services/storage.dart';

class SetFriendModel extends ChangeNotifier {
  final String uid;
  final FirestoreDatabase database;
  final Person person;
  final List<Gender> genders;

  String name = "";
  int age = 0;
  bool isNewFriend;
  int initialGenderValue = 0;
  List<int> ageRange;
  File selectedImage;
  List<String> genderTypes;
  FirebaseStorageService firebaseStorage;
  String profileImageUrl;

  SetFriendModel({
    @required this.uid,
    @required this.database,
    @required this.genders,
    this.person,
  }) {
    name = person?.name;
    age = person?.age;
    isNewFriend = person == null ? true : false;
    firebaseStorage = FirebaseStorageService(uid: uid, person: person);
    genderTypes = genders.map((gender) => gender.type).toList();
    initializeGenderDropdownValue();
    initializeAgeRange();
  }

  Future<dynamic> getImageOrURL() async {
    if (selectedImage != null) return selectedImage;
    if (isNewFriend) return await firebaseStorage.getDefaultProfileImageUrl();
    return person.imageUrl;
  }

  Future pickImage() async {
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxHeight: 500,
        maxWidth: 500,
      );

      final cropped = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        compressQuality: 50,
        maxHeight: 350,
        maxWidth: 350,
        compressFormat: ImageCompressFormat.jpg,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.deepOrange,
          toolbarTitle: 'Crop It',
          statusBarColor: Colors.deepOrange.shade900,
          backgroundColor: Colors.white,
        ),
      );

      selectedImage = cropped ?? selectedImage;
      notifyListeners();
    } catch (e) {
      print("Image picker error: $e");
    }
  }

  Future<void> _uploadProfileImage() async {
    firebaseStorage.putFriendProfileImage(image: selectedImage);
    notifyListeners();
    await firebaseStorage.uploadTask.whenComplete(() => null);
  }

  /// [Adding new friend]: Returns a friend instance with the data gathered
  /// from from form + initial valules
  ///
  /// [Editing friend]: Returns friend instance with data gathered from form +
  /// previous values on friend instance
  ///
  /// Used in submit() and setInterestPage.

  Future<void> onSave() async {
    try {
      if (ageRangeChanged() || genderChanged())
        throw PlatformException(
          code: "01",
          message: "User has to re-select interests",
        );

      if (selectedImage != null) {
        await _uploadProfileImage();
        person.imageUrl = await firebaseStorage.getFriendProfileImageURL();
      }

      final newFriend = _setFriend();
      await database.setFriend(newFriend);
    } catch (e) {
      rethrow;
    }
  }

  void initializeGenderDropdownValue() {
    if (isNewFriend) return;
    initialGenderValue = genderTypes.indexOf(person.gender);
  }

  void initializeAgeRange() {
    if (isNewFriend) return;
    if (person.age >= 0 && person.age <= 2) {
      ageRange = [0, 2];
    } else if (person.age >= 3 && person.age <= 11) {
      ageRange = [3, 11];
    } else {
      ageRange = [12, 100];
    }
  }

  bool genderChanged() {
    if (isNewFriend) return false;
    if (genders[initialGenderValue].type != person.gender) {
      return true;
    }
    return false;
  }

  bool ageRangeChanged() {
    if (isNewFriend) return false;
    if (person.age != age) {
      if (age >= ageRange[0] && age <= ageRange[1]) return false;
      return true;
    }
    return false;
  }

  void onGenderDropdownChange(int value) {
    initialGenderValue = value;
  }

  void updateName(String name) => updateWith(name: name);
  void updateAge(int age) => updateWith(age: age);

  void updateWith({
    String name,
    int age,
  }) {
    this.name = name ?? this.name;
    this.age = age ?? this.age;
  }

  void goToSpecialEvents(BuildContext context) async {
    final newFriend = _setFriend();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SetSpecialEvent.show(
          context,
          person: newFriend,
          isNewFriend: isNewFriend,
          selectedImage: selectedImage,
        ),
      ),
    );
  }

  Person _setFriend() {
    return Person(
      id: isNewFriend ? documentIdFromCurrentDate() : person.id,
      name: name,
      age: age,
      imageUrl: person?.imageUrl,
      gender: genders[initialGenderValue].type,
      interests: (isNewFriend || ageRangeChanged() || genderChanged())
          ? []
          : person.interests,
    );
  }
}
