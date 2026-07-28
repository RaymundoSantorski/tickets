import 'package:isar/isar.dart';
part 'product.g.dart';

enum ProductType { physical, digital, service }

@collection
class Product {
  Id id = Isar.autoIncrement;
  late String code;
  late String name;
  late double price;
  late double cost;
  @enumerated
  late ProductType type;
  double? weight;
  double? height;
  double? width;
  double? length;
  double? active;
}
