import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets/core/models/customer.dart';
import 'package:tickets/core/models/ticket.dart';
import 'package:tickets/features/clients/customer_provider.dart';
import 'package:tickets/features/tickets/ticket_customer_selection_modal.dart';
import 'package:tickets/core/models/ticket_item.dart';
import 'package:tickets/features/tickets/ticket_product_selection_modal.dart';
import 'package:tickets/features/tickets/ticket_provider.dart';

class TicketForm extends StatefulWidget {
  const TicketForm({super.key, this.initCustomer, this.ticket});
  final Customer? initCustomer;
  final Ticket? ticket;

  @override
  State<TicketForm> createState() => _TicketFormState();
}

class _TicketFormState extends State<TicketForm> {
  String title = 'Nuevo ticket';
  final List<TicketItem> ticketProducts = [];
  double subtotal = 0;
  double discount = 0;
  double total = 0;
  final TextEditingController discountController = TextEditingController(
    text: '',
  );
  final TextEditingController notesController = TextEditingController(text: '');
  Customer? customer;
  double? lastTicketTotal;
  double? lastTicketWeight;
  double? lastTicketVolWeight;
  int? ticketPendingItems;

  double calculateWeight(List<TicketItem> items) {
    return items.fold(
      0.0,
      (last, item) => (item.unitWeight ?? 0) * item.quantity + last,
    );
  }

  double calculateVolWeight(List<TicketItem> items) {
    return items.fold(
      0.0,
      (last, item) => (item.unitVolumetricWeight ?? 0) * item.quantity + last,
    );
  }

  int calculatePendingItems(List<TicketItem> items) {
    return items.fold(0, (last, item) => item.quantity + last);
  }

  @override
  void initState() {
    super.initState();
    CustomerProvider customerDb = context.read<CustomerProvider>();
    if (widget.initCustomer != null) {
      setState(() {
        customer = widget.initCustomer;
      });
    }
    if (widget.ticket != null) {
      setState(() {
        ticketProducts.addAll(widget.ticket!.items);
        subtotal = widget.ticket!.subtotal;
        discount = widget.ticket!.discount;
        total = widget.ticket!.total;
        discountController.text = '$discount';
        notesController.text = widget.ticket!.notes ?? '';
        title = 'Ticket - ${widget.ticket!.id}';
        lastTicketTotal = widget.ticket!.total;
        lastTicketWeight = calculateWeight(widget.ticket!.items);
        lastTicketVolWeight = calculateVolWeight(widget.ticket!.items);
        ticketPendingItems = calculatePendingItems(widget.ticket!.items);
      });
      setCustomer(widget.ticket!.customerId, customerDb);
    }
  }

  Future<void> setCustomer(int id, CustomerProvider db) async {
    Customer? freshCustomer = await db.get(id);
    if (freshCustomer == null) {
      throw Exception('Must provide a valid customer');
    } else {
      setState(() {
        customer = freshCustomer;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomerProvider customerDb = context.read<CustomerProvider>();
    TicketProvider ticketDb = context.read<TicketProvider>();

    void onSave() {
      if (customer == null) return;
      Ticket newTicket;
      if (widget.ticket != null) {
        debugPrint(
          'Old ticket items: ${calculatePendingItems(widget.ticket!.items)}',
        );
        debugPrint('Customer pending items: ${customer!.pendingItems}');
        debugPrint(
          'New ticket items: ${calculatePendingItems(ticketProducts)}',
        );
        debugPrint(
          'newPendingItems: ${customer!.pendingItems - ticketPendingItems! + calculatePendingItems(ticketProducts)}',
        );
        newTicket = widget.ticket!
          ..balanceAfter =
              widget.ticket!.balanceAfter - lastTicketTotal! + total
          ..discount = discount
          ..items = ticketProducts
          ..notes = notesController.text
          ..subtotal = subtotal
          ..total = total;
        customer!.balance = customer!.balance - lastTicketTotal! + total;
        customer!.pendingItems =
            customer!.pendingItems -
            ticketPendingItems! +
            calculatePendingItems(ticketProducts);
        customer!.pendingWeight =
            customer!.pendingWeight -
            lastTicketWeight! +
            calculateWeight(ticketProducts);
        customer!.pendingVolumetricWeight =
            customer!.pendingVolumetricWeight -
            lastTicketVolWeight! +
            calculateVolWeight(ticketProducts);
      } else {
        double before = customer!.balance;
        newTicket = Ticket()
          ..balanceAfter = before + total
          ..balanceBefore = before
          ..customerId = customer!.id
          ..date = DateTime.now()
          ..discount = discount
          ..displayName = customer!.name
          ..dueDate = DateTime.now().add(Duration(days: 2))
          ..fullName = customer!.fullName
          ..items = ticketProducts
          ..notes = notesController.text
          ..phoneNumber = customer!.phoneNumber
          ..status = TicketStatus.pending
          ..subtotal = subtotal
          ..total = total
          ..type = TicketType.sale;
        customer!.balance = before + total;
        customer!.pendingItems =
            customer!.pendingItems + calculatePendingItems(ticketProducts);
        customer!.pendingWeight =
            customer!.pendingWeight + calculateWeight(ticketProducts);
        customer!.pendingVolumetricWeight =
            customer!.pendingVolumetricWeight +
            calculateVolWeight(ticketProducts);
      }
      customerDb.save(customer!);
      ticketDb.save(newTicket);
      Navigator.of(context).pop();
    }

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
      appBar: AppBar(title: Text(title)),
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
            onPressed: onSave,
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
