import 'package:isar/isar.dart';

part 'isar_collection.g.dart';

/// Модель коллекции для БД

@collection
class AllRates{

  AllRates({this.key, this.value});

  Id id = Isar.autoIncrement;

  double? value;
  String? key;
}