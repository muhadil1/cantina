import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/order/cart_viewmodel.dart';
import '../../models/cart_item.dart';

class CartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Acessa o CartViewModel
    final cartViewModel = Provider.of<CartViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Meu Carrinho')),
      body: Column(
        children: [
          // Lista de Itens no Carrinho
          Expanded(
            child:
                cartViewModel.items.isEmpty
                    ? Center(child: Text('O carrinho está vazio.'))
                    : ListView.builder(
                      itemCount: cartViewModel.items.length,
                      itemBuilder: (context, index) {
                        final cartItem = cartViewModel.items[index];
                        return CartItemTile(
                          cartItem: cartItem,
                        ); // Widget separado para o item
                      },
                    ),
          ),

          // Resumo do Carrinho e Botão de Encomendar
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
                        cartViewModel
                                .items
                                .isEmpty // Desabilita se o carrinho estiver vazio
                            ? null
                            : () async {
                              bool success = await cartViewModel.placeOrder();
                              if (success) {
                                // Mostrar mensagem de sucesso e talvez navegar para histórico de encomendas
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Encomenda submetida com sucesso!',
                                    ),
                                  ),
                                );
                                // Opcional: Navegar para tela de histórico de encomendas
                              } else {
                                // Mostrar mensagem de erro (geralmente já tratada no ViewModel)
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
                    child: Text('Efetuar Encomenda'),
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
    );
  }
}

// Widget separado para exibir um item no carrinho
class CartItemTile extends StatelessWidget {
  final CartItem cartItem;

  const CartItemTile({Key? key, required this.cartItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Acessa o CartViewModel para chamar os métodos de modificação (listen: false)
    final cartViewModel = Provider.of<CartViewModel>(context, listen: false);

    return Card(
      // Usar um Card para cada item do carrinho
      elevation: 1.5, // Sombra mais suave
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          // Organizar imagem e detalhes/controles horizontalmente
          crossAxisAlignment:
              CrossAxisAlignment
                  .center, // Centralizar verticalmente os elementos da Row
          children: [
            // Imagem do Item
            ClipRRect(
              borderRadius: BorderRadius.circular(
                4.0,
              ), // Bordas menos arredondadas que nos cardápios
              child: Image.network(
                cartItem
                    .imageUrl, // Acessa o URL da imagem através do getter no CartItem
                width: 70, // Tamanho um pouco menor que nos cardápios
                height: 70,
                fit: BoxFit.cover,
                // Tratamento de erro e placeholder para imagem inválida
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey[300],
                    child: Icon(Icons.broken_image, color: Colors.grey[600]),
                  );
                },
                // Opcional: loadingBuilder
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
            SizedBox(width: 12.0), // Espaço entre imagem e detalhes
            // Detalhes do Item (Nome, Preço Unitário, Preço Total do Item)
            Expanded(
              // Ocupa o espaço restante
              child: Column(
                // Empilha nome, preços
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Alinha texto à esquerda
                children: [
                  Text(
                    cartItem
                        .name, // Acessa o nome através do getter no CartItem
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Unitário: ${cartItem.price.toStringAsFixed(2)} MZN', // Acessa o preço unitário
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Total: ${cartItem.totalPrice.toStringAsFixed(2)} MZN', // Mostra o preço total deste item (quantidade * preço)
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            // Controles de Quantidade e Remover
            Row(
              // Usar uma Row para agrupar os botões e a quantidade
              mainAxisSize:
                  MainAxisSize
                      .min, // Ocupa o mínimo de espaço horizontal necessário
              children: [
                IconButton(
                  icon: Icon(
                    Icons.remove_circle_outline,
                    size: 20,
                  ), // Ícone de remover (menos)
                  onPressed: () {
                    cartViewModel.removeItem(
                      cartItem.menuItem,
                    ); // Remover 1 unidade
                  },
                ),
                Text(
                  '${cartItem.quantity}', // Exibe a quantidade
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    size: 20,
                  ), // Ícone de adicionar (mais)
                  onPressed: () {
                    cartViewModel.addItem(
                      cartItem.menuItem,
                    ); // Adicionar 1 unidade
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: Colors.red[600],
                  ), // Ícone de remover completamente
                  onPressed: () {
                    cartViewModel.removeAllOfItem(
                      cartItem.menuItem,
                    ); // Remover todos do item
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
