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
  final double totalAmount;
  const OrderPaymentSreen(
      {super.key, required this.pid, required this.totalAmount});

  @override
  State<OrderPaymentSreen> createState() => _OrderPaymentSreenState();
}

class _OrderPaymentSreenState extends State<OrderPaymentSreen> {
  final _controller = TextEditingController();
  PosPayment? posPayment;
  late StockOrderPaymentProvider stockOrderPaymentProvider;
  late StockOrderViewProvider stockOrderViewProvider;
  List<StockOrderPayment> orderPaymentList = [];

  List<TextEditingController> _controllers = [];
  List<TextField> _fields = [];

  @override
  void initState() {
    final provider = Provider.of<PosPaymentProvider>(context, listen: false);
    stockOrderPaymentProvider =
        Provider.of<StockOrderPaymentProvider>(context, listen: false);
    stockOrderViewProvider =
        Provider.of<StockOrderViewProvider>(context, listen: false);
    stockOrderViewProvider.getStockDetailList(widget.pid);
    provider.getAllPaymentList();

    _controller.text = '${widget.totalAmount}';

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _addTile() {
    return Column(
      children: [
        ListTile(
          title: Icon(Icons.add),
          onTap: () {
            final controller = TextEditingController();
            final field = TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    _addTile();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                labelText: "name${_controllers.length + 1}",
              ),
            );

            setState(() {
              _controllers.add(controller);
              _fields.add(field);
            });
          },
        ),
      ],
    );
  }

  Widget _listView() {
    return ListView.builder(
      itemCount: _fields.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(5),
          child: _fields[index],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Order Payment'),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const StockListScreen(
                        title: 'Stock Pos',
                      )),
            );
            //Navigator.pop(context);
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
            const Text('ORDER ITEM(S)'),
            Expanded(
              child: Consumer<StockOrderViewProvider>(
                  builder: (context, provider, _) {
                return ListView.builder(
                    itemCount: provider.stockDetailList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                              flex: 1,
                              child: Text(
                                  '${provider.stockDetailList[index].stkName}')),
                          Flexible(
                              flex: 1,
                              child: Text(
                                  '${provider.stockDetailList[index].qty}')),
                          Flexible(
                              flex: 1,
                              child: Text(
                                  '${provider.stockDetailList[index].amount} MMK')),
                        ],
                      );
                    });
              }),
            ),
            Consumer<PosPaymentProvider>(builder: (context, provider, _) {
              provider.paymentList.isNotEmpty
                  ? posPayment = provider.paymentList[0]
                  : posPayment = null;
              return DropdownButtonFormField(
                value: posPayment,
                decoration: const InputDecoration(),
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
                onChanged: (PosPayment? newValue) {
                  setState(() {
                    posPayment = newValue!;
                  });
                },
              );
            }),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter your amount',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            //_addTile(),
            const SizedBox(
              height: 10,
            ),
            //Expanded(child: _listView()),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: AppColor.greenColor),
              onPressed: () {
                Navigator.popUntil(context, (route) => false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const StockListScreen(
                            title: 'Stock Pos',
                          )),
                );
                //Navigator.of(context).pop();
              },
              child: const Text(
                'Go to Home',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: AppColor.greenColor),
              onPressed: () {
                var syskey = generatesyskey();
                var orderPayment = StockOrderPayment(
                  syskey: syskey,
                  parentId: widget.pid,
                  paymentId: posPayment!.id,
                  paymentdesc: posPayment!.desc,
                  amount: double.parse(_controller.text),
                  status: 0,
                );
                orderPaymentList.add(orderPayment);
                stockOrderPaymentProvider.addOrderPayment(orderPaymentList);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Pay Bill',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
