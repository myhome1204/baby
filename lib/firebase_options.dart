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
    apiKey: 'AIzaSyA1COYO0NAsPoPG-k1DZbTRT31Zmtbq7fY',
    appId: '1:38212389400:web:1ddbc1565c61fbb5c4516d',
    messagingSenderId: '38212389400',
    projectId: 'baby-monk',
    authDomain: 'baby-monk.firebaseapp.com',
    storageBucket: 'baby-monk.appspot.com',
    measurementId: 'G-PTBRDMJEM5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDzSXlgYJiJfdpnDwxNanaz3vGORHew7Y0',
    appId: '1:38212389400:android:9230d0ef8d40bdaec4516d',
    messagingSenderId: '38212389400',
    projectId: 'baby-monk',
    storageBucket: 'baby-monk.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB37MvKwFTewHLeOjZU-tLM6ySnlyCZoDY',
    appId: '1:38212389400:ios:eabf751a63c70f62c4516d',
    messagingSenderId: '38212389400',
    projectId: 'baby-monk',
    storageBucket: 'baby-monk.appspot.com',
    iosBundleId: 'com.example.untitled3',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB37MvKwFTewHLeOjZU-tLM6ySnlyCZoDY',
    appId: '1:38212389400:ios:eabf751a63c70f62c4516d',
    messagingSenderId: '38212389400',
    projectId: 'baby-monk',
    storageBucket: 'baby-monk.appspot.com',
    iosBundleId: 'com.example.untitled3',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA1COYO0NAsPoPG-k1DZbTRT31Zmtbq7fY',
    appId: '1:38212389400:web:d0b69703e89f246dc4516d',
    messagingSenderId: '38212389400',
    projectId: 'baby-monk',
    authDomain: 'baby-monk.firebaseapp.com',
    storageBucket: 'baby-monk.appspot.com',
    measurementId: 'G-C052X0FYQD',
  );
}