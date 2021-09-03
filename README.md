# Gifterest

Bonobo is an event reminder plus gift recommendations app. Bonobo helps you remember important friend's or family's events while giving you mindful gift recommendations depending on their interests.

# Motivation

Bonobo was created to help solve the problem of forgetting important dates plus not having idea of what to give them at the last moment. Bonobo solves this problem by reminding you of your friend's important events in advance plus listing the best Amazon products.

# Features:

- Login
- Add, Edit, Delete Friend's Info and Profile Picture
- Add, Edit, Delete Friend's Events
- Add, Edit Friend's Interests
- Generate Friend Profile with:
  - Gift Recommendations gotten by querying friend's Age, Gender, Interests, Event, and Budget

# Screenshots

![Login](screenshots/Login.jpg)
![Login](screenshots/MyFriends.jpg)
![Login](screenshots/Interests.jpg)
![Login](screenshots/FriendProfile.jpg)

# Upcoming Features:

- Home Page
- User Profile with:
  - Product Recommendations gotten by querying user's Age, Gender, Interests, and Budget
- Favorite Products
- Calendar

# Tech/Framework Used

- Flutter
- Provider
- Firebase
  - Authentication
  - Firestore (Realtime Database)
  - Cloud Storage

# Troubleshoot

If you're getting an error like this:

## **Problem:** Podfile is out of date please try 'pod repo update'

This could be caused because the following line in podfile:

```dart
pod 'FirebaseFirestore', :git => 'https://github.com/invertase/firestore-ios-sdk-frameworks.git', :tag => '8.0.0'
```

The number `'8.0.0'` could mismatch the Firebase version specified in the Podfile.lock. This usually happens when the Podile.lock is changed somehow.

### **To fix this problem you can try the following:**

- Instead of `'8.0.0'` or any version you wrote, change that number to the
  number your Podfile.lock specifies.

### **If this does not work, you can try the following:**

1. Delete your Podfile, Podfile.lock, and the Pods directory in your ios directory
2. Run `flutter clean` in the terminal
3. Run `flutter pub get` in the terminal
4. Run `flutter run` in the terminal

Source: https://stackoverflow.com/questions/54135078/how-to-solve-error-running-pod-install-in-flutter-on-mac/63504980

After following these steps, you can then go to the following [THIS](https://github.com/invertase/firestore-ios-sdk-frameworks) github repository to check all the firestore ios sdk framework versions and use the latest or any other version that matches your Podfile.lock

## **Problem:** file not found #import <Flutter/Flutter.h>

```
Xcode's output:
↳
    In file included from /usr/local/Caskroom/flutter/2.2.3/flutter/.pub-cache/hosted/pub.dartlang.org/path_provider-2.0.2/ios/Classes/FLTPathProviderPlugin.m:5:
    /usr/local/Caskroom/flutter/2.2.3/flutter/.pub-cache/hosted/pub.dartlang.org/path_provider-2.0.2/ios/Classes/FLTPathProviderPlugin.h:5:9: fatal error: 'Flutter/Flutter.h'
    file not found
    #import <Flutter/Flutter.h>
            ^~~~~~~~~~~~~~~~~~~
    1 error generated.
```

### **This is the only solution that worked for me:**

1. Backup `ios/Runner` folder.

2. Delete the `ios` folder.

3. Run `flutter create (your project name)`. in the previous folder where you have your project(`cd users/user/"projects_folder"`) (this will recreate your `ios` folder).

4. Paste your Runner backup in the `ios` folder (into the project).

5. Open `Runner.xcworkspace` (into `ios` folder) and there, check the Version, the Bundle ID, all the info.

6. (If do you Have Firebase, you have to copy and paste again the `GoogleService-Info.Plist` into the `Runner` folder (Always through Xcode) (If do you do this manually, it doesn't work).

Finally, flutter run and should work!

If flutter run fails:

1. `cd ios`
2. `pod install`
3. `cd ..`
4. `flutter run`

Source: https://stackoverflow.com/questions/64973346/error-flutter-flutter-h-file-not-found-when-flutter-run-on-ios

# Deployment

## iOS

Deployment was done following the steps in this documentation:
https://flutter.dev/docs/deployment/ios. Read the second "Note" section in the create a build archive to

## Android

- Get upload_keystore from my google drive if is not in local machine
- Review app manifest and build configuration if necessary
- `flutter build appbundle`
- I can test offline bundle tool but on Windows because is not working on mac

https://flutter.dev/docs/deployment/android
