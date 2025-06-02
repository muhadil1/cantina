import 'package:flutter/material.dart';

// Modelo de Pedido (simulado)
class Order {
  final String id;
  final String userName;
  final List<OrderItem> items;
  final double totalAmount;
  String status; // Status do pedido (Pendente, Em Preparação, Pronto, Concluído, Cancelado)
  final DateTime orderDate;

  Order({
    required this.id,
    required this.userName,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
  });
}

// Modelo de Item de Pedido
class OrderItem {
  final String productName;
  final int quantity;
  final double price;

  OrderItem({
    required this.productName,
    required this.quantity,
    required this.price,
  });
}

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  // Lista de pedidos simulada
  final List<Order> _orders = [
    Order(
      id: 'ord001',
      userName: 'João Silva',
      items: [
        OrderItem(productName: 'Sanduíche de Frango', quantity: 1, price: 150.00),
        OrderItem(productName: 'Sumo de Laranja', quantity: 1, price: 80.00),
      ],
      totalAmount: 230.00,
      status: 'Pendente',
      orderDate: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    Order(
      id: 'ord002',
      userName: 'Maria Costa',
      items: [
        OrderItem(productName: 'Bolo de Chocolate', quantity: 2, price: 120.00),
      ],
      totalAmount: 240.00,
      status: 'Em Preparação',
      orderDate: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Order(
      id: 'ord003',
      userName: 'Carlos Pereira',
      items: [
        OrderItem(productName: 'Salada de Frutas', quantity: 1, price: 100.00),
        OrderItem(productName: 'Água Mineral', quantity: 1, price: 50.00),
      ],
      totalAmount: 150.00,
      status: 'Concluído',
      orderDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  final List<String> _statusOptions = [
    'Pendente',
    'Em Preparação',
    'Pronto para Retirada',
    'Concluído',
    'Cancelado'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Pesquisar pedidos por nome do aluno...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              // Lógica de filtro/pesquisa (implementar depois)
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: _orders.length,
            itemBuilder: (context, index) {
              final order = _orders[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ExpansionTile( // Usa ExpansionTile para mostrar/esconder detalhes do pedido
                  title: Text('Pedido #${order.id} - ${order.userName}'),
                  subtitle: Text('Total: MZ ${order.totalAmount.toStringAsFixed(2)}'),
                  trailing: DropdownButton<String>(
                    value: order.status,
                    items: _statusOptions.map((String status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (String? newStatus) {
                      if (newStatus != null) {
                        setState(() {
                          order.status = newStatus;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Status do Pedido #${order.id} alterado para: $newStatus'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          // Em uma app real, você atualizaria no Firebase
                        });
                      }
                    },
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Itens do Pedido:', style: TextStyle(fontWeight: FontWeight.bold)),
                          ...order.items.map((item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${item.quantity}x ${item.productName}'),
                                Text('MZ ${item.price.toStringAsFixed(2)}'),
                              ],
                            ),
                          )).toList(),
                          const Divider(),
                          Text('Data do Pedido: ${order.orderDate.day}/${order.orderDate.month} ${order.orderDate.hour}:${order.orderDate.minute}'),
                          // Botão para ver mais detalhes (se necessário) ou ações adicionais
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Detalhes completos do Pedido #${order.id}')),
                                );
                                // Navegar para uma tela de detalhes do pedido mais aprofundada
                              },
                              child: const Text('Ver Detalhes'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}