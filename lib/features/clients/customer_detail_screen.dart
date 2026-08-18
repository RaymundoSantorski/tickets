import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets/core/models/customer.dart';
import 'package:tickets/core/models/ticket.dart';
import 'package:tickets/features/tickets/ticket_card.dart';
import 'package:tickets/features/tickets/ticket_form.dart';
import 'package:tickets/features/tickets/ticket_provider.dart';

class CustomerDetailScreen extends StatefulWidget {
  const CustomerDetailScreen({super.key, required this.customer});
  final Customer customer;

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  List<Ticket> tickets = [];

  @override
  void initState() {
    super.initState();
    TicketProvider db = context.read<TicketProvider>();
    loadTickets(db);
    db.addListener(() {
      loadTickets(db);
    });
  }

  Future<void> loadTickets(TicketProvider db) async {
    List<Ticket> customerTickets = await db.getTickets(widget.customer.id);
    if (mounted) {
      setState(() {
        tickets = customerTickets;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.customer.name),
            Text(
              '\$ ${widget.customer.balance}',
              style: TextStyle(
                color: widget.customer.balance <= 0 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => TicketForm(initCustomer: widget.customer),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView(
        children: [
          Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('${widget.customer.pendingItems}'),
                    Text('Cant. prendas'),
                  ],
                ),
                Column(
                  children: [
                    Text('${widget.customer.pendingWeight.ceil()} kg'),
                    Text('Peso total'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${widget.customer.pendingVolumetricWeight.ceil()} kg.',
                    ),
                    Text('P.V. Total'),
                  ],
                ),
              ],
            ),
          ),
          Text('Historial', textAlign: TextAlign.center),
          ...tickets.map((ticket) {
            return ticketCard(ticket, context);
          }),
        ],
      ),
    );
  }
}
