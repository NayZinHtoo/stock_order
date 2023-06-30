class StockDetail {
  int? id;
  int? parentId;
  int? stkId;
  String? stkName;
  int qty;
  double? stkprice;
  double? amount;
  int status;

  StockDetail({
    this.id,
    this.parentId,
    this.stkId,
    this.stkName,
    this.qty = 1,
    this.stkprice,
    this.amount,
    this.status = 0,
  });

  StockDetail.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        parentId = result["parentId"],
        stkId = result["stkId"],
        stkName = result["stkName"],
        qty = result["qty"],
        stkprice = result["stkprice"],
        amount = result["amount"],
        status = result["status"];

  Map<String, Object> toMap() {
    return {
      'parentId': parentId!,
      'stkId': stkId!,
      'stkName': stkName!,
      'qty': qty,
      'stkprice': stkprice!,
      'amount': amount!,
      'status': status,
    };
  }
}
