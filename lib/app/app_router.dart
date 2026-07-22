import 'package:go_router/go_router.dart';
import 'package:tickets/features/clients/customers_screen.dart';
import 'package:tickets/features/dashboard/dashboard_screen.dart';
import 'package:tickets/features/products/products_screen.dart';
import 'package:tickets/features/settings/settings_screen.dart';
import 'package:tickets/features/tickets/tickets_screen.dart';
import 'package:tickets/shared/dashboard_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/',

  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return DashboardShell(navigationShell: navigationShell);
      },

      branches: [
        // Dashboard
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/', builder: (_, __) => const DashboardScreen()),
          ],
        ),

        // Clientes
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/customers',

              builder: (_, __) => const CustomersScreen(),
            ),
          ],
        ),

        // Productos
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/products',

              builder: (_, __) => const ProductsScreen(),
            ),
          ],
        ),

        // Tickets
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/tickets',

              builder: (_, __) => const TicketsScreen(),
            ),
          ],
        ),

        // Configuración
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',

              builder: (_, __) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
