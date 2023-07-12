import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pos/models/pos_payment.dart';
import 'package:stock_pos/providers/pos_payment_provider.dart';

import '../utils/constant.dart';

class POSPaymentSetupScreen extends StatefulWidget {
  final PosPayment? posPayment;
  const POSPaymentSetupScreen({super.key, this.posPayment});

  @override
  State<POSPaymentSetupScreen> createState() => _POSPaymentSetupScreenState();
}

class _POSPaymentSetupScreenState extends State<POSPaymentSetupScreen> {
  final _paymentDescController = TextEditingController();
  late PosPaymentProvider posPaymentProvider;

  final _formKey = GlobalKey<FormState>();
  bool isNew = true;
  bool value = false;

  late int id = 0;
  late String desc;

  @override
  void initState() {
    super.initState();
    posPaymentProvider =
        Provider.of<PosPaymentProvider>(context, listen: false);
    if (widget.posPayment != null) {
      isNew = false;
      id = widget.posPayment!.id!;
      _paymentDescController.text = widget.posPayment!.desc!;
      setState(() {
        value = widget.posPayment!.dftPayment == 0 ? false : true;
      });
    } else {
      Future.delayed(Duration.zero, () async {
        _getPaymentItemCount();
      });
    }
  }

  Future<void> _getPaymentItemCount() async {
    id = await posPaymentProvider.getPaymentItemCount();
    setState(() {});
  }

  @override
  void dispose() {
    _paymentDescController.dispose();
    super.dispose();
  }

  Future savePosPayment(BuildContext context) async {
    final posPaymentProvider =
        Provider.of<PosPaymentProvider>(context, listen: false);
    var syskey = generatesyskey();
    if (_formKey.currentState!.validate()) {
      if (isNew) {
        var posPayment = PosPayment(
          syskey: syskey,
          desc: _paymentDescController.text,
          dftPayment: value ? 1 : 0,
          status: 0,
        );
        posPaymentProvider.addPosPayment(posPayment);

        if (context.mounted) Navigator.pop(context);
      } else {
        var posPayment = PosPayment(
          id: id,
          syskey: syskey,
          desc: _paymentDescController.text,
          dftPayment: value ? 1 : 0,
          status: 0,
        );
        posPaymentProvider.updatePosPayment(posPayment);

        if (context.mounted) Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Payment Setup"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(14),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text('Payment Code'),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          hintText:
                              '${widget.posPayment == null ? id + 1 : id}',
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                              value: value,
                              onChanged: (value) {
                                setState(() {
                                  this.value = value!;
                                });
                              }),
                          const Text('Default'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text('Payment Description'),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _paymentDescController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    hintText: 'Eg.Cash, Wave Pay, etc...',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Please enter payment description';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    padding: const EdgeInsets.all(8),
                    backgroundColor: AppColor.greenColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    savePosPayment(context);
                  },
                  child: Text(
                    isNew ? 'Save' : 'Update',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
