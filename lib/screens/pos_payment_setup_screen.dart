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

  late int id;
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
    }
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
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text('Payment Code'),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText:
                        '${widget.posPayment == null ? posPaymentProvider.paymentList.length + 1 : id}',
                  ),
                ),
                const Text('Payment Description'),
                TextFormField(
                  controller: _paymentDescController,
                  decoration: const InputDecoration(
                    hintText: 'Enter payment description',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Please enter payment description';
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Default'),
                    Checkbox(
                        value: value,
                        onChanged: (value) {
                          setState(() {
                            this.value = value!;
                          });
                        })
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
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
