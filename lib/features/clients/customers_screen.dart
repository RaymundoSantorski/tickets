import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets/core/models/customer.dart';
import 'package:tickets/features/clients/add_customer_screen.dart';
import 'package:tickets/features/clients/customer_detail_screen.dart';
import 'package:tickets/features/clients/customer_provider.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Customer> customers = context.watch<CustomerProvider>().customers;
    CustomerProvider db = context.read<CustomerProvider>();

    void onPressed({Customer? customer}) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AddCustomerScreen(customer: customer),
        ),
      );
    }

    void search(String value) {
      db.search(value);
    }

    Future<void> confirmDelete(
      BuildContext context,
      CustomerProvider db,
      Customer customer,
    ) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
                SizedBox(width: 10),
                Text('¿Eliminar cliente?'),
              ],
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    '¿Estás seguro de que deseas eliminar a "${customer.name}"?',
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Esta acción no se puede deshacer y perderás los datos relacionados con el cliente',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Eliminar'),
                onPressed: () async {
                  Navigator.of(context).pop();

                  await db.delete(customer.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        persist: false,
                        duration: Duration(seconds: 3),
                        content: Text('"${customer.name}" ha sido eliminado.'),
                        action: SnackBarAction(
                          label: 'Deshacer',
                          textColor: Colors.white,
                          onPressed: () {
                            db.save(customer);
                          },
                        ),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Clientes')),
      floatingActionButton: FloatingActionButton(
        onPressed: onPressed,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: customers.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Card(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) => search(value),
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                ],
              ),
            );
          }
          Customer customer = customers[index - 1];
          return Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            CustomerDetailScreen(customer: customer),
                      ),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.person, size: 30.0),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(customer.name),
                                Text(customer.fullName),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => confirmDelete(context, db, customer),
                icon: Icon(Icons.delete),
              ),
              IconButton(
                onPressed: () => onPressed(customer: customer),
                icon: Icon(Icons.edit),
              ),
            ],
          );
        },
      ),
    );
  }
}
