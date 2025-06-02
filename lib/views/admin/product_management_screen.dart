import 'package:flutter/material.dart';
import 'package:cantina/views/admin/add_edit_product_screen.dart';

// Modelo de Produto (simulado, sem Firebase)
class Product {
  final String id;
  String name;
  String description;
  double price;
  String category;
  String imageUrl;
  bool isAvailable;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.isAvailable = true,
  });
}

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  State<ProductManagementScreen> createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  // Lista de produtos simulada (em uma app real, viria do Firebase)
  final List<Product> _products = [
    Product(
      id: 'p1',
      name: 'Sanduíche de Frango',
      description: 'Pão de forma, frango desfiado, maionese, alface e tomate.',
      price: 150.00,
      category: 'Salgados',
      imageUrl: 'https://via.placeholder.com/150/FF5733/FFFFFF?text=Sanduiche',
      isAvailable: true,
    ),
    Product(
      id: 'p2',
      name: 'Bolo de Chocolate',
      description: 'Fatia de bolo de chocolate com cobertura.',
      price: 120.00,
      category: 'Doces',
      imageUrl: 'https://via.placeholder.com/150/C70039/FFFFFF?text=Bolo',
      isAvailable: false,
    ),
    Product(
      id: 'p3',
      name: 'Sumo de Laranja',
      description: 'Sumo natural de laranja feito na hora.',
      price: 80.00,
      category: 'Bebidas',
      imageUrl: 'https://via.placeholder.com/150/900C3F/FFFFFF?text=Sumo',
      isAvailable: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Pesquisar produtos...',
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
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        // Imagem do produto
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            product.imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'MZ ${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(product.category, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text('Disponível: '),
                                  Switch(
                                    value: product.isAvailable,
                                    onChanged: (bool value) {
                                      setState(() {
                                        product.isAvailable = value;
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('${product.name} agora está ${value ? 'Disponível' : 'Esgotado'}'),
                                            duration: const Duration(seconds: 1),
                                          ),
                                        );
                                        // Em uma app real, você atualizaria no Firebase
                                      });
                                    },
                                    activeColor: Colors.green,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                // Navegar para a tela de edição
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddEditProductScreen(product: product),
                                  ),
                                ).then((result) {
                                  if (result != null && result is Product) {
                                    setState(() {
                                      // Atualiza o produto na lista se editado
                                      final index = _products.indexWhere((p) => p.id == result.id);
                                      if (index != -1) {
                                        _products[index] = result;
                                      }
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${result.name} atualizado com sucesso!')),
                                    );
                                  }
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Diálogo de confirmação para exclusão
                                _confirmDeleteProduct(product);
                              },
                            ),
                          ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar para a tela de adicionar produto
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditProductScreen()),
          ).then((result) {
            if (result != null && result is Product) {
              setState(() {
                _products.add(result); // Adiciona o novo produto à lista
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${result.name} adicionado com sucesso!')),
              );
            }
          });
        },
        child: const Icon(Icons.add),
        tooltip: 'Adicionar Produto',
      ),
    );
  }

  // Função para confirmar exclusão
  void _confirmDeleteProduct(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text('Tem certeza que deseja excluir "${product.name}"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() {
                  _products.removeWhere((p) => p.id == product.id);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product.name} excluído com sucesso!')),
                );
                // Em uma app real, você excluiria do Firebase
              },
            ),
          ],
        );
      },
    );
  }
}