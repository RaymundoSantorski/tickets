import 'package:isar/isar.dart';
import 'package:tickets/features/tickets/ticket_item.dart';
part 'ticket.g.dart';

enum TicketStatus { pending, partial, paid }

enum TicketType { sale, payment, shipment }

@collection
class Ticket {
  Id id = Isar.autoIncrement;
  late int customerId;
  late String displayName;
  late String fullName;
  String? phoneNumber;
  late DateTime date;
  late DateTime dueDate;
  @enumerated
  late TicketType type;
  @enumerated
  late TicketStatus status;
  late double discount;
  late double balanceBefore;
  late double balanceAfter;
  late double subtotal;
  late double total;
  String? notes;
  List<TicketItem> items = [];
}
