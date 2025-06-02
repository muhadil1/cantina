// main.dart
import 'package:cantina/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'services/firebase_auth_service.dart';
import 'services/firestore_service.dart';
import 'repositories/auth_repository.dart';
import 'repositories/menu_repository.dart';
import 'repositories/order_repository.dart';
import 'viewmodels/auth/login_viewmodel.dart';
import 'viewmodels/auth/signup_viewmodel.dart';
import 'viewmodels/menu/cantina_menu_viewmodel.dart';
import 'viewmodels/menu/externo_menu_viewmodel.dart';
import 'viewmodels/order/cart_viewmodel.dart';


import 'package:cantina/views/auth/login_view.dart';
import 'package:cantina/views/admin/admin_dashboard_screen.dart';
 // Tela principal do admin

// Handler de background para FCM
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.initialize();
  NotificationService.setupFirebaseMessagingListeners();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(create: (_) => FirebaseAuthService()),
        Provider<FirestoreService>(create: (_) => FirestoreService()),
        Provider<AuthRepository>(
          create: (context) => AuthRepository(
            Provider.of<FirebaseAuthService>(context, listen: false),
            Provider.of<FirestoreService>(context, listen: false),
          ),
        ),
        Provider<MenuRepository>(
          create: (context) => MenuRepository(
            Provider.of<FirestoreService>(context, listen: false),
          ),
        ),
        Provider<OrderRepository>(
          create: (context) => OrderRepository(
            Provider.of<FirestoreService>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider<LoginViewModel>(
          create: (context) => LoginViewModel(
            Provider.of<AuthRepository>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider<SignupViewModel>(
          create: (context) => SignupViewModel(
            Provider.of<AuthRepository>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider<CanteenMenuViewModel>(
          create: (context) => CanteenMenuViewModel(
            Provider.of<MenuRepository>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider<ExternalMenuViewModel>(
          create: (context) => ExternalMenuViewModel(
            Provider.of<MenuRepository>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider<CartViewModel>(
          create: (context) => CartViewModel(
            Provider.of<OrderRepository>(context, listen: false),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Cantina Admin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          hintColor: Colors.amber,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            elevation: 4,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.grey[100],
          ),
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            if (snapshot.hasData) {
              return const AdminDashboardScreen();
            } else {
              return const LoginView(); // Usa o login da pasta admins
            }
          },
        ),
      ),
    );
  }
}
