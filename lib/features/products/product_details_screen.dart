import 'package:flutter/material.dart';
import 'package:tickets/core/models/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.product});
  final Product product;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.edit))],
      ),
      body: ListView(
        children: [
          Text('Código: ${product.code}'),
          Text('Precio: ${product.price}'),
          Text('Costo: ${product.cost}'),
          Text('Ganancia: ${product.price - product.cost}'),
          Text('Tipo: ${product.type.name}'),
          Text('Peso: ${product.weight ?? ''}'),
          Text('Alto: ${product.height ?? ''}'),
          Text('Ancho: ${product.width ?? ''}'),
          Text('Largo: ${product.length ?? ''}'),
        ],
      ),
    );
  }
}
