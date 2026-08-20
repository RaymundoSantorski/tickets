import 'package:tickets/core/models/ticket_item.dart';

double calculateWeight(List<TicketItem> items) {
  return items.fold(
    0.0,
    (last, item) => (item.unitWeight ?? 0) * item.quantity + last,
  );
}

double calculateVolWeight(List<TicketItem> items) {
  return items.fold(
    0.0,
    (last, item) => (item.unitVolumetricWeight ?? 0) * item.quantity + last,
  );
}

int calculatePendingItems(List<TicketItem> items) {
  return items.fold(0, (last, item) => item.quantity + last);
}

double calculateSubtotal(List<TicketItem> items) {
  return items.fold(
    0.0,
    (last, item) => (item.unitPrice * item.quantity) + last,
  );
}
