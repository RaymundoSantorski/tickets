import 'package:flutter/material.dart';
import 'package:tickets/core/models/ticket.dart';

class ShipmentDetailScreen extends StatelessWidget {
  const ShipmentDetailScreen({super.key, required this.ticket});
  final Ticket ticket;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Envio - ${ticket.displayName}')),
      body: ListView(
        children: [
          Card(
            child: Row(
              children: [
                Text('Estado:'),
                Text(buildStateLabel(ticket.shipmentStatus)),
              ],
            ),
          ),
          Card(
            child: Row(
              children: [
                Text('Fecha de solicitud:'),
                Text(ticket.dueDate.toString()),
              ],
            ),
          ),
          Card(child: Row(children: [Text('Peso:'), Text('${ticket.weight}')])),
          Card(
            child: Row(
              children: [Text('Volumen:'), Text('${ticket.volWeight}')],
            ),
          ),
          Card(
            child: Row(
              children: [Text('Cantidad:'), Text('${ticket.shipQuantity}')],
            ),
          ),
        ],
      ),
    );
  }
}
