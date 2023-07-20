import 'package:test_project_sandbox/model/currency_model.dart';

/// Класс обозначения событий

abstract class AppEvent{}

/// Класс обозначения события инициализации

class InitAppEvent extends AppEvent{}

/// Класс обозначения события обновления списка [CurrencyModel]

class UpdateCurrenciesEvent extends AppEvent{}

/// Класс обозначения события изменения изначального количества

class UpdateFromEvent extends AppEvent{
  double from;

  UpdateFromEvent({required this.from});
}

/// Класс обозначения события новой [CurrencyModel]

class ChooseFromCurrency extends AppEvent{
  CurrencyModel from;

  ChooseFromCurrency({required this.from});
}

/// Класс обозначения события новой [CurrencyModel]

class ChooseToCurrency extends AppEvent{
  CurrencyModel to;

  ChooseToCurrency({required this.to});
}

/// Класс обозначения события конвертации

class ConvertEvent extends AppEvent{}