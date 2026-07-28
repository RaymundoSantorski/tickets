import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets/app/app.dart';
import 'package:tickets/features/clients/customer_provider.dart';
import 'package:tickets/features/clients/customer_repository.dart';
import 'package:tickets/features/products/product_repository.dart';
import 'package:tickets/services/database_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseService db = DatabaseService();
  await db.initialize();

  CustomerRepository customerRepository = CustomerRepository(db.isar);
  ProductRepository productRepository = ProductRepository(db.isar);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CustomerProvider(customerRepository),
        ),
      ],
      child: TicketsApp(),
    ),
  );
}
