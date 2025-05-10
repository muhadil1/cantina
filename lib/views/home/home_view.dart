import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../repositories/auth_repository.dart';
import '../menu/cantina_menu_view.dart'; // Importar a View da Cantina
import '../menu/externo_menu_view.dart'; // Importar a View Externa


class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Bem-vindo!')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Conteúdo da Aplicação (Autenticado)',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                print('->> Logout button was tapped!');
                try {
                  print('HomeView: Getting AuthRepository...');
                  final authRepository = Provider.of<AuthRepository>(context, listen: false);
                  print('HomeView: AuthRepository obtained. Attempting sign out...');
                  await authRepository.signOut();
                  print('HomeView: authRepository.signOut() completed.');

                  final currentUserAfterSignOut = FirebaseAuth.instance.currentUser;
                  print('HomeView: FirebaseAuth.instance.currentUser after sign out: $currentUserAfterSignOut');

                } catch (e) {
                  print('HomeView: Error caught during sign out: $e');
                }
                print('->> End of Logout button onPressed <<-');
              },
              child: Text('Logout'),
            ),
            SizedBox(height: 20), // Espaço entre os botões
            ElevatedButton(
              onPressed: () {
                // Navegar para a tela do Cardápio da Cantina
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CanteenMenuView()),
                );
              },
              child: Text('Ver Cardápio da Cantina'),
            ),
            SizedBox(height: 10), // Espaço entre os botões
            ElevatedButton(
              onPressed: () {
                // Navegar para a tela de Cardápios Externos
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExternalMenuView()),
                );
              },
              child: Text('Ver Cardápios Externos'),
            ),
          ],
        ),
      ),
    );
  }
}