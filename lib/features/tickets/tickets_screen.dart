import 'package:flutter/material.dart';
import 'package:tickets/features/tickets/ticket_form.dart';

class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
    );
  }
}
