import 'package:isar/isar.dart';
import 'package:tickets/core/models/ticket.dart';

class TicketRepository {
  final Isar isar;
  TicketRepository(this.isar);

  Future<void> save(Ticket ticket) async {
    await isar.writeTxn(() async {
      await isar.tickets.put(ticket);
    });
  }

  Future<bool> delete(Id id) async {
    bool answer = false;
    await isar.writeTxn(() async {
      answer = await isar.tickets.delete(id);
    });
    return answer;
  }

  Future<Ticket?> get(Id id) async {
    return await isar.tickets.get(id);
  }

  Future<List<Ticket>> getAll() async {
    return await isar.tickets.where().findAll();
  }

  Future<List<Ticket>> getTickets(Id id) async {
    return await isar.tickets.filter().customerIdEqualTo(id).findAll();
  }

  Future<List<Ticket>> getPendingTickets() async {
    return await isar.tickets
        .filter()
        .typeEqualTo(TicketType.sale)
        .statusEqualTo(TicketStatus.pending)
        .findAll();
  }

  Future<List<Ticket>> getPending(Id id) async {
    List<Ticket> pendingTickets = await isar.tickets
        .filter()
        .customerIdEqualTo(id)
        .typeEqualTo(TicketType.sale)
        .statusEqualTo(TicketStatus.pending)
        .findAll();
    List<Ticket> partialTickets = await isar.tickets
        .filter()
        .customerIdEqualTo(id)
        .typeEqualTo(TicketType.sale)
        .statusEqualTo(TicketStatus.partial)
        .findAll();
    return [
      ...{...pendingTickets, ...partialTickets},
    ];
  }

  // Future<List<Ticket>> search(String query) async {
  //   List<Ticket> codeProducts = await isar.tickets
  //       .filter()
  //       .codeContains(query)
  //       .findAll();
  //   List<Product> nameProducts = await isar.products
  //       .filter()
  //       .nameContains(query)
  //       .findAll();
  //   return [...codeProducts, ...nameProducts];
  // }
}
