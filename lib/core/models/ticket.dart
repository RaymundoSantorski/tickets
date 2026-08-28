import 'package:isar/isar.dart';
import 'package:tickets/core/models/ticket_item.dart';
part 'ticket.g.dart';

enum TicketStatus { pending, partial, paid }

enum TicketType { sale, payment, shipment }

enum PaymentMethod { transfer, cash, other, none }

@collection
class Ticket {
  Id id = Isar.autoIncrement;
  late int customerId;
  late String displayName;
  late String fullName;
  String? phoneNumber;
  late DateTime date;
  DateTime? dueDate;
  @enumerated
  late TicketType type;
  @enumerated
  late TicketStatus status;
  late double discount;
  late double balanceBefore;
  late double balanceAfter;
  late double subtotal;
  late double total;
  double paidAmount = 0;

  @enumerated
  PaymentMethod paymentMethod = PaymentMethod.none;

  String? notes;
  List<TicketItem> items = [];
}
