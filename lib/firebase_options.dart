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
    apiKey: 'AIzaSyBzDIzL5m8mk3Qa5weQsJ2TWJJf2QS2tcg',
    appId: '1:775206149730:web:f68187739b774f42217b3b',
    messagingSenderId: '775206149730',
    projectId: 'dog-feeding-ded68',
    authDomain: 'dog-feeding-ded68.firebaseapp.com',
    databaseURL: 'https://dog-feeding-ded68-default-rtdb.firebaseio.com',
    storageBucket: 'dog-feeding-ded68.appspot.com',
    measurementId: 'G-2BD0B5JMEX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBPfgOK8bbOb3JJKZ0zdHaAsMj-WHkSXwg',
    appId: '1:775206149730:android:3223651beb045c0f217b3b',
    messagingSenderId: '775206149730',
    projectId: 'dog-feeding-ded68',
    databaseURL: 'https://dog-feeding-ded68-default-rtdb.firebaseio.com',
    storageBucket: 'dog-feeding-ded68.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyByblAnJ3vcgDYyuBPX99K1mN-l8Xf1NPQ',
    appId: '1:775206149730:ios:18af1cea1d2d7290217b3b',
    messagingSenderId: '775206149730',
    projectId: 'dog-feeding-ded68',
    databaseURL: 'https://dog-feeding-ded68-default-rtdb.firebaseio.com',
    storageBucket: 'dog-feeding-ded68.appspot.com',
    iosBundleId: 'com.aries.doggyfeedMobile',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyByblAnJ3vcgDYyuBPX99K1mN-l8Xf1NPQ',
    appId: '1:775206149730:ios:8514ac55ecd0e5b6217b3b',
    messagingSenderId: '775206149730',
    projectId: 'dog-feeding-ded68',
    databaseURL: 'https://dog-feeding-ded68-default-rtdb.firebaseio.com',
    storageBucket: 'dog-feeding-ded68.appspot.com',
    iosBundleId: 'com.aries.doggyfeedMobile.RunnerTests',
  );
}
