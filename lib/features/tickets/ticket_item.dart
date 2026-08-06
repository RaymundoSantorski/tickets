import 'package:isar/isar.dart';
part 'ticket_item.g.dart';

@embedded
class TicketItem {
  late int productId;
  late int quantity;
  late double unitPrice;
  late double unitCost;
  late String code;
  late String name;
  double? unitWeight;
  double? unitVolumetricWeight;
  late double subtotal;
}
