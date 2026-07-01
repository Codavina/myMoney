class FundModel {
  final int? fundId;
  final String title;
  final double balance;
  final int currencyId;
  final int isArchived;
  final String createdAt;

 const FundModel({
     this.fundId,
    required this.title,
    required this.balance,
    required this.currencyId,
    required this.isArchived,
    required this.createdAt,
  });
}
