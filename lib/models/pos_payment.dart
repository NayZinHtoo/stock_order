class PosPayment {
  int? id;
  String? syskey;
  String? desc;
  int? dftPayment;
  int status;

  PosPayment({
    this.id,
    this.syskey,
    this.desc,
    this.dftPayment = 0,
    this.status = 0,
  });

  PosPayment.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        syskey = result["syskey"],
        desc = result["desc"],
        dftPayment = result["dftPayment"],
        status = result["status"];

  Map<String, Object> toMap() {
    return {
      'syskey': syskey!,
      'desc': desc!,
      'dftPayment': dftPayment!,
      'status': status,
    };
  }
}
