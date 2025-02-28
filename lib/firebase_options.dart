// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyDy-8viZ_SlTD32euTZzV6y5hxGRfNBunk',
    appId: '1:950079165919:web:8e1db976f576cf5d16a06a',
    messagingSenderId: '950079165919',
    projectId: 'raccoltalatte-2fd1c',
    authDomain: 'raccoltalatte-2fd1c.firebaseapp.com',
    storageBucket: 'raccoltalatte-2fd1c.appspot.com',
    measurementId: 'G-G1SGW3BJ42',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBaKYkxPg0jWdu5DsoMHiG-Htx4Uh6SHgw',
    appId: '1:950079165919:android:eda5701063dd57ec16a06a',
    messagingSenderId: '950079165919',
    projectId: 'raccoltalatte-2fd1c',
    storageBucket: 'raccoltalatte-2fd1c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDgaaSNqx0N9Oot4Z5AZeEiIpmUJZ-M_LU',
    appId: '1:950079165919:ios:f3ec439fb1c25c0a16a06a',
    messagingSenderId: '950079165919',
    projectId: 'raccoltalatte-2fd1c',
    storageBucket: 'raccoltalatte-2fd1c.appspot.com',
    iosBundleId: 'com.example.raccoltalatte',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDgaaSNqx0N9Oot4Z5AZeEiIpmUJZ-M_LU',
    appId: '1:950079165919:ios:f3ec439fb1c25c0a16a06a',
    messagingSenderId: '950079165919',
    projectId: 'raccoltalatte-2fd1c',
    storageBucket: 'raccoltalatte-2fd1c.appspot.com',
    iosBundleId: 'com.example.raccoltalatte',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDy-8viZ_SlTD32euTZzV6y5hxGRfNBunk',
    appId: '1:950079165919:web:beedf0816c60ba8016a06a',
    messagingSenderId: '950079165919',
    projectId: 'raccoltalatte-2fd1c',
    authDomain: 'raccoltalatte-2fd1c.firebaseapp.com',
    storageBucket: 'raccoltalatte-2fd1c.appspot.com',
    measurementId: 'G-BXK0FKZFTR',
  );

}