import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets/core/models/customer.dart';
import 'package:tickets/features/clients/customer_provider.dart';

class TicketCustomerSelectionModal extends StatelessWidget {
  const TicketCustomerSelectionModal({super.key, required this.onSelected});
  final void Function(Customer) onSelected;

  @override
  Widget build(BuildContext context) {
    List<Customer> customers = context.watch<CustomerProvider>().customers;
    debugPrint('${customers.length}');
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shopping_bag, color: Colors.blueAccent),
              const SizedBox(width: 10),
              Text(
                'Agregar productos',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: customers.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final customer = customers[index];
                return ListTile(
                  title: Text(
                    customer.name,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.blueAccent,
                    ),
                  ),
                  subtitle: Text(
                    customer.fullName,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  onTap: () {
                    onSelected(customer);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
