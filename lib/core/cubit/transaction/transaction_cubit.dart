import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/cubit/transaction/transaction_state.dart';
import 'package:my_money/core/models/transaction_model.dart';
import 'package:my_money/core/repositories/transaction_repository.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionRepository _repository;

  TransactionCubit(this._repository) : super(TransactionInitial());

  Future<void> getAll() async {
    emit(TransactionLoading());

    try {
      final transactions = await _repository.getAll();
      emit(TransactionLoaded(transactions));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> insert(TransactionModel transaction) async {
    emit(TransactionLoading());
    try {
      await _repository.insert(transaction);
      final transactions = await _repository.getAll();
      emit(TransactionLoaded(transactions));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> update(TransactionModel transaction) async {
    emit(TransactionLoading());
    try {
      await _repository.update(transaction);
      final transactions = await _repository.getAll();
      emit(TransactionLoaded(transactions));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> delete(int id) async {
    emit(TransactionLoading());
    try {
      await _repository.delete(id);
      final transactions = await _repository.getAll();
      emit(TransactionLoaded(transactions));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }
}
