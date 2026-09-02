import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';
import 'package:tickets/core/models/customer.dart';
import 'package:tickets/core/models/ticket.dart';
import 'package:tickets/features/clients/customer_provider.dart';
import 'package:tickets/features/tickets/payment_form.dart';
import 'package:tickets/features/tickets/ticket_card.dart';
import 'package:tickets/features/tickets/ticket_form.dart';
import 'package:tickets/features/tickets/ticket_provider.dart';

class CustomerDetailScreen extends StatefulWidget {
  const CustomerDetailScreen({super.key, required this.customerId});
  final int customerId;

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  List<Ticket> tickets = [];
  Customer? customer;

  @override
  void initState() {
    super.initState();
    TicketProvider ticketDb = context.read<TicketProvider>();
    CustomerProvider customerDb = context.read<CustomerProvider>();
    setCustomer(customerDb);
    customerDb.addListener(() {
      setCustomer(customerDb);
    });
    loadTickets(ticketDb);
    ticketDb.addListener(() {
      loadTickets(ticketDb);
    });
  }

  Future<void> setCustomer(CustomerProvider db) async {
    debugPrint('Customer id: ${widget.customerId}');
    Customer? freshCustomer = await db.get(widget.customerId);
    if (freshCustomer == null) {
      // throw Exception('No se encontró el cliente');
    }
    if (mounted) {
      setState(() {
        customer = freshCustomer;
      });
    }
  }

  Future<void> loadTickets(TicketProvider db) async {
    List<Ticket> customerTickets = await db.getTickets(widget.customerId);
    if (mounted) {
      setState(() {
        tickets = customerTickets;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        type: ExpandableFabType.fan,
        pos: ExpandableFabPos.right,
        fanAngle: 90,
        children: [
          FloatingActionButton.small(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PaymentForm(initCustomer: customer),
                ),
              );
            },
            heroTag: null,
            child: const Icon(Icons.payment),
          ),
          FloatingActionButton.small(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => TicketForm(initCustomer: customer),
                ),
              );
            },
            heroTag: null,
            child: const Icon(Icons.sell),
          ),
          FloatingActionButton.small(
            onPressed: () {},
            heroTag: null,
            child: const Icon(Icons.local_shipping),
          ),
        ],
      ),
      appBar: AppBar(
        title: Column(
          children: [
            Text(customer?.name ?? ''),
            Text(
              '\$ ${customer?.balance ?? ''}',
              style: TextStyle(
                color: (customer?.balance ?? 0) <= 0
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => TicketForm(initCustomer: customer),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('${customer?.pendingItems ?? ''}'),
                    Text('Cant. prendas'),
                  ],
                ),
                Column(
                  children: [
                    Text('${customer?.pendingWeight.ceil()} kg'),
                    Text('Peso total'),
                  ],
                ),
                Column(
                  children: [
                    Text('${customer?.pendingVolumetricWeight.ceil()} kg.'),
                    Text('P.V. Total'),
                  ],
                ),
              ],
            ),
          ),
          tickets.isNotEmpty
              ? Expanded(
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          Text('Historial', textAlign: TextAlign.center),
                          ...tickets.map((ticket) {
                            return ticketCard(ticket, context);
                          }),
                        ],
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No hay tickets'),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    TicketForm(initCustomer: customer),
                              ),
                            );
                          },
                          child: Text('Agregar ticket'),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
