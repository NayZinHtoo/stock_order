import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pos/models/pos_payment.dart';
import 'package:stock_pos/providers/pos_payment_provider.dart';
import 'package:stock_pos/screens/stock_list_screen.dart';
import 'package:stock_pos/utils/constant.dart';

import '../models/stock_order_payment.dart';
import '../providers/stock_order_payment_provider.dart';
import '../providers/stock_order_view_provider.dart';

class OrderPaymentSreen extends StatefulWidget {
  final String pid;
  final int slipNo;
  final double totalAmount;
  const OrderPaymentSreen(
      {super.key,
      required this.pid,
      required this.totalAmount,
      required this.slipNo});

  @override
  State<OrderPaymentSreen> createState() => _OrderPaymentSreenState();
}

class _OrderPaymentSreenState extends State<OrderPaymentSreen> {
  PosPayment? posPayment;
  late PosPaymentProvider posPaymentProvider;
  late StockOrderPaymentProvider stockOrderPaymentProvider;
  late StockOrderViewProvider stockOrderViewProvider;
  List<StockOrderPayment> orderPaymentList = [];

  static double saleTotalAmount = 0.0;
  static List<PosPayment> posPaymentDropdownData = [];
  static List<double> paymentData = [];
  double subTotal = 0.0;

  Widget _listView() {
    var list = _getPaymentWidgets();
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Container(
          //margin: EdgeInsets.all(5),
          child: list[index],
        );
      },
    );
  }

  List<Widget> _getPaymentWidgets() {
    List<Widget> stockPaymentWidgets = [];
    for (int i = 0; i < posPaymentDropdownData.length; i++) {
      stockPaymentWidgets.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: DynamicPaymentWidget(index: i),
            ),
            const SizedBox(
              width: 16,
            ),
            posPaymentDropdownData.length == i + 1
                ? _addRemoveButton(true, i)
                : _addRemoveButton(false, i),
          ],
        ),
      ));
    }
    return stockPaymentWidgets;
  }

  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          subTotal = 0.0;
          for (var i = 0; i < paymentData.length; i++) {
            subTotal += paymentData[i];
          }
          if (subTotal != widget.totalAmount) {
            posPaymentDropdownData.add(posPayment!);
            paymentData.add(widget.totalAmount - subTotal);
            stockOrderPaymentProvider.setValidAmount(true);
          }
        } else {
          paymentData[paymentData.length - 1] += paymentData[index];
          posPaymentDropdownData.removeAt(index);
          paymentData.removeAt(index);
        }
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void initState() {
    posPaymentProvider =
        Provider.of<PosPaymentProvider>(context, listen: false);
    stockOrderPaymentProvider =
        Provider.of<StockOrderPaymentProvider>(context, listen: false);
    stockOrderViewProvider =
        Provider.of<StockOrderViewProvider>(context, listen: false);
    stockOrderViewProvider.getStockDetailList(widget.pid);

    saleTotalAmount = widget.totalAmount;

    Future.delayed(Duration.zero, () async {
      await _getPaymentList();
    });

    paymentData.add(widget.totalAmount);

    super.initState();
  }

  Future<void> _getPaymentList() async {
    List<PosPayment> list = await posPaymentProvider.getAllPaymentList();
    posPayment = list[0];
    posPaymentDropdownData.add(posPayment!);
    setState(() {});
  }

  @override
  void dispose() {
    posPaymentDropdownData.clear();
    paymentData.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sale Payment'),
        leading: IconButton(
          onPressed: () {
            posPaymentDropdownData.clear();
            paymentData.clear();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'SlipNo#: ${widget.slipNo}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'SALE ITEM(S)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Consumer<StockOrderViewProvider>(
                  builder: (context, provider, _) {
                return ListView.builder(
                    itemCount: provider.stockDetailList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                                flex: 3,
                                child: Text(
                                    '${provider.stockDetailList[index].stkName}')),
                            Expanded(
                                flex: 1,
                                child: Text(
                                    '${provider.stockDetailList[index].qty}')),
                            Expanded(
                                flex: 2,
                                child: Text(
                                    '${thousandsSeparatorsFormat(provider.stockDetailList[index].amount!)} MMK')),
                          ],
                        ),
                      );
                    });
              }),
            ),
            Consumer<StockOrderViewProvider>(builder: (context, provider, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text(
                          'Total Qty',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${provider.totalQty}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text(
                          'Item Count',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${provider.stockDetailList.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text(
                          'Total Amount',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${thousandsSeparatorsFormat(widget.totalAmount)} MMK',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: _listView(),
            ),
            const SizedBox(
              height: 10,
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
                Navigator.popUntil(context, (route) => false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const StockListScreen(
                            title: 'Stock Pos',
                          )),
                );
              },
              child: const Text(
                'Go to Home',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Consumer<StockOrderPaymentProvider>(
                builder: (context, provider, _) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  padding: const EdgeInsets.all(8),
                  backgroundColor: AppColor.greenColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: provider.isValidAmount
                    ? () {
                        for (var i = 0;
                            i < posPaymentDropdownData.length;
                            i++) {
                          if (paymentData[i] > 0.0) {
                            var syskey = generatesyskey();
                            var orderPayment = StockOrderPayment(
                              syskey: syskey,
                              parentId: widget.pid,
                              paymentId: posPaymentDropdownData[i].id,
                              paymentdesc: posPaymentDropdownData[i].desc,
                              amount: paymentData[i],
                              status: 0,
                            );
                            orderPaymentList.add(orderPayment);
                          }
                        }
                        provider.addOrderPayment(orderPaymentList);
                        showToast('Pay Bill Successful');
                        Navigator.popUntil(context, (route) => false);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StockListScreen(
                                    title: 'Stock Pos',
                                  )),
                        );
                      }
                    : null,
                child: Text(
                  provider.isValidAmount
                      ? 'Pay Bill'
                      : 'Please Check Your Amount',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class DynamicPaymentWidget extends StatefulWidget {
  final int index;

  const DynamicPaymentWidget({
    super.key,
    required this.index,
  });

  @override
  State<DynamicPaymentWidget> createState() => _DynamicPaymentWidgetState();
}

class _DynamicPaymentWidgetState extends State<DynamicPaymentWidget> {
  late TextEditingController _paymentAmountController;
  PosPayment? posPayment;
  late double changedValueAmount = 0.0;
  @override
  void initState() {
    _paymentAmountController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _paymentAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _paymentAmountController.text =
          '${_OrderPaymentSreenState.paymentData[widget.index]}';
      posPayment = _OrderPaymentSreenState.posPaymentDropdownData[widget.index];
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Consumer<PosPaymentProvider>(builder: (context, provider, _) {
            return DropdownButtonFormField(
              value:
                  _OrderPaymentSreenState.posPaymentDropdownData[widget.index],
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              ),
              icon: const Icon(
                Icons.arrow_drop_down_sharp,
                size: 30,
                textDirection: TextDirection.rtl,
              ),
              items: provider.paymentList.map((PosPayment items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text('${items.desc}'),
                );
              }).toList(),
              onChanged: (PosPayment? selectedPosPayment) {
                setState(() {
                  posPayment = selectedPosPayment!;
                  _OrderPaymentSreenState.posPaymentDropdownData[widget.index] =
                      posPayment!;
                });
              },
            );
          }),
        ),
        Expanded(
          flex: 1,
          child: TextFormField(
            style: TextStyle(
                color: _OrderPaymentSreenState.paymentData[widget.index] >= 0.0
                    ? null
                    : Colors.redAccent),
            controller: _paymentAmountController,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              hintText: 'Enter your amount',
            ),
            readOnly: _OrderPaymentSreenState.paymentData[widget.index] >= 0.0
                ? false
                : true,
            onFieldSubmitted: (value) {
              setState(() {
                changedValueAmount = double.parse(value);
                _OrderPaymentSreenState.paymentData[widget.index] =
                    changedValueAmount;
                var sumAmount = 0.0;
                for (var i = 0;
                    i < _OrderPaymentSreenState.paymentData.length;
                    i++) {
                  sumAmount += _OrderPaymentSreenState.paymentData[i];
                }
                if (sumAmount == _OrderPaymentSreenState.saleTotalAmount) {
                  Provider.of<StockOrderPaymentProvider>(context, listen: false)
                      .setValidAmount(true);
                } else {
                  Provider.of<StockOrderPaymentProvider>(context, listen: false)
                      .setValidAmount(false);
                }
              });
            },
          ),
        ),
      ],
    );
  }
}
