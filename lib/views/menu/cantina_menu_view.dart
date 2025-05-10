import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/menu/cantina_menu_viewmodel.dart';
import '../../models/menu_item.dart';

class CanteenMenuView extends StatefulWidget {
  @override
  _CanteenViewState createState() => _CanteenViewState();
}

class _CanteenViewState extends State<CanteenMenuView> {
  @override
  void initState() {
    super.initState();
    // Carrega o cardápio assim que a tela é inicializada
    Provider.of<CanteenMenuViewModel>(context, listen: false).loadCanteenMenu();
  }

  @override
  Widget build(BuildContext context) {
    // Acessa o ViewModel usando Provider
    final menuViewModel = Provider.of<CanteenMenuViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Cardápio da Cantina')),
      body: menuViewModel.isLoading
          ? Center(child: CircularProgressIndicator()) // Mostra loading
          : menuViewModel.errorMessage != null
          ? Center(child: Text(menuViewModel.errorMessage!)) // Mostra erro
          : ListView.builder( // Mostra a lista de itens
        itemCount: menuViewModel.menuItems.length,
        itemBuilder: (context, index) {
          final menuItem = menuViewModel.menuItems[index];
          return ListTile(
            leading: Image.network(menuItem.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
            title: Text(menuItem.name),
            subtitle: Text('${menuItem.description}\nPreço: ${menuItem.price.toStringAsFixed(2)} MZN'),
            isThreeLine: true,
            // TODO: Adicionar funcionalidade para adicionar ao carrinho
          );
        },
      ),
    );
  }
}