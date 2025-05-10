import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'services/firebase_auth_service.dart';
import 'services/firestore_service.dart'; // Importar o FirestoreService
import 'repositories/auth_repository.dart';
import 'repositories/menu_repository.dart'; // Importar o MenuRepository
import 'viewmodels/auth/login_viewmodel.dart';
import 'viewmodels/auth/signup_viewmodel.dart';
import 'viewmodels/menu/cantina_menu_viewmodel.dart'; // Importar CanteenMenuViewModel
import 'viewmodels/menu/externo_menu_viewmodel.dart'; // Importar ExternalMenuViewModel
import 'widgets/auth_wrapper.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Serviços Firebase
        Provider<FirebaseAuthService>(
          create: (_) => FirebaseAuthService(),
        ),
        Provider<FirestoreService>( // Fornece o FirestoreService
          create: (_) => FirestoreService(),
        ),

        // Repositórios
        Provider<AuthRepository>(
          create: (context) => AuthRepository(
            Provider.of<FirebaseAuthService>(context, listen: false),
          ),
        ),
        Provider<MenuRepository>( // Fornece o MenuRepository
          create: (context) => MenuRepository(
            Provider.of<FirestoreService>(context, listen: false), // Injete o FirestoreService
          ),
        ),

        // ViewModels de Autenticação
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

        // ViewModels de Cardápio
        ChangeNotifierProvider<CanteenMenuViewModel>( // Fornece CanteenMenuViewModel
          create: (context) => CanteenMenuViewModel(
            Provider.of<MenuRepository>(context, listen: false), // Injete o MenuRepository
          ),
        ),
        ChangeNotifierProvider<ExternalMenuViewModel>( // Fornece ExternalMenuViewModel
          create: (context) => ExternalMenuViewModel(
            Provider.of<MenuRepository>(context, listen: false), // Injete o MenuRepository
          ),
        ),

        // TODO: Adicionar outros ViewModels e Repositórios aqui
      ],
      child: MaterialApp(
        title: 'Cantina ISUTC',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthWrapper(),
      ),
    );
  }
}