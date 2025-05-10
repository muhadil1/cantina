import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';
import '../views/auth/login_view.dart'; // Tela de Login
import '../views/home/home_view.dart'; // Tela Home

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authUser = Provider.of<AuthRepository>(context).user;

    return StreamBuilder<AppUser?>(
      stream: authUser,
      builder: (context, snapshot) {
        print('AuthWrapper: StreamBuilder - Connection State: ${snapshot.connectionState}');
        print('AuthWrapper: StreamBuilder - Data (User): ${snapshot.data}');

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          final AppUser? user = snapshot.data;

          if (user == null) {
            print('AuthWrapper: User is null, showing LoginView.');
            return LoginView();
          } else {
            print('AuthWrapper: User is not null (${user.uid}), showing HomeView.');
            return HomeView();
          }
        }
      },
    );
  }
}