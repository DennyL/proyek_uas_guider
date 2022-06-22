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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyD7lyVamEs9SZXskZl_OMfaP3Sx8Asa5Gs',
    appId: '1:955506264112:web:2b306d8ce729539ebd05f5',
    messagingSenderId: '955506264112',
    projectId: 'guider-app-e89dc',
    authDomain: 'guider-app-e89dc.firebaseapp.com',
    storageBucket: 'guider-app-e89dc.appspot.com',
    measurementId: 'G-5GTM9C9MHN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDtAqwtTREbvRviTgN5wCwfgfzcZGRaYn8',
    appId: '1:955506264112:android:d8b4b3fe27d17d13bd05f5',
    messagingSenderId: '955506264112',
    projectId: 'guider-app-e89dc',
    storageBucket: 'guider-app-e89dc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB1GLcRXuyngC9wKW_jr5djvWaXIwDvH_Q',
    appId: '1:955506264112:ios:9d5fcb739dd86d09bd05f5',
    messagingSenderId: '955506264112',
    projectId: 'guider-app-e89dc',
    storageBucket: 'guider-app-e89dc.appspot.com',
    iosClientId:
        '955506264112-ba9b3e8djg9rh38bo23mfd7bttv47ki9.apps.googleusercontent.com',
    iosBundleId: 'com.example.proyekUasGuider',
  );
}