import 'package:flutter/material.dart';
import 'package:my_money/core/models/currency_model.dart';

@immutable
sealed class CurrencyState {}

final class CurrencyInitial extends CurrencyState {}

final class CurrencyLoading extends CurrencyState {}


final class CurrencyLoaded extends CurrencyState {
  final List<CurrencyModel> currencies;
  final String? successMessage;
  final String? errorMessage;

   CurrencyLoaded({
    required this.currencies,
    this.successMessage,
    this.errorMessage,
  });
}

final class CurrencyError extends CurrencyState {
  final String errorMessage;

  CurrencyError(this.errorMessage);
}
