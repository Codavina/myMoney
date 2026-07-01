class TransactionModel {
  final int? transactionId;
  final int fundId;
  final double amount;
  final int transactionType;
  final String transactionDate;
  final String description;
  final String createdAt;

  const TransactionModel({
     this.transactionId,
    required this.fundId,
    required this.amount,
    required this.transactionType,
    required this.transactionDate,
    required this.description,
    required this.createdAt,
  });
}
