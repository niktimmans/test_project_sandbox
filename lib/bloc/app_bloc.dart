import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project_sandbox/bloc/app_event.dart';
import 'package:test_project_sandbox/bloc/app_state.dart';

import '../repository/app_repository.dart';

class AppBloc extends Bloc<AppEvent, AppState>{

  late AppRepository _repository;

  AppBloc({required AppRepository repository})
      : _repository = repository,
        super(InitAppState()) {
    on<InitAppEvent>(_init);
    on<UpdateCurrenciesEvent>(_update);
    on<ChooseFromCurrency>(_chooseFrom);
    on<ChooseToCurrency>(_chooseTo);
    on<ConvertEvent>(_convert);
    on<UpdateFromEvent>(_updateFrom);
  }

  FutureOr<void> _init(InitAppEvent event, emit) async{
    _repository.currenciesList.listen((value) {
      add(UpdateCurrenciesEvent());
    });
  }

  FutureOr<void> _update(UpdateCurrenciesEvent event, emit) async{
    final res = _repository.currenciesList.valueOrNull;
    if(res != null){
      emit(ReadyAppState(
        currencies: res,
        fromCurrency: state.fromCurrency,
        toCurrency: state.toCurrency,
        result: state.result,
        from: state.from,
      ));
    }
  }

  FutureOr<void> _chooseFrom(ChooseFromCurrency event, emit) async{
    emit(ReadyAppState(
      currencies: state.currencies,
      fromCurrency: event.from,
      toCurrency: state.toCurrency,
      result: state.result,
      from: state.from,
    ));
  }

  FutureOr<void> _chooseTo(ChooseToCurrency event, emit) async{
    emit(ReadyAppState(
      currencies: state.currencies,
      fromCurrency: state.fromCurrency,
      toCurrency: event.to,
      result: state.result,
      from: state.from,
    ));
  }

  FutureOr<void> _convert(ConvertEvent event, emit) async{
    if(state.from != null && state.fromCurrency != null && state.toCurrency != null) {
      double result = 0;
      if (state.fromCurrency!.name!.toLowerCase() == 'eur') {
        result = state.toCurrency!.value! * state.from!;
      } else {
        result = (state.from! / state.fromCurrency!.value!) *
            state.toCurrency!.value!;
      }
      emit(ReadyAppState(
        currencies: state.currencies,
        fromCurrency: state.fromCurrency,
        toCurrency: state.toCurrency,
        result: result,
        from: state.from,
      ));
    }
  }

  FutureOr<void> _updateFrom(UpdateFromEvent event, emit) async{
    emit(ReadyAppState(
      currencies: state.currencies,
      fromCurrency: state.fromCurrency,
      toCurrency: state.toCurrency,
      result: state.result,
      from: event.from,
    ));
  }

}