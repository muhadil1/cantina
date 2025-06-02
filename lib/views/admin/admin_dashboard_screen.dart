import 'package:flutter/material.dart';
import 'package:cantina/views/admin/product_management_screen.dart';
import 'package:cantina/views/admin/order_management_screen.dart';
import 'package:cantina/views/admin/reports_screen.dart';
import 'package:cantina/views/auth/login_view.dart';
//import 'package:admins/auth/login_screen.dart';

// // Descomentar estas linhas no futuro para integrar com Firebase
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

enum AdminScreen { dashboard, products, orders, reports, users }

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  AdminScreen _selectedScreen = AdminScreen.dashboard;

  void _logout() {
    // // Descomentar no futuro para logout com Firebase
    // FirebaseAuth.instance.signOut();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginView()),
      (Route<dynamic> route) => false,
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Sessão encerrada.')));
  }

  Widget _getScreenWidget() {
    switch (_selectedScreen) {
      case AdminScreen.dashboard:
        return _DashboardOverview(); // Onde a mágica acontece!
      case AdminScreen.products:
        return const ProductManagementScreen();
      case AdminScreen.orders:
        return const OrderManagementScreen();
      case AdminScreen.reports:
        return const ReportsScreen();
      case AdminScreen.users:
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_alt_outlined, size: 80, color: Colors.grey),
                SizedBox(height: 20),
                Text(
                  'Gerenciamento de Usuários',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Aqui você poderá ver, adicionar e gerenciar os privilégios dos usuários do aplicativo (alunos, funcionários, etc.).',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                // Botões de ação para a tela de usuários (futuro)
                // ElevatedButton.icon(
                //   onPressed: () { /* Lógica para Adicionar Usuário */ },
                //   icon: Icon(Icons.person_add),
                //   label: Text('Adicionar Novo Usuário'),
                // ),
              ],
            ),
          ),
        );
      default:
        return const Center(child: Text('Página não encontrada'));
    }
  }

  String _getAppBarTitle() {
    switch (_selectedScreen) {
      case AdminScreen.dashboard:
        return 'Dashboard do Administrador';
      case AdminScreen.products:
        return 'Gerenciar Produtos';
      case AdminScreen.orders:
        return 'Gerenciar Pedidos';
      case AdminScreen.reports:
        return 'Relatórios';
      case AdminScreen.users:
        return 'Gerenciar Usuários';
      default:
        return 'Cantina Admin';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Lógica para recarregar dados (no futuro, do Firebase)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dados atualizados (simulado)!')),
              );
            },
            tooltip: 'Atualizar Dados',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                // Adiciona um gradiente sutil para o DrawerHeader
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.9),
                    Theme.of(context).primaryColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 35, // Aumenta o tamanho do avatar
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.admin_panel_settings,
                      size: 45,
                      color: Colors.green,
                    ), // Ícone de admin
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Admin da Cantina',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22, // Texto maior
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'admin@isutc.edu.mz',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              icon: Icons.dashboard_outlined,
              title: 'Dashboard',
              screen: AdminScreen.dashboard,
            ),
            _buildDrawerItem(
              icon: Icons.fastfood_outlined,
              title: 'Produtos',
              screen: AdminScreen.products,
            ),
            _buildDrawerItem(
              icon: Icons.receipt_long_outlined,
              title: 'Pedidos',
              screen: AdminScreen.orders,
            ),
            _buildDrawerItem(
              icon: Icons.analytics_outlined,
              title: 'Relatórios',
              screen: AdminScreen.reports,
            ),
            _buildDrawerItem(
              icon: Icons.people_outline,
              title: 'Usuários',
              screen: AdminScreen.users,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: _getScreenWidget(),
    );
  }

  ListTile _buildDrawerItem({
    required IconData icon,
    required String title,
    required AdminScreen screen,
  }) {
    // Destaca o item selecionado com a cor primária
    final bool isSelected = _selectedScreen == screen;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[800],
          fontSize: 16, // Aumenta um pouco o tamanho da fonte
        ),
      ),
      selected: isSelected,
      selectedTileColor: Theme.of(
        context,
      ).primaryColor.withOpacity(0.1), // Fundo suave para o item selecionado
      onTap: () {
        setState(() {
          _selectedScreen = screen;
        });
        Navigator.pop(context);
      },
    );
  }
}

