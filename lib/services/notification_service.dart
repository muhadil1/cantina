import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  // Inicializar tudo
  static Future<void> initialize() async {
    // Solicitar permissões no iOS (no Android é automático)
    await _messaging.requestPermission();

    // Inicializar notificações locais
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
    InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(initSettings);

    // Obter e registar o token no Firestore
    await _postDeviceToken();

    // Escutar eventos de notificações
    setupFirebaseMessagingListeners();
  }

  // Obter o token FCM e salvar no Firestore
  static Future<void> _postDeviceToken() async {
    try {
      final token = await _messaging.getToken();
      final user = FirebaseAuth.instance.currentUser;
      if (token != null && user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'fcmToken': token});
        print('FCM Token registado: $token');
      }
    } catch (e) {
      print('Erro ao registar FCM token: $e');
    }
  }

  // Mostrar notificação em foreground
  static Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'default_channel_id',
      'Notificações',
      channelDescription: 'Canal padrão de notificações',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
    NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformDetails,
    );
  }

  // Configurar ouvintes para mensagens
  static void setupFirebaseMessagingListeners() {
    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Mensagem recebida em foreground: ${message.notification?.title}');
      showNotification(message);
    });

    // Quando o app é aberto via clique na notificação
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Usuário abriu notificação: ${message.notification?.title}');
      // TODO: redirecionar para uma tela específica, se necessário
    });

    // Quando o token FCM é atualizado
    _messaging.onTokenRefresh.listen((newToken) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'fcmToken': newToken});
        print('Novo token FCM atualizado: $newToken');
      }
    });
  }
}
