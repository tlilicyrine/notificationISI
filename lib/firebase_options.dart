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
    apiKey: 'AIzaSyDoDyV2-eTQOmLBevrd5Q8PaSwG-zojdTQ',
    appId: '1:661217345869:web:8154412c8e8b9d2588b704',
    messagingSenderId: '661217345869',
    projectId: 'isiapp-2ac53',
    authDomain: 'isiapp-2ac53.firebaseapp.com',
    storageBucket: 'isiapp-2ac53.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB1KLaOrnQqCB7dwd-61bNQkK4tH9K4KUo',
    appId: '1:661217345869:android:4ab8d618d42aff6f88b704',
    messagingSenderId: '661217345869',
    projectId: 'isiapp-2ac53',
    storageBucket: 'isiapp-2ac53.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB9XlmzlHdy3bS6I2_ArfF0Zf4Qhz1dO-o',
    appId: '1:661217345869:ios:a5459bd86633ebc788b704',
    messagingSenderId: '661217345869',
    projectId: 'isiapp-2ac53',
    storageBucket: 'isiapp-2ac53.appspot.com',
    iosBundleId: 'com.example.isi',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB9XlmzlHdy3bS6I2_ArfF0Zf4Qhz1dO-o',
    appId: '1:661217345869:ios:a5459bd86633ebc788b704',
    messagingSenderId: '661217345869',
    projectId: 'isiapp-2ac53',
    storageBucket: 'isiapp-2ac53.appspot.com',
    iosBundleId: 'com.example.isi',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDoDyV2-eTQOmLBevrd5Q8PaSwG-zojdTQ',
    appId: '1:661217345869:web:762040e062d9e17c88b704',
    messagingSenderId: '661217345869',
    projectId: 'isiapp-2ac53',
    authDomain: 'isiapp-2ac53.firebaseapp.com',
    storageBucket: 'isiapp-2ac53.appspot.com',
  );
}