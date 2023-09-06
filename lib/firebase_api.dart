import 'package:firebase_messaging/firebase_messaging.dart';
Future<void> handlebackground(RemoteMessage message) async {
print(message.notification?.title);
print(message.notification?.body);


}
class FirebaseApi {
  final firebase_messaging = FirebaseMessaging.instance;
  Future<void>initNotification() async {
   await firebase_messaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage((message) => handlebackground(message));
  }
}