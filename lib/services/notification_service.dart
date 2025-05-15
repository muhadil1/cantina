import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';



class NotificationService {



  Future<void> postDeviceToken() async {


    FirebaseMessaging.instance.deleteToken();
    FirebaseMessaging.instance.getToken().then((token) async {

    }).catchError((error) {
      print("Erro ao obter o token: $error");
    });
  }

  static Future<void> initialize() async {

  }

  static Future<void> showNotification(RemoteMessage message) async {

  }

  static void setupFirebaseMessagingListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          "Notificação recebida (foreground): ${message.notification?.title}");
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Usuário clicou na notificação: ${message.notification?.title}");
    });

}}