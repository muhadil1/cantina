import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Relatórios e Estatísticas',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildReportCard(
            context,
            title: 'Vendas por Dia',
            content: 'Gráfico de barras mostrando vendas diárias (Placeholder)',
            icon: Icons.show_chart,
            color: Colors.blueAccent,
          ),
          const SizedBox(height: 16),
          _buildReportCard(
            context,
            title: 'Produtos Mais Vendidos',
            content: 'Lista dos produtos mais populares (Placeholder)',
            icon: Icons.star,
            color: Colors.orangeAccent,
          ),
          const SizedBox(height: 16),
          _buildReportCard(
            context,
            title: 'Total de Pedidos por Mês',
            content: 'Gráfico de linha mostrando o número de pedidos mensais (Placeholder)',
            icon: Icons.receipt,
            color: Colors.purpleAccent,
          ),
          const SizedBox(height: 16),
          _buildReportCard(
            context,
            title: 'Inventário e Estoque',
            content: 'Visão geral do estoque e alertas de baixo estoque (Placeholder)',
            icon: Icons.warehouse,
            color: Colors.teal,
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para os cards de relatório
  Widget _buildReportCard(BuildContext context, {required String title, required String content, required IconData icon, required Color color}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 30, color: color),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Carregando relatório de "$title"...')),
                  );
                  // Lógica para carregar o relatório detalhado
                },
                child: const Text('Ver Detalhes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}