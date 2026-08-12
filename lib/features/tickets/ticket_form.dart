import 'package:flutter/material.dart';
import 'package:tickets/core/models/customer.dart';
import 'package:tickets/features/tickets/ticket_customer_selection_modal.dart';
import 'package:tickets/core/models/ticket_item.dart';
import 'package:tickets/features/tickets/ticket_product_selection_modal.dart';

class TicketForm extends StatefulWidget {
  const TicketForm({super.key});

  @override
  State<TicketForm> createState() => _TicketFormState();
}

class _TicketFormState extends State<TicketForm> {
  final List<TicketItem> ticketProducts = [];
  double subtotal = 0;
  double discount = 0;
  double total = 0;
  final TextEditingController discountController = TextEditingController(
    text: '',
  );
  final TextEditingController notesController = TextEditingController(text: '');
  Customer? customer;

  @override
  Widget build(BuildContext context) {
    void onSave() {}

    void setTotal() {
      setState(() {
        total = subtotal - discount;
      });
    }

    void setDiscount(String value) {
      setState(() {
        discount = double.tryParse(value) ?? 0;
      });
      setTotal();
    }

    void calculateSubtotal() {
      double sub = ticketProducts.fold(
        0.0,
        (lastValue, item) => lastValue + item.subtotal,
      );
      setState(() {
        subtotal = sub;
      });
      setTotal();
    }

    void onAdd(TicketItem product) {
      if (ticketProducts
          .where((item) => item.productId == product.productId)
          .isNotEmpty) {
        return;
      }

      setState(() {
        ticketProducts.add(product);
      });
      calculateSubtotal();
    }

    void addUnits(int id) {
      TicketItem item = ticketProducts
          .where((item) => item.productId == id)
          .first;
      setState(() {
        item.quantity = item.quantity + 1;
        item.subtotal = item.quantity * item.unitPrice;
      });
      calculateSubtotal();
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
      calculateSubtotal();
    }

    void onClientSelected(Customer value) {
      setState(() {
        customer = value;
      });
    }

    void showModal(Widget widget) {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => widget,
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Nuevo ticket')),
      body: ListView(
        children: [
          customer != null
              ? Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(customer!.name),
                      SizedBox(height: 30),
                      TextButton(
                        onPressed: () => showModal(
                          TicketCustomerSelectionModal(
                            onSelected: onClientSelected,
                          ),
                        ),
                        child: Text('Cambiar'),
                      ),
                    ],
                  ),
                )
              : FilledButton(
                  onPressed: () => showModal(
                    TicketCustomerSelectionModal(onSelected: onClientSelected),
                  ),

                  child: Text('Seleccionar cliente'),
                ),
          Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal: '),
                SizedBox(height: 30),
                Text('\$ $subtotal'),
              ],
            ),
          ),
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
            onPressed: () =>
                showModal(TicketProductSelectionModal(onSelected: onAdd)),
            child: Text('Agregar producto'),
          ),
          TextField(
            decoration: InputDecoration(
              label: Text('Descuento'),
              hint: Text('30'),
              prefix: Text('\$'),
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: discountController,
            onChanged: setDiscount,
          ),
          TextField(
            decoration: InputDecoration(
              label: Text('Notas'),
              hint: Text('Pagado'),
            ),
            controller: notesController,
          ),
          Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Total:'), SizedBox(height: 30), Text('$total')],
            ),
          ),
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
