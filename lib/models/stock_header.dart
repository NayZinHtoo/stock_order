class StockHeader {
  int? id;
  String? syskey;
  int? slipNumber;
  double? amount;
  String? date;
  String? time;
  int status;

  StockHeader({
    this.id,
    this.syskey,
    this.slipNumber,
    this.amount,
    this.date,
    this.time,
    this.status = 1,
  });

  StockHeader.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        syskey = result["syskey"],
        slipNumber = result["slipNumber"],
        amount = result["amount"],
        date = result["date"],
        time = result["time"],
        status = result["status"];

  Map<String, Object> toMap() {
    return {
      'syskey': syskey!,
      'slipNumber': slipNumber!,
      'amount': amount!,
      'date': date!,
      'time': time!,
      'status': status,
    };
  }
}
