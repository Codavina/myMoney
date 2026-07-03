
import 'package:flutter/material.dart';
import 'package:my_money/core/models/fund_model.dart';

@immutable
sealed class FundState {}

final class FundInitial extends FundState {}

final class FundLoading extends FundState {}

final class FundLoaded extends FundState {
  final List<FundModel> funds;

  FundLoaded(this.funds);
}

final class FundError extends FundState {
  final String errorMessage;

  FundError(this.errorMessage);
}
