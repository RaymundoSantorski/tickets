import 'package:flutter/material.dart';
import 'package:tickets/core/models/ticket.dart';

class ShipmentDetailScreen extends StatelessWidget {
  const ShipmentDetailScreen({super.key, required this.ticket});
  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Envio - ${ticket.displayName}')),
    );
  }
}
