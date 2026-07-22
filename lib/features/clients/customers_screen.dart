import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tickets/core/models/customer.dart';
import 'package:tickets/features/clients/add_customer_screen.dart';
import 'package:tickets/features/clients/customer_provider.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Customer> customers = context.watch<CustomerProvider>().customers;
    CustomerProvider db = context.read<CustomerProvider>();

    void onPressed() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AddCustomerScreen()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Clientes')),
      floatingActionButton: FloatingActionButton(
        onPressed: onPressed,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: customers.length,
        itemBuilder: (context, index) {
          Customer customer = customers[index];
          return Card(
            child: Row(
              children: [
                Icon(Icons.person),
                Column(
                  children: [Text(customer.name), Text(customer.fullName)],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
