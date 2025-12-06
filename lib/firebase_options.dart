import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.

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
    apiKey: 'AIzaSyAGLkiidPsVpN-XCajcUOod68BiTjxcRi0',
    appId: '1:1036556605316:web:e0354023fc5215584c6fd1',
    messagingSenderId: '1036556605316',
    projectId: 'app-hotel-1ee39',
    authDomain: 'app-hotel-1ee39.firebaseapp.com',
    storageBucket: 'app-hotel-1ee39.firebasestorage.app',
    measurementId: 'G-N0V9F0EBV3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyApQY7CHgFXyCSueSSGGajqTgRH72P6Zyk',
    appId: '1:1036556605316:android:90e58dd9557567c04c6fd1',
    messagingSenderId: '1036556605316',
    projectId: 'app-hotel-1ee39',
    storageBucket: 'app-hotel-1ee39.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCZf8eYSeHG87jVej4Rtweeyn1f4EcSWq0',
    appId: '1:1036556605316:ios:5057f0a111ada4b54c6fd1',
    messagingSenderId: '1036556605316',
    projectId: 'app-hotel-1ee39',
    storageBucket: 'app-hotel-1ee39.firebasestorage.app',
    iosBundleId: 'com.example.hotelApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCZf8eYSeHG87jVej4Rtweeyn1f4EcSWq0',
    appId: '1:1036556605316:ios:5057f0a111ada4b54c6fd1',
    messagingSenderId: '1036556605316',
    projectId: 'app-hotel-1ee39',
    storageBucket: 'app-hotel-1ee39.firebasestorage.app',
    iosBundleId: 'com.example.hotelApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAGLkiidPsVpN-XCajcUOod68BiTjxcRi0',
    appId: '1:1036556605316:web:22625e14c96a39dd4c6fd1',
    messagingSenderId: '1036556605316',
    projectId: 'app-hotel-1ee39',
    authDomain: 'app-hotel-1ee39.firebaseapp.com',
    storageBucket: 'app-hotel-1ee39.firebasestorage.app',
    measurementId: 'G-YS4N5SMCWL',
  );
}
