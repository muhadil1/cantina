import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../repositories/auth_repository.dart';
import '../../viewmodels/order/cart_viewmodel.dart';
import '../../models/cart_item.dart';
import '../auth/login_view.dart'; // Import the LoginView

class CartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context);
    final authRepository = Provider.of<AuthRepository>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Carrinho'),
        actions: [
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
          gradient: LinearGradient(
            colors: [Colors.lightBlue[50]!, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child:
                  cartViewModel.items.isEmpty
                      ? Center(child: Text('O carrinho está vazio.'))
                      : ListView.builder(
                        itemCount: cartViewModel.items.length,
                        itemBuilder: (context, index) {
                          final cartItem = cartViewModel.items[index];
                          return CartItemTile(cartItem: cartItem);
                        },
                      ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Total: ${cartViewModel.totalAmount.toStringAsFixed(2)} MZN',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  if (cartViewModel.isPlacingOrder)
                    Center(child: CircularProgressIndicator())
                  else
                    ElevatedButton(
                      onPressed:
                          cartViewModel.items.isEmpty
                              ? null
                              : () async {
                                bool success = await cartViewModel.placeOrder();
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Encomenda submetida com sucesso!',
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        cartViewModel.orderErrorMessage ??
                                            'Erro desconhecido ao encomendar.',
                                      ),
                                    ),
                                  );
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Efetuar Encomenda',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  if (cartViewModel.orderErrorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        cartViewModel.orderErrorMessage!,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget to display each item in the cart
class CartItemTile extends StatelessWidget {
  final CartItem cartItem;

  const CartItemTile({Key? key, required this.cartItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context, listen: false);

    return Card(
      elevation: 4.0, // Increased shadow for a modern look
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                cartItem.imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey[300],
                    child: Icon(Icons.broken_image, color: Colors.grey[600]),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey[300],
                    child: Center(
                      child: CircularProgressIndicator(
                        value:
                            loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Unitário: ${cartItem.price.toStringAsFixed(2)} MZN',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Total: ${cartItem.totalPrice.toStringAsFixed(2)} MZN',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    cartViewModel.removeItem(cartItem.menuItem);
                  },
                  child: Icon(Icons.remove_circle_outline, size: 24),
                ),
                SizedBox(width: 8.0),
                Text(
                  '${cartItem.quantity}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8.0),
                GestureDetector(
                  onTap: () {
                    cartViewModel.addItem(cartItem.menuItem);
                  },
                  child: Icon(Icons.add_circle_outline, size: 24),
                ),
                SizedBox(width: 8.0),
                GestureDetector(
                  onTap: () {
                    cartViewModel.removeAllOfItem(cartItem.menuItem);
                  },
                  child: Icon(
                    Icons.delete_outline,
                    size: 24,
                    color: Colors.red[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
