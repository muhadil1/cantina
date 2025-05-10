import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/menu/externo_menu_viewmodel.dart';
import '../../models/menu_item.dart';

class ExternalMenuView extends StatefulWidget {
  @override
  _ExternalViewState createState() => _ExternalViewState();
}

class _ExternalViewState extends State<ExternalMenuView> {
  @override
  void initState() {
    super.initState();
    // Carrega os cardápios externos assim que a tela é inicializada
    Provider.of<ExternalMenuViewModel>(context, listen: false).loadExternalMenus();
  }

  @override
  Widget build(BuildContext context) {
    // Acessa o ViewModel usando Provider
    final menuViewModel = Provider.of<ExternalMenuViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Cardápios Externos')),
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