import 'package:flutter/material.dart';
import 'package:tickets/core/models/ticket.dart';
import 'package:tickets/features/tickets/ticket_details_screen.dart';

Widget ticketCard(Ticket ticket, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => TicketDetailsScreen(ticket: ticket)),
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
}
