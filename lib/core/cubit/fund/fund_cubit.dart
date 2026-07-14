import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/cubit/fund/fund_state.dart';
import 'package:my_money/core/models/fund_model.dart';
import 'package:my_money/core/repositories/fund_repository.dart';

import '../../errors/app_exception.dart';

class FundCubit extends Cubit<FundState> {
  final FundRepository _repository;

  FundCubit(this._repository) : super(FundInitial());

  Future<void> getAll() async {
    emit(FundLoading());

    try {
      final funds = await _repository.getAll();

      emit(FundLoaded(funds: funds));
    } catch (e) {
      emit(FundError(e.toString()));
    }
  }

  Future<void> insert(FundModel fund) async {
    emit(FundLoading());

    try {
      await _repository.insert(fund);
      final funds = await _repository.getAll();
      emit(FundLoaded(
          funds:funds,
          successMessage: 'Fund added successfully.',
        ),
      );
    } catch (e) {
      debugPrint(e.runtimeType.toString());
      debugPrint(e.toString());
      final funds = await _repository.getAll();

      emit(FundLoaded(
          funds:funds,
          errorMessage: e is AppException ? e.message : 'Unexpected error.',
        ),
      );
    }
  }

  Future<void> update(FundModel fund) async {
    emit(FundLoading());

    try {
      await _repository.update(fund);
      final funds = await _repository.getAll();
      emit(FundLoaded(
        funds:funds,
        successMessage: 'Fund updated successfully.',
      ),
      );
    } catch (e) {

      final funds = await _repository.getAll();

      emit(FundLoaded(
        funds:funds,
        errorMessage: e is AppException ? e.message : 'Unexpected error.',
      ),
      );
    }
  }

  Future<void> delete(int id) async {
    emit(FundLoading());
    try{
      await _repository.delete(id);
      final funds = await _repository.getAll();
      emit(FundLoaded(
        funds:funds,
        successMessage: 'Fund deleted successfully.',
      ),
      );
    } catch (e) {
      final funds = await _repository.getAll();

      emit(FundLoaded(
        funds:funds,
        errorMessage: e is AppException ? e.message : 'Unexpected error.',
      ),
      );
    }
  }

  Future<void> archive(int id) async {
    //i do not have archive method in fund_repository yet
    // i think this method it just update the is_archived from false to true
  }
}
