import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/auth/login_viewmodel.dart';
import 'package:cantina/views/auth/signup_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late AnimationController _backgroundController;
  late AnimationController _formController;
  late Animation<Alignment> _alignmentAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _backgroundController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    )..repeat(reverse: true);

    _alignmentAnimation = Tween<Alignment>(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
    );

    _formController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _formController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _formController, curve: Curves.easeOut));

    _formController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _backgroundController.dispose();
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      body: AnimatedBuilder(
        animation: _alignmentAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: _alignmentAnimation.value,
                end: Alignment.bottomLeft,
                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
              ),
            ),
            child: child,
          );
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 10,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Bem-vindo',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2575FC),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(labelText: 'Senha'),
                          obscureText: true,
                        ),
                        SizedBox(height: 20),
                        if (loginViewModel.isLoading)
                          CircularProgressIndicator()
                        else
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2575FC),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              bool success = await loginViewModel.signIn(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                              if (success) {
                                print('Login Successful!');
                                // TODO: Implementar navegação
                              } else {
                                print(
                                  'Login Failed: ${loginViewModel.errorMessage}',
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(loginViewModel.errorMessage!),
                                  ),
                                );
                              }
                            },
                            child: Text('Entrar'),
                          ),
                        if (loginViewModel.errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              loginViewModel.errorMessage!,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupView(),
                              ),
                            );
                          },
                          child: Text('Não tem conta? Registe-se'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
