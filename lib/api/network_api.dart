import 'package:dio/dio.dart';
import 'package:isar/isar.dart';
import 'package:test_project_sandbox/api/api.dart';
import 'package:test_project_sandbox/model/currency_model.dart';

/// Класс обозначающий Интернет Апи, реализующий класс [Api]

class NetworkApi implements Api{

  // Делаю простой запрос с прямым прокидыванием access_key
  // Других запросов смысла делать нет т.к. в бесплатной версии ключа доступно
  // только получение списка всех относительно Евро. Значит вся логика перевода
  // будет работать относительно Евро. Смысла делать запрос на
  // получение списка всех доступных валют тоже нет, там только список ключей и их названия.
  @override
  Future<List<CurrencyModel>> getLatest({Isar? isar}) async{
    final dio = Dio();
    final result = await dio.get('http://api.exchangeratesapi.io/v1/latest?access_key=e26bdc95b62866ffa6d5e58f4abadeaf');
    final keyResult = (result.data['rates'] as Map<String, dynamic>).keys.toList();
    final data = result.data['rates'];
    List<CurrencyModel> currencies = [];
    keyResult.forEach((element) {
      currencies.add(CurrencyModel(
        value: double.tryParse(data[element].toString()) ?? double.parse(data[element].toString().toUpperCase()),
        name: element,
      ));
    });
    return currencies;
  }
}