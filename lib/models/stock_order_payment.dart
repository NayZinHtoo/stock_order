class StockOrderPayment {
  int? id;
  String? syskey;
  String? parentId;
  int? paymentId;
  String? paymentdesc;
  double? amount;
  int? status = 0;

  StockOrderPayment({
    this.id,
    this.syskey,
    this.parentId,
    this.paymentId,
    this.paymentdesc,
    this.amount,
    this.status,
  });

  StockOrderPayment.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        syskey = result["syskey"],
        parentId = result["parentId"],
        paymentId = result["paymentId"],
        paymentdesc = result["paymentdesc"],
        amount = result["amount"],
        status = result["status"];

  Map<String, Object> toMap() {
    return {
      'syskey': syskey!,
      'parentId': parentId!,
      'paymentId': paymentId!,
      'paymentdesc': paymentdesc!,
      'amount': amount!,
      'status': status!,
    };
  }
}
