import 'package:flutter/material.dart';
import 'package:my_money/core/models/transaction_model.dart';

@immutable
sealed class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionEmpty extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<TransactionModel> transactions;
  final String? successMessage;
  final String? errorMessage;

  TransactionLoaded({required this.transactions, this.successMessage, this.errorMessage});
}

class TransactionError extends TransactionState {
  final String errorMessage;

  TransactionError(this.errorMessage);
}
