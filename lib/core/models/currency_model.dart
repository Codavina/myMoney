class CurrencyModel {
  final int? currencyId;
  final String currencyCode;


  ///constructor
  const CurrencyModel({this.currencyId, required this.currencyCode});

  // Convert Dart object → Map (used when saving to SQLite)
  // SQLite only understands Map<String, dynamic>, not Dart objects
  Map<String, dynamic> toMap() {
    return {'currencyId': currencyId, 'currencyCode': currencyCode};
  }

  // Convert Map (from SQLite) → Dart object
  // This is used when reading data from the database
  //Just like reading data from API
  factory CurrencyModel.fromMap(Map<String, dynamic> map) {
    return CurrencyModel(
      currencyId: map['currencyId'] as int?,
      currencyCode: map['currencyCode'] as String,
    );
  }

  /// Returns a copy of this object with the given fields replaced.
  CurrencyModel copyWith({
    int? currencyId,
    String? currencyCode,
  }) {
    return CurrencyModel(
      currencyId: currencyId ?? this.currencyId,
      currencyCode: currencyCode ?? this.currencyCode,
    );
  }

  /// Returns a readable string representation of this object.
  /// when making print(currency) it print data not Instance of 'CurrencyModel'
  @override
  String toString() {
    return 'CurrencyModel('
        'currencyId: $currencyId, '
        'currencyCode: $currencyCode'
        ')';
  }
}
