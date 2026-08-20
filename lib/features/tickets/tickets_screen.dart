import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets/core/models/ticket.dart';
import 'package:tickets/features/tickets/ticket_card.dart';
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
      body: tickets.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) {
                Ticket ticket = tickets[index];
                return ticketCard(ticket, context);
              },
              itemCount: tickets.length,
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No hay tickets'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (_) => TicketForm()));
                    },
                    child: Text('Agregar ticket'),
                  ),
                ],
              ),
            ),
    );
  }
}
