import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_project_sandbox/api/local_api.dart';
import 'package:test_project_sandbox/api/network_api.dart';
import 'package:test_project_sandbox/db/isar_collection.dart';
import 'package:test_project_sandbox/model/currency_model.dart';

import '../api/api.dart';

/// Репозиторий приложения

class AppRepository{

  /// Стрим со списком всех [CurrencyModel]
  BehaviorSubject<List<CurrencyModel>> currenciesList = BehaviorSubject();
  late Api api;
  late Isar isar;

  /// Инициализация репозитория, бд, и значений для стрима [CurrencyModel]
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [AllRatesSchema],
      directory: dir.path,
    );
    final api = LocalApi();
    final localRes = await api.getLatest(isar: isar);
    if(localRes.isNotEmpty){
      currenciesList.add(localRes);
    }
    getCurrencies();
  }

  /// Получение всех [CurrencyModel] в зависимости от наличия интернет подключения
  void getCurrencies() async{
    if(await InternetConnectionChecker.createInstance().hasConnection){
      api = NetworkApi();
      final result = await api.getLatest();
      currenciesList.add(result);
      final localApi = LocalApi();
      localApi.updateLocalCurrencies(isar: isar, models: result);
    }else{
      api = LocalApi();
      currenciesList.add(await api.getLatest(isar: isar));
    }
  }

}