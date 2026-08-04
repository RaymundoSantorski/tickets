import 'package:isar/isar.dart';
import 'package:tickets/core/models/product.dart';

class ProductRepository {
  final Isar isar;
  ProductRepository(this.isar);

  Future<void> save(Product product) async {
    await isar.writeTxn(() async {
      await isar.products.put(product);
    });
  }

  Future<bool> delete(Id id) async {
    bool answer = false;
    await isar.writeTxn(() async {
      answer = await isar.products.delete(id);
    });
    return answer;
  }

  Future<Product?> get(Id id) async {
    return await isar.products.get(id);
  }

  Future<List<Product>> getAll() async {
    return await isar.products.where().findAll();
  }

  Future<List<Product>> search(String query) async {
    List<Product> codeProducts = await isar.products
        .filter()
        .codeContains(query)
        .findAll();
    List<Product> nameProducts = await isar.products
        .filter()
        .nameContains(query)
        .findAll();
    return [...codeProducts, ...nameProducts];
  }
}
