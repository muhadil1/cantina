import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/menu/externo_menu_viewmodel.dart';
import '../../models/menu_item.dart';
import '../../viewmodels/order/cart_viewmodel.dart';

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
    // Acessa o CartViewModel (não precisa ouvir para adicionar itens)
    final cartViewModel = Provider.of<CartViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Cardápios Externos')),
      body:
          menuViewModel.isLoading
              ? Center(child: CircularProgressIndicator())
              : menuViewModel.errorMessage != null
              ? Center(child: Text(menuViewModel.errorMessage!))
              : ListView.builder(
                itemCount: menuViewModel.menuItems.length,
                itemBuilder: (context, index) {
                  final menuItem = menuViewModel.menuItems[index];
                  return Card(
                    // <<< Usar um Card
                    elevation: 2.0,
                    margin: EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        // Usar Row para organizar
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Imagem do Item
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              menuItem.imageUrl,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Tratamento de erro e placeholder para imagem inválida
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
                              // Opcional: loadingBuilder
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[300],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress
                                              .cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 12.0),

                          // Detalhes do Item (Nome, Descrição, Preço)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12.0),

                          // Botão de Adicionar ao Carrinho
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(
                                Icons.add_shopping_cart,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                cartViewModel.addItem(menuItem);
                                ScaffoldMessenger.of(context).showSnackBar(
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
    );
  }
}
