import 'package:flutter/material.dart';

class TicketForm extends StatefulWidget {
  const TicketForm({super.key});

  @override
  State<TicketForm> createState() => _TicketFormState();
}

class _TicketFormState extends State<TicketForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nuevo ticket')),
      body: ListView(
        children: [
          FilledButton(onPressed: () {}, child: Text('Seleccionar cliente')),
          FilledButton(onPressed: () {}, child: Text('Agregar producto')),
          FilledButton(onPressed: () {}, child: Text('Agregar descuento')),
          TextField(decoration: InputDecoration(label: Text('Notas'))),
          FilledButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check),
                const SizedBox(width: 20),
                const Text('Guardar'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
