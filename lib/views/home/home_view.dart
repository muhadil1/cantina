import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../repositories/auth_repository.dart';
import '../../viewmodels/order/cart_viewmodel.dart'; // <<< Importar CartViewModel
import '../menu/cantina_menu_view.dart';
import '../menu/externo_menu_view.dart';
import '../order/cart_view.dart'; // <<< Importar a View do Carrinho

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('HomeView: Build method called.');
    final authRepository = Provider.of<AuthRepository>(context, listen: false);

    return Consumer<CartViewModel>(
      // <<< Envolva com Consumer
      builder: (context, cartViewModel, child) {
        // <<< builder function

        return Scaffold(
          appBar: AppBar(
            title: Text('Bem-vindo!'),
            actions: [
              // Ícone do Carrinho com Contador
              Stack(
                // Use Stack para posicionar o número sobre o ícone
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartView()),
                      );
                    },
                  ),
                  if (cartViewModel
                      .items
                      .isNotEmpty) // Mostra o contador apenas se houver itens
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cartViewModel.items.length}', // Mostra o número de itens
                          style: TextStyle(color: Colors.white, fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              // Botão de Logout
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  await authRepository.signOut();
                },
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Conteúdo principal aqui', style: TextStyle(fontSize: 20)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CanteenMenuView(),
                      ),
                    );
                  },
                  child: Text('Ver Cardápio da Cantina'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExternalMenuView(),
                      ),
                    );
                  },
                  child: Text('Ver Cardápios Externos'),
                ),
              ],
            ),
          ),
        );
      }, // <<< Fim da builder function do Consumer
    ); // <<< Fim do Consumer
  }
}
