import 'package:isar/isar.dart';
part 'customer.g.dart';

@collection
class Customer {
  Id id = Isar.autoIncrement;
  late String fullName;
  late String name;
  String? phoneNumber;
  Address? address;
}

@embedded
class Address {
  late String street;
  late String number;
  late String zipCode;
  late String neighborhood;
  late String city;
  late String state;
}
