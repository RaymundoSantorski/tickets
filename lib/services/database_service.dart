import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tickets/core/models/customer.dart';
import 'package:tickets/core/models/product.dart';
import 'package:tickets/core/models/ticket.dart';

class DatabaseService {
  late Isar isar;

  Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      CustomerSchema,
      ProductSchema,
      TicketSchema,
    ], directory: dir.path);
  }
}
