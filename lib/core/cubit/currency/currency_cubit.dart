import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/cubit/currency/currency_state.dart';
import 'package:my_money/core/models/currency_model.dart';
import 'package:my_money/core/repositories/currency_repository.dart';

class CurrencyCubit extends Cubit<CurrencyState> {
  final CurrencyRepository _repository;

  CurrencyCubit(this._repository) : super(CurrencyInitial());

  /// Loads all currencies from the database.
  Future<void> getAll() async {
    emit(CurrencyLoading());

    try {
      final currencies = await _repository.getAll();

      emit(CurrencyLoaded(currencies));
    } catch (e) {
      emit(CurrencyError(e.toString()));
    }
  }

  Future<void> insert(CurrencyModel model) async {
    emit(CurrencyLoading());

    try {
      await _repository.insert(model);

      final currencies = await _repository.getAll();

      emit(CurrencyLoaded(currencies));
    } catch (e) {
      emit(CurrencyError(e.toString()));
    }
  }


  Future<void> update(CurrencyModel currency)async{
    emit(CurrencyLoading());

    try {
      await _repository.update(currency);
      final currencies =await _repository.getAll();

      emit(CurrencyLoaded(currencies));
    } catch (e) {
      emit(CurrencyError(e.toString()));
    }
  }

  Future<void> delete(int id)async{
    emit(CurrencyLoading());
    try{
      await _repository.delete(id);
      final currencies = await _repository.getAll();
      emit(CurrencyLoaded(currencies));

    }catch (e){
      emit(CurrencyError(e.toString()));
    }
  }


}
