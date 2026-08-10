import 'package:flutter/material.dart';
import 'package:tickets/core/models/product.dart';
import 'package:tickets/features/tickets/ticket_item.dart';
import 'package:tickets/features/tickets/ticket_product_selection_modal.dart';

class TicketForm extends StatefulWidget {
  const TicketForm({super.key});

  @override
  State<TicketForm> createState() => _TicketFormState();
}

class _TicketFormState extends State<TicketForm> {
  final List<TicketItem> ticketProducts = [];

  @override
  Widget build(BuildContext context) {
    void onAdd(TicketItem product) {
      if (ticketProducts
          .where((item) => item.productId == product.productId)
          .isNotEmpty)
        return;

      setState(() {
        ticketProducts.add(product);
      });
    }

    void addUnits(int id) {
      TicketItem item = ticketProducts
          .where((item) => item.productId == id)
          .first;
      setState(() {
        item.quantity = item.quantity + 1;
        item.subtotal = item.quantity * item.unitPrice;
      });
    }

    void deleteUnits(int id) {
      TicketItem item = ticketProducts
          .where((item) => item.productId == id)
          .first;
      if (item.quantity <= 0) return;
      setState(() {
        item.quantity = item.quantity - 1;
        item.subtotal = item.quantity * item.unitPrice;
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text('Nuevo ticket')),
      body: ListView(
        children: [
          FilledButton(onPressed: () {}, child: Text('Seleccionar cliente')),
          ...ticketProducts.map((product) {
            return Card(
              child: Row(
                children: [
                  Text('${product.subtotal}'),
                  SizedBox(width: 10),
                  Text('${product.name} - ${product.code}'),
                  Expanded(child: SizedBox(height: 40)),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => deleteUnits(product.productId),
                  ),
                  Text('${product.quantity}'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => addUnits(product.productId),
                  ),
                ],
              ),
            );
          }),
          FilledButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) =>
                    TicketProductSelectionModal(onSelected: onAdd),
              );
            },
            child: Text('Agregar producto'),
          ),
          FilledButton(onPressed: () {}, child: Text('Agregar descuento')),
          TextField(decoration: InputDecoration(label: Text('Notas'))),
          FilledButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check),
                const SizedBox(width: 20),
                const Text('Guardar'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