// --- VISÃO GERAL DO DASHBOARD ---
class _DashboardOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0), // Aumenta o padding geral
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título da Seção
          Text(
            'Bem-vindo, Administrador!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Text(
            'Visão geral das operações da Cantina ISUTC.',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 30),

          // Cards de Métricas Chave
          GridView.count(
            crossAxisCount: 2, // 2 cards por linha
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 20, // Espaçamento entre os cards
            crossAxisSpacing: 20,
            children: [
              _buildMetricCard(
                context,
                icon: Icons.pending_actions_rounded,
                title: 'Pedidos Pendentes',
                value: '05', // Use zero-padding para números pequenos
                color: Colors.orange.shade700,
                // onTap: () { /* Navegar para pedidos pendentes */ },
              ),
              _buildMetricCard(
                context,
                icon: Icons.currency_exchange_rounded,
                title: 'Vendas Hoje',
                value: 'MZ 3.500',
                color: Colors.green.shade700,
                // onTap: () { /* Navegar para relatórios de vendas */ },
              ),
              _buildMetricCard(
                context,
                icon: Icons.inventory_2_rounded,
                title: 'Produtos Esgotados',
                value: '02',
                color: Colors.red.shade700,
                // onTap: () { /* Navegar para gerenciamento de estoque */ },
              ),
              _buildMetricCard(
                context,
                icon: Icons.fastfood_rounded,
                title: 'Total de Produtos',
                value: '45',
                color: Colors.blue.shade700,
                // onTap: () { /* Navegar para gerenciamento de produtos */ },
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Seção de Atividade Recente ou Pedidos Recentes
          Text(
            'Atividade Recente',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),
          _buildActivityCard(
            context,
            title: 'Pedido #ORD004 Recebido',
            subtitle: 'Aluno: Ana Paula | Total: MZ 250.00',
            icon: Icons.add_shopping_cart_rounded,
            iconColor: Colors.teal.shade400,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Visualizando Pedido #ORD004')),
              );
              // Lógica para navegar para o detalhe do pedido
            },
          ),
          _buildActivityCard(
            context,
            title: 'Produto Adicionado: Salada Fresca',
            subtitle: 'Categoria: Refeições | Preço: MZ 180.00',
            icon: Icons.library_add_check_rounded,
            iconColor: Colors.purple.shade400,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Visualizando Salada Fresca')),
              );
              // Lógica para navegar para o detalhe do produto
            },
          ),
          _buildActivityCard(
            context,
            title: 'Status do Pedido #ORD002 Atualizado',
            subtitle: 'De "Em Preparação" para "Pronto para Retirada"',
            icon: Icons.update_rounded,
            iconColor: Colors.indigo.shade400,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Visualizando Pedido #ORD002')),
              );
              // Lógica para navegar para o detalhe do pedido
            },
          ),

          const SizedBox(height: 40),

          // Seção de Gráficos/Relatórios Rápidos
          Text(
            'Análise Rápida',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),
          _buildChartPlaceholder(
            context,
            title: 'Vendas Diárias (Últimos 7 Dias)',
            description:
                'Representação visual das vendas para acompanhar tendências.',
            icon: Icons.area_chart_rounded,
            color: Colors.deepOrange.shade300,
          ),
          const SizedBox(height: 20),
          _buildChartPlaceholder(
            context,
            title: 'Distribuição de Pedidos por Categoria',
            description:
                'Entenda quais categorias de produtos são mais populares.',
            icon: Icons.pie_chart_rounded,
            color: Colors.teal.shade300,
          ),
        ],
      ),
    );
  }

  // --- Widgets Auxiliares Aprimorados ---

  // Card para exibir métricas chave
  Widget _buildMetricCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      // Torna o card clicável
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Card(
        elevation: 6, // Maior elevação para destaque
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            // Adiciona um gradiente sutil de acordo com a cor do card
            gradient: LinearGradient(
              colors: [color.withOpacity(0.9), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Icon(
                  icon,
                  size: 38,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 28, // Aumenta o tamanho do valor
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Card para itens de atividade recente
  Widget _buildActivityCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 18,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }

  // Placeholder para gráficos
  Widget _buildChartPlaceholder(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 30, color: color),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bar_chart_outlined,
                      size: 60,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Seu gráfico incrível aparecerá aqui!',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Abrindo relatório detalhado de "$title"...',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.open_in_new),
                label: const Text('Ver Detalhes do Relatório'),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
