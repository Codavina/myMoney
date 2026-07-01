class OperationModel {
   String date;
   String description;
   double amount;
   bool isDeposit;


   OperationModel({
    required this.date,
    required this.description,
    required this.amount,
    required this.isDeposit,
  });
}