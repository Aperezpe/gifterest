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


# Upcoming Features:

- Home Page
- User Profile with:
  - Product Recommendations gotten by querying user's Age, Gender, Interests, and Budget
- Favorite Products
- Calendar

# Run locally

First, run `flutter pub get` : To install necessary packages

In the project directory, just run this command depending on flavor you want to run.

DEV: `flutter run --debug -t lib/main_dev.dart --flavor dev`
PROD: `flutter run --debug -t lib/main_prod.dart --flavor prod`

Additionally, you can setup VS Code for debugging by like this inside the launch.json

![VS Code config for debugging](docs/images/vs%20code%20for%20debugging.png)




# Tech/Framework Used

- Flutter 2.2.3 (Dart 2.13.4)
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

I uploaded to App Store by following this tutorial:
https://dzone.com/articles/flutter-release-ios-app-on-apple-store

### **Renew Certificate of Distribution (When expired)**

First, you should be receiving an email 30 days before expiring. After receiving that email, then follow these steps.

1. Go to [Certificates, Identifiers & Profiles](https://developer.apple.com/account/resources/certificates/list)
2. Click '+' on Certificates to create a new certificate
3. Select iOS Distribution, and then Continue
4. You'll need a Certificate Signing Request. Follow these steps
    1. Open Keychain Access
    2. Go to Keychain Access > Certificate Assistant >  Request a Certificate From a Certificate Authority
    ![Request Certificate Screenshot](docs/images/keychain%20step.jpg)
    3. Add an email to User Email Address, a Common Name such as Gifterest Dev, and leave CA Email Address empty. Also, check Saved to disk.
    ![Request Certificate Screenshot2](docs/images/Requesting%20certificate.jpg)
    4. Click Continue and save it in the Desktop
5. Upload your Certificate Signing Request when requesting new Distrbution Certificate.
6. After Distribution certificate is created, Download it, open it in Keychain Access, and export the P12 file
![Exporting Private Key Screnshot](docs/images/exporting%20private%20key.jpg)
7. Save the .p12 file in your desktop with a password easy to remember
8. Run following command to get the private key from the certificate:\
\
`openssl pkcs12 -in IOS_DISTRIBUTION.p12 -nodes -nocerts | openssl rsa -out ios_distribution_private_key`\
Note: Just replace IOS_DISTRIBUTION.p12 with the name of the file you exported
9. Open `ios_distribution_private_key` file in a text editor.
10. Copy and pase that private key into the CERTIFICATE_PRIVATE_KEY to replace previous key (Delete previous one). Don't forget to Secure the password so that it gets encrypted.


## Android

- Get upload_keystore from my google drive if is not in local machine
- Review app manifest and build configuration if necessary
- `flutter build appbundle`
- I can test offline bundle tool but on Windows because is not working on mac

https://flutter.dev/docs/deployment/android
