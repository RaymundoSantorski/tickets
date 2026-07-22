import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const DashboardShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,

      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,

        onDestinationSelected: (index) {
          navigationShell.goBranch(index);
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: "Inicio",
          ),

          NavigationDestination(
            icon: Icon(Icons.people_outline),
            label: "Clientes",
          ),

          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            label: "Productos",
          ),

          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            label: "Tickets",
          ),

          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: "Conf.",
          ),
        ],
      ),
    );
  }
}
