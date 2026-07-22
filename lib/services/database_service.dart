import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tickets/core/models/customer.dart';

class DatabaseService {
  late Isar isar;

  Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([CustomerSchema], directory: dir.path);
  }
}
