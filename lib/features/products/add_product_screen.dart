import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets/core/models/product.dart';
import 'package:tickets/features/products/product_provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key, this.product});
  final Product? product;

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  ProductType type = ProductType.physical;
  bool showAddressForm = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController costController = TextEditingController();

  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController widthController = TextEditingController();
  TextEditingController lengthController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Product? product = widget.product;
    if (product != null) {
      nameController.text = product.name;
      codeController.text = product.code;
      priceController.text = '${product.price}';
      costController.text = '${product.cost}';
      if (product.weight != null) {
        weightController.text = '${product.weight}';
        heightController.text = '${product.height}';
        widthController.text = '${product.width}';
        lengthController.text = '${product.length}';
        showAddressForm = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider db = context.watch<ProductProvider>();
    void onSave() {
      Product newProduct = widget.product ?? Product();
      newProduct
        ..name = nameController.text
        ..code = codeController.text
        ..price = double.parse(priceController.text)
        ..cost = double.parse(costController.text)
        ..type = type;
      if (showAddressForm) {
        newProduct
          ..weight = double.parse(weightController.text)
          ..height = double.parse(heightController.text)
          ..width = double.parse(widthController.text)
          ..length = double.parse(lengthController.text);
      }
      db.save(newProduct);
      Navigator.pop(context);
    }

    void setType(ProductType? newType) {
      if (newType == null) return;
      setState(() {
        type = newType;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product != null ? 'Editar cliente' : 'Agregar cliente',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                label: Text('Nombre'),
                hint: Text('Playera de algodón'),
              ),
            ),
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                label: Text('Código'),
                hint: Text('000111'),
              ),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefix: Text('\$'),
                label: Text('Precio'),
                hint: Text('90'),
              ),
            ),
            TextField(
              controller: costController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefix: Text('\$'),
                label: Text('Costo'),
                hint: Text('60'),
              ),
            ),
            DropdownButton<ProductType>(
              value: type,
              items: [
                DropdownMenuItem(
                  value: ProductType.physical,
                  child: Text('Producto fisico'),
                ),
                DropdownMenuItem(
                  value: ProductType.digital,
                  child: Text('Producto digital'),
                ),
                DropdownMenuItem(
                  value: ProductType.service,
                  child: Text('Servicio'),
                ),
              ],
              onChanged: setType,
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  showAddressForm = !showAddressForm;
                });
              },
              label: Text(
                showAddressForm ? 'Ocultar medidas' : 'Agregar medidas',
              ),
            ),
            showAddressForm
                ? Column(
                    children: [
                      TextField(
                        controller: weightController,
                        decoration: InputDecoration(
                          suffix: Text('kg'),
                          label: Text('Peso'),
                          hint: Text('4.8'),
                        ),
                      ),
                      TextField(
                        controller: heightController,
                        decoration: InputDecoration(
                          suffix: Text('cm'),
                          label: Text('Alto'),
                          hint: Text('20'),
                        ),
                      ),
                      TextField(
                        controller: widthController,
                        decoration: InputDecoration(
                          suffix: Text('cm'),
                          label: Text('Largo'),
                          hint: Text('20'),
                        ),
                      ),
                      TextField(
                        controller: lengthController,
                        decoration: InputDecoration(
                          suffix: Text('cm'),
                          label: Text('Ancho'),
                          hint: Text('25'),
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
