class FundModel {
  final int? fundId;
  final String title;
  final double balance;
  final int currencyId;
  final bool isArchived;
  final DateTime createdAt;

  const FundModel({
    this.fundId,
    required this.title,
     this.balance=0,
    required this.currencyId,
    required this.isArchived,
    required this.createdAt,
  });

  // Convert Dart object → Map (used when saving to SQLite)
  // SQLite only understands Map<String, dynamic>, not Dart objects
  Map<String, dynamic> toMap() {
    return {
      if (fundId != null) 'fund_id': fundId,
      'title': title,
      'balance': balance,
      'currency_id': currencyId,
      'is_archived': isArchived ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Convert Map (from SQLite) → Dart object
  // This is used when reading data from the database
  //Just like reading data from API
  factory FundModel.fromMap(Map<String, dynamic> map) {
    return FundModel(
      fundId: map['fund_id'] as int?,
      title: map['title'] as String,
      balance: (map['balance'] as num).toDouble(),
      currencyId: map['currency_id'] as int,
      isArchived: map['is_archived'] == 1,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  /// Returns a copy of this object with the given fields replaced.
  FundModel copyWith({
    int? fundId,
    String? title,
    double? balance,
    int? currencyId,
    bool? isArchived,
    DateTime? createdAt,
  }) {
    return FundModel(
      fundId: fundId ?? this.fundId,
      title: title ?? this.title,
      balance: balance ?? this.balance,
      currencyId: currencyId ?? this.currencyId,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Returns a readable string representation of this object.
  /// when making print(Fund) it print data not Instance of 'FundModel'
  @override
  String toString() {
    return 'FundModel('
        'fund_id: $fundId,'
        'title: $title,'
        'balance: $balance,'
        'currency_id: $currencyId,'
        'is_archived: $isArchived,'
        'created_at: $createdAt,'
        ')';
  }
}
