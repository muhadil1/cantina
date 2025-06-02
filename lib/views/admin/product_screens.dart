import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../viewmodels/menu/cantina_menu_viewmodel.dart';
import '../../viewmodels/menu/externo_menu_viewmodel.dart';

class CombinedProductsView extends StatefulWidget {
  const CombinedProductsView({super.key});

  @override
  State<CombinedProductsView> createState() => _CombinedProductsViewState();
}

class _CombinedProductsViewState extends State<CombinedProductsView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedSegment = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Carrega ambos os menus quando a tela é inicializada
    Provider.of<CanteenMenuViewModel>(context, listen: false).loadCanteenMenu();
    Provider.of<ExternalMenuViewModel>(context, listen: false).loadExternalMenus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canteenVm = Provider.of<CanteenMenuViewModel>(context);
    final externalVm = Provider.of<ExternalMenuViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos os Produtos'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(
                  canteenItems: canteenVm.menuItems,
                  externalItems: externalVm.menuItems,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(
                  value: 0,
                  label: Text('Cantina'),
                  icon: Icon(Icons.restaurant),
                ),
                ButtonSegment(
                  value: 1,
                  label: Text('Externos'),
                  icon: Icon(Icons.store),
                ),
                ButtonSegment(
                  value: 2,
                  label: Text('Todos'),
                  icon: Icon(Icons.all_inclusive),
                ),
              ],
              selected: {_selectedSegment},
              onSelectionChanged: (Set<int> newSelection) {
                setState(() {
                  _selectedSegment = newSelection.first;
                });
              },
            ),
          ),
          Expanded(
            child: _buildProductList(canteenVm, externalVm),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(CanteenMenuViewModel canteenVm, ExternalMenuViewModel externalVm) {
    if (canteenVm.isLoading || externalVm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (canteenVm.errorMessage != null || externalVm.errorMessage != null) {
      return Center(
        child: Text(canteenVm.errorMessage ?? externalVm.errorMessage ?? 'Erro desconhecido'),
      );
    }

    List<dynamic> itemsToShow = [];
    String emptyMessage = '';

    switch (_selectedSegment) {
      case 0: // Cantina
        itemsToShow = canteenVm.menuItems;
        emptyMessage = 'Nenhum produto da cantina encontrado';
        break;
      case 1: // Externos
        itemsToShow = externalVm.menuItems;
        emptyMessage = 'Nenhum produto externo encontrado';
        break;
      case 2: // Todos
        itemsToShow = [...canteenVm.menuItems, ...externalVm.menuItems];
        emptyMessage = 'Nenhum produto disponível';
        break;
    }

    // Aplica filtro de pesquisa se houver
    if (_searchQuery.isNotEmpty) {
      itemsToShow = itemsToShow.where((item) {
        return item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    if (itemsToShow.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    return ListView.builder(
      itemCount: itemsToShow.length,
      itemBuilder: (context, index) {
        final item = itemsToShow[index];
        final isCanteenProduct = index < canteenVm.menuItems.length && _selectedSegment != 1;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood),
              ),
            ),
            title: Text(item.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'MZ ${item.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            trailing: Chip(
              label: Text(isCanteenProduct ? 'Cantina' : 'Externo'),
              backgroundColor: isCanteenProduct
                  ? Colors.orange.withOpacity(0.2)
                  : Colors.blue.withOpacity(0.2),
            ),
          ),
        );
      },
    );
  }
}

class ProductSearchDelegate extends SearchDelegate {
  final List<dynamic> canteenItems;
  final List<dynamic> externalItems;

  ProductSearchDelegate({
    required this.canteenItems,
    required this.externalItems,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final allItems = [...canteenItems, ...externalItems];
    final results = allItems.where((item) {
      return item.name.toLowerCase().contains(query.toLowerCase()) ||
          item.description.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        final isCanteen = canteenItems.contains(item);

        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(item.name),
          subtitle: Text('MZ ${item.price.toStringAsFixed(2)}'),
          trailing: Chip(
            label: Text(isCanteen ? 'Cantina' : 'Externo'),
            backgroundColor: isCanteen
                ? Colors.orange.withOpacity(0.2)
                : Colors.blue.withOpacity(0.2),
          ),
          onTap: () {
            close(context, item);
          },
        );
      },
    );
  }
}