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
import 'repositories/order_repository.dart'; // Importar o OrderRepository
import 'viewmodels/auth/login_viewmodel.dart';
import 'viewmodels/auth/signup_viewmodel.dart';
import 'viewmodels/menu/cantina_menu_viewmodel.dart';
import 'viewmodels/menu/externo_menu_viewmodel.dart';
import 'viewmodels/order/cart_viewmodel.dart'; // Importar CartViewModel

import 'views/auth/login_view.dart';
import 'views/home/home_view.dart';

// Handler de background para FCM (manter esta função de nível superior)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message: ${message.messageId}');
  // TODO: Lógica de manuseio em segundo plano
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  await NotificationService.initialize();
  NotificationService.setupFirebaseMessagingListeners();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Serviços Firebase
        Provider<FirebaseAuthService>(create: (_) => FirebaseAuthService()),
        Provider<FirestoreService>(create: (_) => FirestoreService()),

        // Repositórios
        Provider<AuthRepository>(
          create:
              (context) => AuthRepository(
                Provider.of<FirebaseAuthService>(context, listen: false),
                Provider.of<FirestoreService>(context, listen: false,), // Injete o FirestoreService
              ),
        ),
        Provider<MenuRepository>(
          create:
              (context) => MenuRepository(
                Provider.of<FirestoreService>(context, listen: false),
              ),
        ),
        Provider<OrderRepository>(
          // Fornece o OrderRepository
          create:
              (context) => OrderRepository(
                Provider.of<FirestoreService>(
                  context,
                  listen: false,
                ), // Injete o FirestoreService
              ),
        ),

        // ViewModels de Autenticação
        ChangeNotifierProvider<LoginViewModel>(
          create:
              (context) => LoginViewModel(
                Provider.of<AuthRepository>(context, listen: false),
              ),
        ),
        ChangeNotifierProvider<SignupViewModel>(
          create:
              (context) => SignupViewModel(
                Provider.of<AuthRepository>(context, listen: false),
              ),
        ),

        // ViewModels de Cardápio
        ChangeNotifierProvider<CanteenMenuViewModel>(
          create:
              (context) => CanteenMenuViewModel(
                Provider.of<MenuRepository>(context, listen: false),
              ),
        ),
        ChangeNotifierProvider<ExternalMenuViewModel>(
          create:
              (context) => ExternalMenuViewModel(
                Provider.of<MenuRepository>(context, listen: false),
              ),
        ),

        // ViewModel do Carrinho
        ChangeNotifierProvider<CartViewModel>(
          // Fornece CartViewModel
          create:
              (context) => CartViewModel(
                Provider.of<OrderRepository>(
                  context,
                  listen: false,
                ), // Injete o OrderRepository
              ),
        ),

        // TODO: Adicionar outros ViewModels e Repositórios aqui
      ],
      child: MaterialApp(
        title: 'Cantina ISUTC',
        theme: ThemeData(primarySwatch: Colors.blue),
        // >>> MODIFICAÇÃO AQUI <<<
        // Usa um FutureBuilder para verificar o estado inicial de autenticação
        home: FutureBuilder<User?>(
          // Verifica o estado atual do utilizador no Firebase Auth
          future: FirebaseAuth.instance.authStateChanges().first, // Pega o primeiro estado emitido
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Mostra um loading enquanto espera pelo estado inicial
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            } else {
              final User? user = snapshot.data;
              if (user == null) {
                // Se não há utilizador autenticado, mostra a tela de Login
                return LoginView();
              } else {
                // Se há um utilizador autenticado, mostra a tela Home
                return HomeView();
              }
            }
          },
        ),
        // <<< FIM DA MODIFICAÇÃO >>>
        debugShowCheckedModeBanner: false, // Remove o banner de debug
      ),
    );
  }
}
