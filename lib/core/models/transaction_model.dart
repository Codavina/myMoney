class TransactionModel {
  final int? transactionId;
  final int fundId;
  final double amount;
  final int transactionType;
  final DateTime transactionDate;
  final String description;
  final DateTime createdAt;

  const TransactionModel({
    this.transactionId,
    required this.fundId,
    required this.amount,
    required this.transactionType,
    required this.transactionDate,
    required this.description,
    required this.createdAt,
  });

  // Convert Dart object → Map (used when saving to SQLite)
  // SQLite only understands Map<String, dynamic>, not Dart objects
  Map<String, dynamic> toMap() {
    return {
      if (transactionId != null) 'transaction_id': transactionId,
      'fund_id': fundId,
      'amount': amount,
      'transaction_type': transactionType,
      'transaction_date': transactionDate.toIso8601String(),
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Convert Map (from SQLite) → Dart object
  // This is used when reading data from the database
  //Just like reading data from API
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      transactionId: map['transaction_id'] as int?,
      fundId: map['fund_id'] as int,
      amount: (map['amount'] as num).toDouble(),
      transactionType: map['transaction_type'] as int,
      transactionDate: DateTime.parse(map['transaction_date']),
      description: map['description'] as String,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  /// Returns a copy of this object with the given fields replaced.
  TransactionModel copyWith({
    int? transactionId,
    int? fundId,
    double? amount,
    int? transactionType,
    DateTime? transactionDate,
    String? description,
    DateTime? createdAt,
  }) {
    return TransactionModel(
      transactionId: transactionId ?? this.transactionId,
      fundId: fundId ?? this.fundId,
      amount: amount ?? this.amount,
      transactionType: transactionType ?? this.transactionType,
      transactionDate: transactionDate ?? this.transactionDate,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

/// Returns a readable string representation of this object.
/// when making print(transaction) it print data not Instance of 'TransactionModel'
@override
  String toString() {

    return 'TransactionModel('
      'transaction_id: $transactionId,'
       ' fund_id: $fundId,'
      '  amount: $amount,'
        'transaction_type: $transactionType,'
       ' transaction_date: $transactionDate, '
        'description: $description, '
       ' created_at: $createdAt,'
    ')';
  }
}
