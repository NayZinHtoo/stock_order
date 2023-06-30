class StockHeader {
  int? id;
  int? slipNumber;
  double? amount;
  String? date;
  String? time;
  int status;

  StockHeader({
    this.id,
    this.slipNumber,
    this.amount,
    this.date,
    this.time,
    this.status = 0,
  });

  StockHeader.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        slipNumber = result["slipNumber"],
        amount = result["amount"],
        date = result["date"],
        time = result["time"],
        status = result["status"];

  Map<String, Object> toMap() {
    return {
      'slipNumber': slipNumber!,
      'amount': amount!,
      'date': date!,
      'time': time!,
      'status': status,
    };
  }
}
