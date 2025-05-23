import 'dart:async'; // Importar para usar StreamSubscription
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';
import '../views/auth/login_view.dart';
import '../views/home/home_view.dart';

// Converter para StatefulWidget
class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  // Adicionar uma subscrição de stream
  StreamSubscription<AppUser?>? _authStateSubscription;

  @override
  void initState() {
    super.initState();
    print('AuthWrapperState: initState called.');

    // Obter o AuthRepository via Provider
    final authRepository = Provider.of<AuthRepository>(context, listen: false);

    // Subscrever diretamente ao stream de utilizador
    _authStateSubscription = authRepository.user.listen((user) {
      print('AuthWrapperState: DIRECT STREAM LISTENER - Received User: $user');
      // Podemos forçar uma reconstrução aqui para ver se a UI reage,
      // embora o StreamBuilder já devesse fazer isso.
      // setState(() {}); // Descomentar se quisermos forçar reconstrução
    });

    // O StreamBuilder ainda estará a ouvir o mesmo stream abaixo
  }

  @override
  void dispose() {
    print('AuthWrapperState: dispose called. Cancelling stream subscription.');
    // Cancelar a subscrição para evitar fugas de memória
    _authStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // O StreamBuilder continua a observar o stream do AuthRepository
    final authUserStream = Provider.of<AuthRepository>(context).user;

    print('AuthWrapperState: build called.');

    return StreamBuilder<AppUser?>(
      stream: authUserStream,
      builder: (context, snapshot) {
        print(
          'AuthWrapperState: StreamBuilder - Connection State: ${snapshot.connectionState}',
        );
        print(
          'AuthWrapperState: StreamBuilder - Data (User): ${snapshot.data}',
        );

        if (snapshot.connectionState == ConnectionState.waiting) {
          print(
            'AuthWrapperState: StreamBuilder - Connection State is waiting, showing loading.',
          );
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          print(
            'AuthWrapperState: StreamBuilder - Has error: ${snapshot.error}',
          );
          // Opcional: Mostrar tela de erro
          return Scaffold(
            body: Center(child: Text('Ocorreu um erro: ${snapshot.error}')),
          );
        } else {
          final AppUser? user = snapshot.data;

          if (user == null) {
            print(
              'AuthWrapperState: StreamBuilder - User is null, showing LoginView.',
            );
            return LoginView();
          } else {
            print(
              'AuthWrapperState: StreamBuilder - User is not null (${user.uid}), showing HomeView.',
            );
            return HomeView();
          }
        }
      },
    );
  }
}
