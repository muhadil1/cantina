import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart'; // Importar o modelo de utilizador
import '../repositories/auth_repository.dart'; // Importar o repositório de autenticação
import '../views/auth/login_view.dart'; // Importar a tela de Login
import '../views/home/home_view.dart'; // Importar a tela Home

// AuthWrapper como StatelessWidget
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtém o stream de utilizador do AuthRepository via Provider
    // O StreamBuilder irá "ouvir" as mudanças neste stream
    final authUserStream = Provider.of<AuthRepository>(context).user;

    return StreamBuilder<AppUser?>(
      stream: authUserStream, // O stream que estamos a observar
      builder: (context, snapshot) {
        // Verifica o estado da conexão com o stream
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Enquanto espera pelo estado inicial de autenticação, mostra um loading
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          // Se houver um erro no stream (improvável para authStateChanges, mas boa prática)
          print('AuthWrapper: Stream has error: ${snapshot.error}');
          return Scaffold(
            body: Center(
              child: Text('Ocorreu um erro de autenticação.'),
            ),
          );
        }
        else {
          // O snapshot.data contém o último valor emitido pelo stream (o AppUser? ou null)
          final AppUser? user = snapshot.data;

          // Lógica condicional: se o utilizador for null, mostrar LoginView, caso contrário, mostrar HomeView
          if (user == null) {
            // Utilizador não autenticado
            return LoginView();
          } else {
            // Utilizador autenticado
            return HomeView();
          }
        }
      },
    );
  }
}