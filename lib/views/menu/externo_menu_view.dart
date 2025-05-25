import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../repositories/auth_repository.dart';
import '../../viewmodels/menu/externo_menu_viewmodel.dart';
import '../../models/menu_item.dart';
import '../../viewmodels/order/cart_viewmodel.dart';
import '../order/cart_view.dart'; // Ensure CartView is imported
import '../auth/login_view.dart'; // Import the login view

class ExternalMenuView extends StatefulWidget {
  @override
  _ExternalViewState createState() => _ExternalViewState();
}

class _ExternalViewState extends State<ExternalMenuView> {
  @override
  void initState() {
    super.initState();
    // Carrega os cardápios externos assim que a tela é inicializada
    Provider.of<ExternalMenuViewModel>(
      context,
      listen: false,
    ).loadExternalMenus();
  }

  @override
  Widget build(BuildContext context) {
    final menuViewModel = Provider.of<ExternalMenuViewModel>(context);
    final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
    final authRepository = Provider.of<AuthRepository>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cardápios Externos'),
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
                    constraints: BoxConstraints(minWidth: 16, minHeight: 16),
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginView(),
                ), // Navigate to LoginView
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue[50], // Soft light background color
        ),
        child: Column(
          children: [
            // Header with image
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/estabelecimentos.png', // Update with the correct image path
                    height: 100,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Explore os Cardápios Externos',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
            ),
            // Menu Items List
            Expanded(
              child:
                  menuViewModel.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : menuViewModel.errorMessage != null
                      ? Center(child: Text(menuViewModel.errorMessage!))
                      : ListView.builder(
                        itemCount: menuViewModel.menuItems.length,
                        itemBuilder: (context, index) {
                          final menuItem = menuViewModel.menuItems[index];
                          return Card(
                            elevation: 2.0,
                            margin: EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      menuItem.imageUrl,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Container(
                                          width: 100,
                                          height: 100,
                                          color: Colors.grey[300],
                                          child: Icon(
                                            Icons.broken_image,
                                            color: Colors.grey[600],
                                          ),
                                        );
                                      },
                                      loadingBuilder: (
                                        context,
                                        child,
                                        loadingProgress,
                                      ) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Container(
                                          width: 100,
                                          height: 100,
                                          color: Colors.grey[300],
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              value:
                                                  loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 12.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          menuItem.name,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4.0),
                                        Text(
                                          menuItem.description,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          'Preço: ${menuItem.price.toStringAsFixed(2)} MZN',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 12.0),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.add_shopping_cart,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: () {
                                        cartViewModel.addItem(menuItem);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              '${menuItem.name} adicionado ao carrinho!',
                                            ),
                                            duration: Duration(seconds: 1),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
