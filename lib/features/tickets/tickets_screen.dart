import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets/core/models/ticket.dart';
import 'package:tickets/features/tickets/ticket_card.dart';
import 'package:tickets/features/tickets/ticket_details_screen.dart';
import 'package:tickets/features/tickets/ticket_form.dart';
import 'package:tickets/features/tickets/ticket_provider.dart';

class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Ticket> tickets = context.watch<TicketProvider>().tickets;
    return Scaffold(
      appBar: AppBar(title: Text('Tickets'), actions: []),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TicketForm()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          Ticket ticket = tickets[index];
          return ticketCard(ticket, context);
        },
        itemCount: tickets.length,
      ),
    );
  }
}
