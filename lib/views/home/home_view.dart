import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../repositories/auth_repository.dart';
import '../../viewmodels/order/cart_viewmodel.dart';
import '../menu/cantina_menu_view.dart';
import '../menu/externo_menu_view.dart';
import '../order/cart_view.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('HomeView: Build method called.');
    final authRepository = Provider.of<AuthRepository>(context, listen: false);

    return Consumer<CartViewModel>(
      builder: (context, cartViewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Bem-vindo!'),
            backgroundColor: Colors.blueAccent,
            actions: [
              Stack(
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
                  if (cartViewModel.items.isNotEmpty)
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
                          '${cartViewModel.items.length}',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  await authRepository.signOut();
                },
              ),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightBlueAccent, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bem-vindo!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Image.asset(
                    'assets/food2.png', // Update with your image path
                    height: 200,
                    fit: BoxFit.cover,
                  ),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent, // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 30,
                      ), // Increased padding
                      textStyle: TextStyle(fontSize: 18), // Increased text size
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/isutc.png', // Update with your new image path
                          height: 60, // Increased image height
                        ),
                        SizedBox(width: 10), // Space between image and text
                        Text('Ver Cardápio da Cantina'),
                      ],
                    ),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent, // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 30,
                      ), // Increased padding
                      textStyle: TextStyle(fontSize: 18), // Increased text size
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/estabelecimentos.png', // Update with the other image path for external
                          height: 60, // Increased image height
                        ),
                        SizedBox(width: 10), // Space between image and text
                        Text('Ver Cardápios Externos'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}