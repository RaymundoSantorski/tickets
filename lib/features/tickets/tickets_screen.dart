import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets/core/models/ticket.dart';
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
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => TicketDetailsScreen(ticket: ticket),
                ),
              );
            },
            child: Card(
              color: ticket.status == TicketStatus.pending
                  ? Colors.redAccent
                  : ticket.status == TicketStatus.partial
                  ? Colors.amberAccent
                  : Colors.greenAccent,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(ticket.displayName),
                        SizedBox(height: 40),
                        Text('${ticket.balanceAfter}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${ticket.date.weekday} - ${ticket.date.day} - ${ticket.date.month} - ${ticket.date.year}',
                        ),
                        SizedBox(height: 40),
                        Text(ticket.status.name),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: tickets.length,
      ),
    );
  }
}
