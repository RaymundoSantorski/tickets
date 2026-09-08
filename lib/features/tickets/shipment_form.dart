import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets/core/models/customer.dart';
import 'package:tickets/features/clients/add_customer_screen.dart';
import 'package:tickets/features/clients/customer_provider.dart';

class ShipmentForm extends StatefulWidget {
  const ShipmentForm({super.key, required this.customer});
  final Customer customer;

  @override
  State<ShipmentForm> createState() => _ShipmentFormState();
}

class _ShipmentFormState extends State<ShipmentForm> {
  Customer? customer;

  Future<void> setCustomer(BuildContext context) async {
    CustomerProvider db = context.read<CustomerProvider>();
    Customer? result = await db.get(widget.customer.id);
    if (mounted) {
      setState(() {
        customer = result;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    CustomerProvider db = context.read<CustomerProvider>();
    setCustomer(context);
    db.addListener(() {
      if (mounted) {
        setCustomer(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomerProvider db = context.watch<CustomerProvider>();
    return customer == null
        ? Scaffold()
        : Scaffold(
            appBar: AppBar(title: Text('${customer!.name} - Envio')),
            body: ListView(
              children: [
                Card(child: Text('Prendas - ${customer!.pendingItems}')),
                Card(child: Text('Peso - ${customer!.pendingWeight} kg')),
                Card(
                  child: Text(
                    'Volumen: ${customer!.pendingVolumetricWeight} kg',
                  ),
                ),
                Card(child: Text('Balance - ${customer!.balance}')),
                customer!.address == null
                    ? Column(
                        children: [
                          Text('No se ha agregado dirección al cliente'),
                          FilledButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AddCustomerScreen(customer: customer),
                                ),
                              );
                            },
                            child: Text('Editar cliente'),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            child: Text(
                              'Calle - ${customer!.address?.street ?? ''}',
                            ),
                          ),
                          Card(
                            child: Text(
                              'Numero - ${customer!.address?.number ?? ''}',
                            ),
                          ),
                          Card(
                            child: Text(
                              'Colonia - ${customer!.address?.neighborhood ?? ''}',
                            ),
                          ),
                          Card(
                            child: Text(
                              'Codigo postal - ${customer!.address?.zipCode ?? ''}',
                            ),
                          ),
                          Card(
                            child: Text(
                              'Alcaldia o municipio - ${customer!.address?.city ?? ''}',
                            ),
                          ),
                          Card(
                            child: Text(
                              'Estado - ${customer!.address?.state ?? ''}',
                            ),
                          ),
                          Center(
                            child: FilledButton(
                              onPressed: () {},
                              child: Text('Continuar'),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          );
  }
}
