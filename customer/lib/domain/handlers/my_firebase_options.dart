import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBXtfZL9TXaSOVv1MKgRg_Ieb7-4Xz7q0A',
    appId: '1:943609385627:android:2324efe6f0e3e50c09ec3e',
    messagingSenderId: '943609385627',
    projectId: 'ding-tea-6bb95',
    // databaseURL: 'https://.firebaseio.com',
    storageBucket: 'ding-tea-6bb95.firebasestorage.app',
    authDomain: 'ding-tea-6bb95.firebaseapp.com',
    measurementId: 'G-2YJ9MM44KN',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBXtfZL9TXaSOVv1MKgRg_Ieb7-4Xz7q0A',
    appId: '1:943609385627:android:2324efe6f0e3e50c09ec3e',
    messagingSenderId: '943609385627',
    projectId: 'ding-tea-6bb95',
    // databaseURL: 'https://.firebaseio.com',
    storageBucket: 'ding-tea-6bb95.firebasestorage.app',
    androidClientId:
        '943609385627-kk3ia6r8aoab886frdq8g7k4ihl855nd.apps.googleusercontent.com',
    iosClientId:
        '943609385627-kk3ia6r8aoab886frdq8g7k4ihl855nd.apps.googleusercontent.com',
    iosBundleId: 'com.xxelxt.dtea',
  );
}
