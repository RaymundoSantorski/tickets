import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets/core/models/ticket.dart';
import 'package:tickets/features/tickets/ticket_provider.dart';

class ShipmentDetailScreen extends StatefulWidget {
  const ShipmentDetailScreen({super.key, required this.ticket});
  final Ticket ticket;

  @override
  State<ShipmentDetailScreen> createState() => _ShipmentDetailScreenState();
}

class _ShipmentDetailScreenState extends State<ShipmentDetailScreen> {
  Ticket? ticket;
  String buildStateLabel(ShipmentStatus status) {
    switch (status) {
      case ShipmentStatus.preparing:
        return 'Preparando';
      case ShipmentStatus.cancelled:
        return 'Cancelado';
      case ShipmentStatus.shipped:
        return 'Enviado';
      case ShipmentStatus.arrived:
        return 'Entregado';
      default:
        return 'Solicitado';
    }
  }

  @override
  void initState() {
    super.initState();
    TicketProvider db = context.read<TicketProvider>();
    loadTicket(db, widget.ticket.id);
    db.addListener(() {
      loadTicket(db, widget.ticket.id);
    });
  }

  Future<void> loadTicket(TicketProvider db, int ticketID) async {
    Ticket? result = await db.get(ticketID);
    if (mounted) {
      setState(() {
        ticket = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> cancelRequest() async {
      if (widget.ticket.type != TicketType.shipment) return;
      widget.ticket.shipmentStatus = ShipmentStatus.cancelled;
      TicketProvider db = context.read<TicketProvider>();
      await db.save(widget.ticket);
    }

    return Scaffold(
      appBar: AppBar(title: Text('Envio - ${ticket?.displayName}')),
      body: ListView(
        children: [
          Card(
            child: Row(
              children: [
                Text('Estado:'),
                Text(
                  buildStateLabel(
                    ticket?.shipmentStatus ?? ShipmentStatus.none,
                  ),
                ),
              ],
            ),
          ),
          Card(
            child: Row(
              children: [
                Text('Fecha de solicitud:'),
                Text(ticket?.dueDate?.toString() ?? ''),
              ],
            ),
          ),
          Card(
            child: Row(children: [Text('Peso:'), Text('${ticket?.weight}')]),
          ),
          Card(
            child: Row(
              children: [Text('Volumen:'), Text('${ticket?.volWeight}')],
            ),
          ),
          Card(
            child: Row(
              children: [Text('Cantidad:'), Text('${ticket?.shipQuantity}')],
            ),
          ),
          FilledButton(onPressed: cancelRequest, child: Text('Cancelar')),
          FilledButton(onPressed: () {}, child: Text('Continuar')),
        ],
      ),
    );
  }
}
