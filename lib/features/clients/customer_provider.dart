import 'package:flutter/material.dart';
import 'package:tickets/core/models/customer.dart';
import 'package:tickets/features/clients/customer_repository.dart';

class CustomerProvider extends ChangeNotifier {
  final CustomerRepository repository;
  CustomerProvider(this.repository) {
    load();
  }

  List<Customer> customers = [];

  Future<void> search(String query) async {
    if (query.isNotEmpty) {
      customers = await repository.search(query);
      notifyListeners();
    } else {
      await load();
    }
  }

  Future<Customer?> get(int id) async {
    return await repository.get(id);
  }

  Future<void> load() async {
    customers = await repository.getAll();
    notifyListeners();
  }

  Future<void> save(Customer customer) async {
    await repository.save(customer);
    await load();
  }

  Future<void> delete(int id) async {
    await repository.delete(id);
    await load();
  }
}
