// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDhRf8Rq8Ad0NKNM3Z22cgBgy93rgM5Crs',
    appId: '1:1050884872357:web:1aa110b5fcbca9f2bd154c',
    messagingSenderId: '1050884872357',
    projectId: 'addfriendsdemo',
    authDomain: 'addfriendsdemo.firebaseapp.com',
    storageBucket: 'addfriendsdemo.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB5CPXORObtoILolVp2djBDTRTwlQy4LYY',
    appId: '1:1050884872357:android:b9ec1b7ac81f3eb6bd154c',
    messagingSenderId: '1050884872357',
    projectId: 'addfriendsdemo',
    storageBucket: 'addfriendsdemo.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDhXDPVxp4qnHhOiQmqUrgk43SLCz7D4vg',
    appId: '1:1050884872357:ios:4b58ffbf39bc6b36bd154c',
    messagingSenderId: '1050884872357',
    projectId: 'addfriendsdemo',
    storageBucket: 'addfriendsdemo.appspot.com',
    iosBundleId: 'com.flutterAddFriends.flutterAddFriends',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDhXDPVxp4qnHhOiQmqUrgk43SLCz7D4vg',
    appId: '1:1050884872357:ios:bd858ad8f717e7f3bd154c',
    messagingSenderId: '1050884872357',
    projectId: 'addfriendsdemo',
    storageBucket: 'addfriendsdemo.appspot.com',
    iosBundleId: 'com.flutterAddFriends.flutterAddFriends.RunnerTests',
  );
}
