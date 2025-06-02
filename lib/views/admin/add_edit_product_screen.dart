import 'package:flutter/material.dart';
import 'package:cantina/views/admin/product_management_screen.dart';

class AddEditProductScreen extends StatefulWidget {
  final Product? product; // Produto a ser editado (opcional)

  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _selectedCategory;
  final TextEditingController _imageUrlController = TextEditingController();
  bool _isAvailable = true;

  // Lista de categorias de exemplo
  final List<String> _categories = [
    'Salgados',
    'Doces',
    'Bebidas',
    'Refeições',
  ];

  @override
  void initState() {
    super.initState();
    // Se estiver editando um produto, preenche os campos com os dados existentes
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toStringAsFixed(2);
      _selectedCategory = widget.product!.category;
      _imageUrlController.text = widget.product!.imageUrl;
      _isAvailable = widget.product!.isAvailable;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  // Função para salvar o produto
  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Gera um ID para o novo produto ou usa o existente para edição
      final String id =
          widget.product?.id ??
          DateTime.now().microsecondsSinceEpoch.toString();

      final newProduct = Product(
        id: id,
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        category:
            _selectedCategory ??
            'Outros', // Categoria padrão se nenhuma for selecionada
        imageUrl:
            _imageUrlController.text.isEmpty
                ? 'https://via.placeholder.com/150/CCCCCC/000000?text=Sem+Imagem' // Imagem placeholder
                : _imageUrlController.text,
        isAvailable: _isAvailable,
      );

      // Retorna o produto para a tela anterior (ProductManagementScreen)
      Navigator.of(context).pop(newProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product == null ? 'Adicionar Produto' : 'Editar Produto',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Produto',
                  hintText: 'Ex: Sanduíche de Queijo',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do produto.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Detalhes sobre o produto...',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma descrição.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Preço (MZ)',
                  hintText: 'Ex: 150.00',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o preço.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Preço inválido. Use um número.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Categoria'),
                hint: const Text('Selecione uma categoria'),
                items:
                    _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione uma categoria.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL da Imagem (Opcional)',
                  hintText: 'Ex: https://example.com/imagem.png',
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Disponível:'),
                  const SizedBox(width: 8),
                  Switch(
                    value: _isAvailable,
                    onChanged: (bool value) {
                      setState(() {
                        _isAvailable = value;
                      });
                    },
                    activeColor: Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _saveProduct,
                icon: const Icon(Icons.save),
                label: Text(
                  widget.product == null
                      ? 'Adicionar Produto'
                      : 'Salvar Alterações',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              if (widget.product != null) ...[
                // Mostra o botão de excluir apenas na edição
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    // Lógica para excluir o produto - em uma app real, pediria confirmação
                    Navigator.of(context).pop(
                      null,
                    ); // Retorna nulo para indicar que não houve edição, apenas exclusão
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    'Excluir Produto',
                    style: TextStyle(color: Colors.red),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
