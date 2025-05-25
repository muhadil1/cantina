import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../../viewmodels/auth/signup_viewmodel.dart';
import 'login_view.dart';

class SignupView extends StatefulWidget {
  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _apelidoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _apelidoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signupViewModel = Provider.of<SignupViewModel>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Texto animado "Bem-vindo"
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Bem-vindo!',
                    textStyle: const TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
                totalRepeatCount: 1,
                pause: const Duration(milliseconds: 500),
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              ),

              const SizedBox(height: 20),

              // Imagem
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/food2.png',
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Criar Conta',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2575FC),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Nome
                    TextField(
                      controller: _nomeController,
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Apelido
                    TextField(
                      controller: _apelidoController,
                      decoration: InputDecoration(
                        labelText: 'Apelido',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Email
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),

                    // Senha
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 12),

                    // Confirmar senha
                    TextField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirmar Senha',
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),

                    // Botão Registar
                    signupViewModel.isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2575FC),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (_passwordController.text !=
                                _confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('As senhas não coincidem!'),
                                ),
                              );
                              return;
                            }

                            bool success = await signupViewModel.signUp(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                            if (success) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginView(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    signupViewModel.errorMessage ??
                                        'Erro ao registar',
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text('Registar'),
                        ),

                    if (signupViewModel.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          signupViewModel.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),

                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginView()),
                        );
                      },
                      child: const Text('Já tem conta? Faça Login'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
