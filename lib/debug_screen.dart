import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_money/core/models/fund_model.dart';
import 'package:my_money/core/models/transaction_model.dart';
import 'package:my_money/core/repositories/currency_repository.dart';
import 'package:my_money/core/repositories/fund_repository.dart';
import 'package:my_money/core/repositories/transaction_repository.dart';

import 'core/models/currency_model.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  final currencyRepo = CurrencyRepository();
     List<CurrencyModel> currencies = [];

  final fundRepo=FundRepository();
  List<FundModel> funds=[];

  final transactionRepo = TransactionRepository();
  List<TransactionModel> transactions=[];

  Future<void> load() async {
    transactions = await transactionRepo.getAll();
    log(transactions.toString());
  }

  Future<void> loadFunds() async {
    funds = await fundRepo.getAll();
    log(funds.toString());
  }

  Future<void> add() async {
    final result = await currencyRepo.insert(const CurrencyModel(currencyCode: 'DZD'));
    log(result.toString());
    load();
  }
Future<void>addTrans()async{
    final result = await transactionRepo.insert(TransactionModel(fundId: 3, amount: 12500, transactionType: 0, transactionDate: DateTime.now(), description: 'description', createdAt: DateTime.now()));
}
  Future<void> getById() async {
    final result = await transactionRepo.getById(20);
    log(result.toString());
  }

  Future<void> update() async {
    final result = await transactionRepo.update(TransactionModel(fundId: 1, amount: 2000, transactionType: 1, transactionDate: DateTime.now(), description: 'withdraw amount', createdAt: DateTime.now(),transactionId: 100));
    log(result.toString());
    load();
  }

  Future<void> delete() async {
    final result = await transactionRepo.delete(20);
    log(result.toString());
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug Screen'),backgroundColor: Colors.teal,),
      body: Center(child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            minimumSize: const Size(200,65),
          ),
          onPressed: (){

            add();

          // getById();
           //update();
           //delete();
         //  load();
          // loadFunds();
          }, child: const Text('Run Currency Crud Operations')),),
    );
  }
}
