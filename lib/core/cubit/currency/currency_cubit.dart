import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/cubit/currency/currency_state.dart';
import 'package:my_money/core/models/currency_model.dart';
import 'package:my_money/core/repositories/currency_repository.dart';

import '../../errors/app_exception.dart';

class CurrencyCubit extends Cubit<CurrencyState> {
  final CurrencyRepository _repository;

  CurrencyCubit(this._repository) : super(CurrencyInitial());

  /// Loads all currencies from the database.
  Future<void> getAll() async {
    emit(CurrencyLoading());

    try {
      final currencies = await _repository.getAll();
      emit(CurrencyLoaded(currencies: currencies));
    } catch (e) {
      emit(CurrencyError(e.toString()));
    }
  }

  Future<void> insert(CurrencyModel model) async {
    emit(CurrencyLoading());

    try {
      await _repository.insert(model);

      final currencies = await _repository.getAll();

      emit(
        CurrencyLoaded(
          currencies: currencies,
          successMessage: 'Currency added successfully.',
        ),
      );
    } catch (e) {
      final currencies = await _repository.getAll();

      emit(
        CurrencyLoaded(
          currencies: currencies,
          errorMessage: e is AppException ? e.message : 'Unexpected error.',
        ),
      );
    }
  }

  Future<void> update(CurrencyModel currency) async {
    emit(CurrencyLoading());

    try {
      await _repository.update(currency);
      final currencies = await _repository.getAll();

      emit(
        CurrencyLoaded(
          currencies: currencies,
          successMessage: 'Currency updated successfully',
        ),
      );
    } catch (e) {
      emit(CurrencyError(e.toString()));
    }
  }

  Future<void> delete(int id) async {
    emit(CurrencyLoading());
    try {
      await _repository.delete(id);
      final currencies = await _repository.getAll();
      emit(
        CurrencyLoaded(
          currencies: currencies,
          successMessage: 'Currency deleted successfully',
        ),
      );
    } catch (e) {
      emit(CurrencyError(e.toString()));
    }
  }
}
