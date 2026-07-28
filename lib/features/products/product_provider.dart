import 'package:flutter/material.dart';
import 'package:tickets/core/models/product.dart';
import 'package:tickets/features/products/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository db;
  ProductProvider(this.db) {
    load();
  }

  List<Product> products = [];

  Future<void> load() async {
    products = await db.getAll();
    notifyListeners();
  }

  Future<void> save(Product product) async {
    await db.save(product);
    await load();
  }

  Future<void> delete(int id) async {
    bool answer = await db.delete(id);
    if (answer) await load();
  }

  Future<Product?> get(int id) async {
    return await db.get(id);
  }
}
