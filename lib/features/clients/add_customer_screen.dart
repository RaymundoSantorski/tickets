import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets/core/models/customer.dart';
import 'package:tickets/features/clients/customer_provider.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  bool showAddressForm = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  TextEditingController streetController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController neighborhoodController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CustomerProvider db = context.watch<CustomerProvider>();
    void onSave() {
      Address? address;
      if (showAddressForm) {
        address = Address()
          ..street = streetController.text
          ..number = numberController.text
          ..neighborhood = neighborhoodController.text
          ..zipCode = zipCodeController.text
          ..city = cityController.text
          ..state = stateController.text;
      }
      Customer newCustomer = Customer()
        ..name = nameController.text
        ..fullName = fullNameController.text
        ..phoneNumber = phoneController.text
        ..address = address;

      db.save(newCustomer);
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(title: Text('Add Customer')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                label: Text('Nombre de pila'),
                hint: Text('Ray'),
              ),
            ),
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(
                label: Text('Nombre completo'),
                hint: Text('Raymundo Mateos'),
              ),
            ),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                label: Text('Número de télefono'),
                hint: Text('55 3741 5169'),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  showAddressForm = !showAddressForm;
                });
              },
              label: Text(
                showAddressForm ? 'Ocultar dirección' : 'Agregar dirección',
              ),
            ),
            showAddressForm
                ? Column(
                    children: [
                      TextField(
                        controller: streetController,
                        decoration: InputDecoration(
                          label: Text('Calle'),
                          hint: Text('Rio Cupatitzio'),
                        ),
                      ),
                      TextField(
                        controller: numberController,
                        decoration: InputDecoration(
                          label: Text('Número'),
                          hint: Text('2'),
                        ),
                      ),
                      TextField(
                        controller: neighborhoodController,
                        decoration: InputDecoration(
                          label: Text('Colonia'),
                          hint: Text('Puente Blanco'),
                        ),
                      ),
                      TextField(
                        controller: zipCodeController,
                        decoration: InputDecoration(
                          label: Text('Código Postal'),
                          hint: Text('09770'),
                        ),
                      ),
                      TextField(
                        controller: cityController,
                        decoration: InputDecoration(
                          label: Text('Alcaldía o Municipio'),
                          hint: Text('Iztapalapa'),
                        ),
                      ),
                      TextField(
                        controller: stateController,
                        decoration: InputDecoration(
                          label: Text('Estado'),
                          hint: Text('Ciudad de México'),
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
            FilledButton(onPressed: onSave, child: Text('Guardar')),
          ],
        ),
      ),
    );
  }
}
