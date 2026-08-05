import 'package:isar/isar.dart';
part 'ticket.g.dart';

@collection
class Ticket {
  Id id = Isar.autoIncrement;
  late int customerId;
  late String name;
  late String fullName;
  late String phoneNumber;
  late DateTime date;
  bool status = false;
  late double discount;
  late double oldDebt;
  late double total;
  late String notes;
  late int pendingItmes;
  late double pendingWeight;
  late double pendingVolumetricWeight;
}
