import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:tickets/core/models/ticket.dart';
import 'package:tickets/features/tickets/ticket_details_screen.dart';
import 'package:tickets/features/tickets/ticket_form.dart';
import 'package:tickets/features/tickets/ticket_provider.dart';

Future<void> confirmDelete(
  BuildContext context,
  TicketProvider db,
  Ticket ticket,
) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            SizedBox(width: 10),
            Text('¿Eliminar ticket?'),
          ],
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                '¿Estás seguro de que deseas eliminar el ticket "${ticket.id}"?',
              ),
              const SizedBox(height: 10),
              Text(
                'Esta acción no se puede deshacer y perderás los datos relacionados',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
            onPressed: () async {
              Navigator.of(context).pop();

              await db.delete(ticket.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    persist: false,
                    duration: Duration(seconds: 3),
                    content: Text(
                      'El ticket "${ticket.id}" ha sido eliminado.',
                    ),
                    action: SnackBarAction(
                      label: 'Deshacer',
                      textColor: Colors.white,
                      onPressed: () {
                        db.save(ticket);
                      },
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
          ),
        ],
      );
    },
  );
}

Widget ticketCard(Ticket ticket, BuildContext context) {
  TicketProvider ticketDb = context.read<TicketProvider>();
  return Slidable(
    endActionPane: ActionPane(
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (context) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => TicketForm(ticket: ticket)),
            );
          },
          backgroundColor: Colors.blue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            bottomLeft: Radius.circular(16.0),
          ),
          icon: Icons.edit,
          label: 'Editar',
        ),
        SlidableAction(
          onPressed: (context) {
            confirmDelete(context, ticketDb, ticket);
          },
          backgroundColor: Colors.red,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16.0),
            bottomRight: Radius.circular(16.0),
          ),
          icon: Icons.delete,
          label: 'Eliminar',
        ),
      ],
    ),
    child: InkWell(
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
    ),
  );
}
