import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets/core/models/product.dart';
import 'package:tickets/features/products/add_product_screen.dart';
import 'package:tickets/features/products/product_details_screen.dart';
import 'package:tickets/features/products/product_provider.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Product> products = context.watch<ProductProvider>().products;
    bool? active = context.watch<ProductProvider>().active;
    ProductProvider db = context.read<ProductProvider>();

    void onPressed({Product? product}) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AddProductScreen(product: product)),
      );
    }

    void search(String value) {
      db.search(value);
    }

    Future<void> confirmDelete(
      BuildContext context,
      ProductProvider db,
      Product product,
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
                Text('¿Eliminar producto?'),
              ],
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    '¿Estás seguro de que deseas eliminar "${product.name}"?',
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Esta acción no se puede deshacer y perderás los datos relacionados con el producto',
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
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.grey),
                ),
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

                  await db.delete(product.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        persist: false,
                        duration: Duration(seconds: 3),
                        content: Text('"${product.name}" ha sido eliminado.'),
                        action: SnackBarAction(
                          label: 'Deshacer',
                          textColor: Colors.white,
                          onPressed: () {
                            db.save(product);
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

    void filter(bool? value) {
      db.filterByActive(value);
    }

    return Scaffold(
      appBar: AppBar(title: Text('Clientes')),
      floatingActionButton: FloatingActionButton(
        onPressed: onPressed,
        child: Icon(Icons.add),
      ),
      body: products.isNotEmpty
          ? Column(
              children: [
                Card(
                  child: Row(
                    children: [
                      ChoiceChip(
                        label: Text('Todo'),
                        selected: active == null,
                        onSelected: (_) => filter(null),
                      ),
                      ChoiceChip(
                        label: Text('Activo'),
                        selected: active == true,
                        onSelected: (_) => filter(true),
                      ),
                      ChoiceChip(
                        label: Text('Inactivo'),
                        selected: active == false,
                        onSelected: (_) => filter(false),
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) => search(value),
                        ),
                      ),
                      IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      Product product = products[index];
                      return Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ProductDetailsScreen(product: product),
                                  ),
                                );
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.person, size: 30.0),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(product.name),
                                            Text(product.code),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                confirmDelete(context, db, product),
                            icon: Icon(Icons.delete),
                          ),
                          IconButton(
                            onPressed: () => onPressed(product: product),
                            icon: Icon(Icons.edit),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No hay productos'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => AddProductScreen()),
                      );
                    },
                    child: Text('Agregar producto'),
                  ),
                ],
              ),
            ),
    );
  }
}
