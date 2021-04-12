import 'package:bonobo/services/database.dart';
import 'package:bonobo/services/storage.dart';
import 'package:bonobo/ui/models/gender.dart';
import 'package:bonobo/ui/models/person.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class SetFormModel extends ChangeNotifier {
  SetFormModel({
    @required this.genders,
    @required this.database,
    @required this.person,
    @required this.uid,
    @required this.firebaseStorage,
    this.isNew: false,
  }) {
    name = person?.name;
    age = person?.age;
    genderTypes = genders.map((gender) => gender.type).toList();
    initializeGenderDropdownValue();
    initializeAgeRange();
  }
  final String uid;
  final FirestoreDatabase database;
  final Person person;
  final List<Gender> genders;
  final bool isNew;
  final Storage firebaseStorage;

  File selectedImage;
  int initialGenderValue = 0;
  List<int> ageRange;
  List<String> genderTypes;

  String name = "";
  int age = 0;

  Future<dynamic> getImageOrURL() async {
    if (selectedImage != null) return selectedImage;
    if (isNew) return await firebaseStorage.getDefaultProfileImageUrl();
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
    firebaseStorage.putProfileImage(image: selectedImage, person: person);
    notifyListeners();
    await firebaseStorage.uploadTask.whenComplete(() => null);
  }

  /// [Adding new person]: Returns a person object with the data gathered
  /// from from form + initial valules
  ///
  /// [Editing person]: Returns person object with data gathered from form +
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
        person.imageUrl =
            await firebaseStorage.getProfileImageURL(person: person);
      }

      await database.setPerson(setPerson());
    } catch (e) {
      rethrow;
    }
  }

  void initializeGenderDropdownValue() {
    if (isNew) return;
    initialGenderValue = genderTypes.indexOf(person.gender);
  }

  List<String> getGenderTypes(List<Gender> genders) {
    return genders.map((gender) => gender.type).toList();
  }

  void initializeAgeRange() {
    if (isNew) return;
    if (isNew) return;
    if (person.age >= 0 && person.age <= 2) {
      ageRange = [0, 2];
    } else if (person.age >= 3 && person.age <= 11) {
      ageRange = [3, 11];
    } else {
      ageRange = [12, 100];
    }
  }

  bool genderChanged() {
    if (isNew) return false;
    if (genders[initialGenderValue].type != person.gender) {
      return true;
    }
    return false;
  }

  bool ageRangeChanged() {
    if (isNew) return false;
    if (person.age != age) {
      if (age >= ageRange[0] && age <= ageRange[1]) return false;
      return true;
    }
    return false;
  }

  void onGenderDropdownChange(int value) => initialGenderValue = value;

  void updateName(String name) => updateWith(name: name);
  void updateAge(int age) => updateWith(age: age);

  void updateWith({
    String name,
    int age,
  }) {
    this.name = name ?? this.name;
    this.age = age ?? this.age;
  }

  Person setPerson() {
    return Person(
      id: isNew ? documentIdFromCurrentDate() : person.id,
      name: name,
      age: age,
      imageUrl: person?.imageUrl,
      gender: genders[initialGenderValue].type,
      interests: (isNew || ageRangeChanged() || genderChanged())
          ? []
          : person.interests,
    );
  }
}
