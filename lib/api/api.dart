import 'package:isar/isar.dart';
import 'package:test_project_sandbox/model/currency_model.dart';

/// Абстрактный класс Апи

abstract class Api{

  Future<List<CurrencyModel>> getLatest({Isar? isar}) async{
    throw UnimplementedError();
  }

}