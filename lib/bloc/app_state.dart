import '../model/currency_model.dart';

/// Классы обозначения состояний блока

abstract class AppState {
  List<CurrencyModel>? currencies;
  CurrencyModel? fromCurrency;
  CurrencyModel? toCurrency;
  double? from;
  double? result;

  AppState({
    this.currencies,
    this.fromCurrency,
    this.toCurrency,
    this.result,
    this.from,
  });
}

class InitAppState extends AppState {
  InitAppState();
}

class LoadingAppState extends AppState {
  LoadingAppState();
}

class ReadyAppState extends AppState {
  ReadyAppState({
    super.currencies,
    super.fromCurrency,
    super.toCurrency,
    super.result,
    super.from,
  });
}
