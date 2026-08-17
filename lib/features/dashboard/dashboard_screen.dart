import 'package:flutter/material.dart';
import 'package:tickets/features/dashboard/widgets/dashboard_item.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DashboardItem(label: 'Clientes', icon: Icons.person),
        DashboardItem(label: 'Productos', icon: Icons.inventory),
        DashboardItem(label: 'Tickets', icon: Icons.receipt),
        DashboardItem(label: 'Configuración', icon: Icons.settings),
      ],
    );
  }
}
