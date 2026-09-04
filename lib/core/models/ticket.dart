import 'package:isar/isar.dart';
import 'package:tickets/core/models/ticket_item.dart';
part 'ticket.g.dart';

enum TicketStatus { pending, partial, paid, none }

enum ShipmentStatus { requested, preparing, shipped, arrived, cancelled, none }

enum TicketType { sale, payment, shipment }

enum PaymentMethod { transfer, cash, other, none }

@collection
class Ticket {
  // general
  Id id = Isar.autoIncrement;
  late int customerId;
  late String displayName;
  late String fullName;
  String? phoneNumber;
  late DateTime date;
  @enumerated
  late TicketType type;
  late double balanceBefore;
  late double balanceAfter;
  late double subtotal;
  late double total;
  double paidAmount = 0;
  // sell
  DateTime? dueDate;
  @enumerated
  TicketStatus status = TicketStatus.none;
  late double discount;
  // payment
  @enumerated
  PaymentMethod paymentMethod = PaymentMethod.none;

  // shipment
  @enumerated
  ShipmentStatus shipmentStatus = ShipmentStatus.none;
  double? weight;
  double? volWeight;

  String? notes;
  List<TicketItem> items = [];
}
