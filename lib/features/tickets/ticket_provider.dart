import 'package:flutter/material.dart';
import 'package:tickets/core/models/ticket.dart';
import 'package:tickets/features/tickets/ticket_repository.dart';

class TicketProvider extends ChangeNotifier {
  final TicketRepository db;
  TicketProvider(this.db) {
    load();
  }

  List<Ticket> tickets = [];
  // bool? active;

  Future<void> load() async {
    tickets = await db.getAll();
    notifyListeners();
  }

  Future<void> save(Ticket ticket) async {
    await db.save(ticket);
    await load();
  }

  Future<void> delete(int id) async {
    bool answer = await db.delete(id);
    if (answer) await load();
  }

  Future<Ticket?> get(int id) async {
    return await db.get(id);
  }

  // Future<void> search(String query) async {
  //   if (query.isNotEmpty) {
  //     tickets = await db.search(query);
  //     notifyListeners();
  //   } else {
  //     load();
  //   }
  // }

  // Future<void> filterByActive(bool? value) async {
  //   active = value;
  //   await load();
  //   if (active != null) {
  //     products = products.where((product) => product.active == value).toList();
  //     // notifyListeners();
  //   }
  // }
}
