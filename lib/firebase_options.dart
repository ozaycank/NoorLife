import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'core/config/environment_config.dart';

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

  static FirebaseOptions get web => FirebaseOptions(
        apiKey: EnvironmentConfig.isDevelopment
            ? 'AIzaSyDummyWebKeyForDev'
            : 'AIzaSyDummyWebKeyForProd',
        appId: '1:1234567890:web:abcdef123456',
        messagingSenderId: '1234567890',
        projectId: 'noorlife-app',
        authDomain: 'noorlife-app.firebaseapp.com',
        storageBucket: 'noorlife-app.appspot.com',
      );

  static FirebaseOptions get android => FirebaseOptions(
        apiKey: EnvironmentConfig.isDevelopment
            ? 'AIzaSyDummyAndroidKeyForDev'
            : 'AIzaSyDummyAndroidKeyForProd',
        appId: '1:1234567890:android:abcdef123456',
        messagingSenderId: '1234567890',
        projectId: 'noorlife-app',
        storageBucket: 'noorlife-app.appspot.com',
      );

  static FirebaseOptions get ios => FirebaseOptions(
        apiKey: EnvironmentConfig.isDevelopment
            ? 'AIzaSyDummyIosKeyForDev'
            : 'AIzaSyDummyIosKeyForProd',
        appId: '1:1234567890:ios:abcdef123456',
        messagingSenderId: '1234567890',
        projectId: 'noorlife-app',
        storageBucket: 'noorlife-app.appspot.com',
        iosBundleId: 'com.noorlife.app',
      );

  static FirebaseOptions get macos => FirebaseOptions(
        apiKey: EnvironmentConfig.isDevelopment
            ? 'AIzaSyDummyMacosKeyForDev'
            : 'AIzaSyDummyMacosKeyForProd',
        appId: '1:1234567890:ios:abcdef123456',
        messagingSenderId: '1234567890',
        projectId: 'noorlife-app',
        storageBucket: 'noorlife-app.appspot.com',
        iosBundleId: 'com.noorlife.app',
      );
}
