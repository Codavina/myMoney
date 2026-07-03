import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/cubit/fund/fund_state.dart';
import 'package:my_money/core/models/fund_model.dart';
import 'package:my_money/core/repositories/fund_repository.dart';

class FundCubit extends Cubit<FundState> {
  final FundRepository _repository;

  FundCubit(this._repository) : super(FundInitial());

  Future<void> getAll() async {
    emit(FundLoading());

    try {
      final funds = await _repository.getAll();

      emit(FundLoaded(funds));
    } catch (e) {
      emit(FundError(e.toString()));
    }
  }

  Future<void> insert(FundModel fund) async {
    emit(FundLoading());

    try {
      await _repository.insert(fund);
      final funds = await _repository.getAll();
      emit(FundLoaded(funds));
    } catch (e) {
      emit(FundError(e.toString()));
    }
  }

  Future<void> update(FundModel fund) async {
    emit(FundLoading());

    try {
      await _repository.update(fund);
      final funds = await _repository.getAll();
      emit(FundLoaded(funds));
    } catch (e) {
      emit(FundError(e.toString()));
    }
  }

  Future<void> delete(int id) async {
    emit(FundLoading());
    try{
      await _repository.delete(id);
      final funds = await _repository.getAll();
      emit(FundLoaded(funds));
    }catch (e){
      emit(FundError(e.toString()));
    }
  }

  Future<void> archive(int id) async {
    //i do not have archive method in fund_repository yet
    // i think this method it just update the is_archived from false to true
  }
}
