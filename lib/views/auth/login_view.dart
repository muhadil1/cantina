import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/auth/login_viewmodel.dart';
import 'package:cantina/views/auth/signup_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Acessa o ViewModel usando Provider
    final loginViewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            if (loginViewModel.isLoading) // Mostra indicador de loading se estiver a carregar
              CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: () async {
                  // Chama o método do ViewModel ao pressionar o botão
                  bool success = await loginViewModel.signIn(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                  if (success) {
                    // Navegar para a próxima tela (ex: HomeView)
                    print('Login Successful!');
                    // TODO: Implementar navegação
                  } else {
                    // Mostrar mensagem de erro (ex: usando um SnackBar)
                    print('Login Failed: ${loginViewModel.errorMessage}');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(loginViewModel.errorMessage!)),
                    );
                  }
                },
                child: Text('Login'),
              ),
            if (loginViewModel.errorMessage != null) // Mostra mensagem de erro
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  loginViewModel.errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            TextButton(
              onPressed: () {
                // Navegar para a tela de Registo
                Navigator.pushReplacement( // Substitui a tela atual pela de Registo
                  context,
                  MaterialPageRoute(builder: (context) => SignupView()),
                );
              },
              child: Text('Não tem conta? Registe-se'),
            ),
          ],
        ),
      ),
    );
  }
}