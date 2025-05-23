import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/menu/cantina_menu_viewmodel.dart';
import '../../viewmodels/order/cart_viewmodel.dart'; // Importar o CartViewModel

class CanteenMenuView extends StatefulWidget {
  @override
  _CanteenViewState createState() => _CanteenViewState();
}

class _CanteenViewState extends State<CanteenMenuView> {
  @override
  void initState() {
    super.initState();
    Provider.of<CanteenMenuViewModel>(context, listen: false).loadCanteenMenu();
  }

  @override
  Widget build(BuildContext context) {
    final menuViewModel = Provider.of<CanteenMenuViewModel>(context);
    // Acessa o CartViewModel (não precisa ouvir para adicionar itens)
    final cartViewModel = Provider.of<CartViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Cardápio da Cantina')),
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
                    // <<< Usar um Card para dar um visual de "cartão"
                    elevation: 2.0, // Sombra
                    margin: EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ), // Margem entre cartões
                    child: Padding(
                      // Espaçamento interno
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        // Usar Row para organizar imagem à esquerda e detalhes à direita
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start, // Alinha o conteúdo no topo
                        children: [
                          // Imagem do Item
                          ClipRRect(
                            // Cortar a imagem com bordas arredondadas (opcional)
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              menuItem.imageUrl,
                              width: 100, // Largura fixa para a imagem
                              height: 100, // Altura fixa para a imagem
                              fit: BoxFit.cover, // Cobrir a área especificada
                              // Tratamento de erro no carregamento da imagem
                              errorBuilder: (context, error, stackTrace) {
                                // Mostra um ícone de erro ou um placeholder se a imagem falhar
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
                              // Opcional: placeholder enquanto carrega
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
                          SizedBox(
                            width: 12.0,
                          ), // Espaço entre a imagem e os detalhes
                          // Detalhes do Item (Nome, Descrição, Preço)
                          Expanded(
                            // Expande para ocupar o espaço restante na Row
                            child: Column(
                              // Usar Column para empilhar nome, descrição e preço
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start, // Alinha texto à esquerda
                              children: [
                                Text(
                                  menuItem.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1, // Limitar o número de linhas
                                  overflow:
                                      TextOverflow
                                          .ellipsis, // Adicionar "..." se o texto for longo
                                ),
                                SizedBox(
                                  height: 4.0,
                                ), // Espaço entre nome e descrição
                                Text(
                                  menuItem.description,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 2, // Limitar a descrição a 2 linhas
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  height: 8.0,
                                ), // Espaço entre descrição e preço
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
                          SizedBox(
                            width: 12.0,
                          ), // Espaço entre detalhes e botão de compra
                          // Botão de Adicionar ao Carrinho
                          Align(
                            // Alinhar o ícone no topo (opcional, já está pelo crossAxisAlignment.start da Row)
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(
                                Icons.add_shopping_cart,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                // Chama o método do CartViewModel para adicionar o item
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
