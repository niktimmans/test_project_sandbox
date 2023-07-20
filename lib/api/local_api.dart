import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_project_sandbox/api/api.dart';
import 'package:test_project_sandbox/db/isar_collection.dart';
import 'package:test_project_sandbox/model/currency_model.dart';

/// Класс обозначающий Локальный Апи, реализующий класс [Api]

class LocalApi implements Api {
  @override
  Future<List<CurrencyModel>> getLatest({Isar? isar}) async {
    final result = await isar!.allRates.where().findAll();
    List<CurrencyModel> currencies = [];
    result.forEach((element) {
      currencies.add(CurrencyModel(
        value: element.value,
        name: element.key,
        id: element.id,
      ));
    });
    return currencies;
  }

  Future<void> updateLocalCurrencies(
      {required Isar isar, required List<CurrencyModel> models}) async {
    await isar.writeTxn(() async {
      await isar.allRates.where().deleteAll();
    });
    await isar.allRates.where().deleteAll();
    final putObjects = models
        .map((e) => AllRates(
              key: e.name,
              value: e.value,
            ))
        .toList();
    await isar.writeTxn(() async {
      await isar.allRates.putAll(putObjects);
    });
  }
}
