import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets/core/models/customer.dart';
import 'package:tickets/core/models/ticket.dart';
import 'package:tickets/features/clients/customer_provider.dart';
import 'package:tickets/features/tickets/payment_customer_selection_modal.dart';
import 'package:tickets/features/tickets/ticket_customer_selection_modal.dart';
import 'package:tickets/features/tickets/ticket_details_screen.dart';
import 'package:tickets/features/tickets/ticket_provider.dart';

class PaymentForm extends StatefulWidget {
  const PaymentForm({super.key, this.initCustomer, this.ticket});
  final Customer? initCustomer;
  final Ticket? ticket;

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  String title = 'Nuevo pago';
  double total = 0;
  final TextEditingController notesController = TextEditingController(text: '');
  final TextEditingController totalController = TextEditingController(text: '');
  Customer? customer;
  double? lastTicketTotal;
  int? ticketPendingItems;
  PaymentMethod? paymentMethod;

  @override
  void initState() {
    super.initState();
    CustomerProvider customerDb = context.read<CustomerProvider>();
    if (widget.initCustomer != null) {
      setCustomer(widget.initCustomer!.id, customerDb);
    }
    if (widget.ticket != null) {
      setState(() {
        total = -widget.ticket!.total;
        notesController.text = widget.ticket!.notes ?? '';
        title = 'Pago - ${widget.ticket!.id}';
        lastTicketTotal = widget.ticket!.total;
        paymentMethod = widget.ticket!.paymentMethod;
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

    void onSave() async {
      if (customer == null) return;
      Ticket newTicket;
      if (widget.ticket != null) {
        newTicket = widget.ticket!
          ..balanceAfter =
              widget.ticket!.balanceAfter - lastTicketTotal! - total
          ..notes = notesController.text
          ..total = -total;
      } else {
        double before = customer!.balance;
        newTicket = Ticket()
          ..balanceAfter = before - total
          ..balanceBefore = before
          ..customerId = customer!.id
          ..date = DateTime.now()
          ..discount = 0
          ..status = TicketStatus.paid
          ..subtotal = -total
          ..displayName = customer!.name
          ..fullName = customer!.fullName
          ..notes = notesController.text
          ..phoneNumber = customer!.phoneNumber
          ..total = -total
          ..type = TicketType.payment;
        customer!.balance = before - total;
      }
      List<Ticket> pendingTickets = await ticketDb.getPending(customer!.id);
      double rest = total;
      for (Ticket ticket in pendingTickets) {
        if (ticket.status == TicketStatus.pending) {
          if (ticket.total <= rest) {
            ticket.paidAmount = ticket.total;
            ticket.status = TicketStatus.paid;
            rest = rest - ticket.total;
          } else {
            ticket.status = TicketStatus.partial;
            ticket.paidAmount = rest;
            rest = 0;
          }
        } else if (ticket.status == TicketStatus.partial) {
          double pendingAmount = ticket.total - ticket.paidAmount;
          if (pendingAmount <= rest) {
            ticket.paidAmount = ticket.total;
            ticket.status = TicketStatus.paid;
            rest = rest - pendingAmount;
          } else {
            ticket.paidAmount = ticket.paidAmount + rest;
            ticket.status = TicketStatus.partial;
            rest = 0;
          }
        }
        ticketDb.save(ticket);
        if (rest <= 0) break;
      }
      customerDb.save(customer!);
      await ticketDb.save(newTicket);
      // Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => TicketDetailsScreen(ticket: newTicket),
        ),
      );
    }

    void setTotal(String value) {
      setState(() {
        total = double.tryParse(value) ?? 0;
      });
    }

    void onPaymentSelected(PaymentMethod payment) {
      if (payment == PaymentMethod.none) {
        setState(() {
          paymentMethod = null;
        });
      } else {
        setState(() {
          paymentMethod = payment;
        });
      }
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
                Text('Balance anterior: '),
                SizedBox(height: 30),
                Text('\$ ${customer?.balance}'),
              ],
            ),
          ),
          TextField(
            decoration: InputDecoration(
              prefix: Text('\$'),
              label: Text('Importe'),
              hint: Text('500'),
            ),
            controller: totalController,
            onChanged: setTotal,
          ),
          TextField(
            decoration: InputDecoration(
              label: Text('Notas'),
              hint: Text('Pagado'),
            ),
            controller: notesController,
          ),
          paymentMethod == null
              ? FilledButton(
                  onPressed: () => showModal(
                    PaymentCustomerSelectionModal(
                      onSelected: onPaymentSelected,
                    ),
                  ),

                  child: Text('Seleccionar metodo de pago'),
                )
              : Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(paymentMethod!.name),
                      SizedBox(height: 30),
                      TextButton(
                        onPressed: () => showModal(
                          PaymentCustomerSelectionModal(
                            onSelected: onPaymentSelected,
                          ),
                        ),
                        child: Text('Cambiar'),
                      ),
                    ],
                  ),
                ),
          Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nuevo balance:'),
                SizedBox(height: 30),
                Text('${(customer?.balance ?? 0) - total}'),
              ],
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
