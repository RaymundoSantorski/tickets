import 'package:isar/isar.dart';
import 'package:tickets/core/models/customer.dart';

class CustomerRepository {
  final Isar isar;
  CustomerRepository(this.isar);

  Future<void> save(Customer customer) async {
    await isar.writeTxn(() async {
      await isar.customers.put(customer);
    });
  }

  Future<bool> delete(Id id) async {
    bool answer = false;
    await isar.writeTxn(() async {
      answer = await isar.customers.delete(id);
    });
    return answer;
  }

  Future<List<Customer>> getAll() async {
    return await isar.customers.where().findAll();
  }

  Future<Customer?> get(Id id) async {
    return await isar.customers.get(id);
  }

  Future<List<Customer>> search(String query) async {
    List<Customer> result = await isar.customers
        .filter()
        .nameContains(query)
        .findAll();
    return result;
  }
}
