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
    apiKey: 'AIzaSyC4tINy8biPUaEHZAUh_93_UuOhAY9eKy0',
    appId: '1:141886030899:web:2f765c3c1ead43ea800f46',
    messagingSenderId: '141886030899',
    projectId: 'project2-82fc9',
    authDomain: 'project2-82fc9.firebaseapp.com',
    storageBucket: 'project2-82fc9.appspot.com',
    measurementId: 'G-K9BC3307Q7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDX-Pe9rgVzd_ddM_TVeeBcjvi-P2vqvs4',
    appId: '1:141886030899:android:71e107c65628df0d800f46',
    messagingSenderId: '141886030899',
    projectId: 'project2-82fc9',
    storageBucket: 'project2-82fc9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCpSOy5CWdSKJtnqvQ_CQiqsGCUkfhGxag',
    appId: '1:141886030899:ios:405b201df377d88d800f46',
    messagingSenderId: '141886030899',
    projectId: 'project2-82fc9',
    storageBucket: 'project2-82fc9.appspot.com',
    iosBundleId: 'com.example.project2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCpSOy5CWdSKJtnqvQ_CQiqsGCUkfhGxag',
    appId: '1:141886030899:ios:749e6966e258de41800f46',
    messagingSenderId: '141886030899',
    projectId: 'project2-82fc9',
    storageBucket: 'project2-82fc9.appspot.com',
    iosBundleId: 'com.example.project2.RunnerTests',
  );
}
