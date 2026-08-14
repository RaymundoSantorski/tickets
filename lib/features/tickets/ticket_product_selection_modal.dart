import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets/core/models/product.dart';
import 'package:tickets/features/products/product_provider.dart';
import 'package:tickets/core/models/ticket_item.dart';

class TicketProductSelectionModal extends StatelessWidget {
  const TicketProductSelectionModal({super.key, required this.onSelected});
  final void Function(TicketItem) onSelected;

  @override
  Widget build(BuildContext context) {
    List<Product> products = context.watch<ProductProvider>().products;
    debugPrint('${products.length}');
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shopping_bag, color: Colors.blueAccent),
              const SizedBox(width: 10),
              Text(
                'Agregar productos',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: products.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final product = products[index];
                debugPrint(product.name);
                debugPrint('${products.length}');
                return ListTile(
                  title: Text(
                    product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.blueAccent,
                    ),
                  ),
                  subtitle: Text(
                    product.code,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  onTap: () {
                    TicketItem item = TicketItem()
                      ..code = product.code
                      ..name = product.name
                      ..productId = product.id
                      ..quantity = 1
                      ..subtotal = product.price
                      ..unitCost = product.cost
                      ..unitPrice = product.price
                      ..unitWeight = product.weight
                      ..unitVolumetricWeight =
                          (product.length ?? 0) *
                          (product.height ?? 0) *
                          (product.width ?? 0) /
                          5000;
                    onSelected(item);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
