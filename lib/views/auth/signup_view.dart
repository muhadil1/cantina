import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth/signup_viewmodel.dart';
import 'login_view.dart'; // Para navegar de volta para o Login

class SignupView extends StatefulWidget {
  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
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
    final signupViewModel = Provider.of<SignupViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Registar')),
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
            if (signupViewModel.isLoading) // Mostra indicador de loading se estiver a carregar
              CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: () async {
                  // Chama o método do ViewModel ao pressionar o botão
                  bool success = await signupViewModel.signUp(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                  if (success) {
                    // Se o registo for bem-sucedido, pode navegar para o Login
                    print('Registo Successful!');
                    Navigator.pushReplacement( // Substitui a tela atual pela de Login
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                    );
                  } else {
                    // Mostrar mensagem de erro (ex: usando um SnackBar)
                    print('Registo Failed: ${signupViewModel.errorMessage}');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(signupViewModel.errorMessage!)),
                    );
                  }
                },
                child: Text('Registar'),
              ),
            if (signupViewModel.errorMessage != null) // Mostra mensagem de erro
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  signupViewModel.errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            TextButton(
              onPressed: () {
                // Navegar para a tela de Login
                Navigator.pushReplacement( // Substitui a tela atual pela de Login
                  context,
                  MaterialPageRoute(builder: (context) => LoginView()),
                );
              },
              child: Text('Já tem conta? Faça Login'),
            ),
          ],
        ),
      ),
    );
  }
}