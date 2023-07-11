import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pos/models/stock_header.dart';

import '../models/stock_order_payment.dart';
import '../providers/stock_order_payment_provider.dart';
import '../providers/stock_order_view_provider.dart';
import '../utils/constant.dart';

class StockOrderDetailScreen extends StatefulWidget {
  final StockHeader stockHeader;
  const StockOrderDetailScreen(
      {super.key, required this.title, required this.stockHeader});

  final String title;

  @override
  State<StockOrderDetailScreen> createState() => _StockOrderDetailScreenState();
}

class _StockOrderDetailScreenState extends State<StockOrderDetailScreen> {
  late StockOrderViewProvider stockOrderViewProvider;
  late StockOrderPaymentProvider stockOrderPaymentProvider;

  double paidAmount = 0.0;
  double changeAmount = 0.0;

  @override
  void initState() {
    stockOrderViewProvider =
        Provider.of<StockOrderViewProvider>(context, listen: false);
    stockOrderPaymentProvider =
        Provider.of<StockOrderPaymentProvider>(context, listen: false);
    stockOrderViewProvider.getStockDetailList(widget.stockHeader.syskey!);

    Future.delayed(Duration.zero, () async {
      await _getStockPaymentList();
    });

    super.initState();
  }

  Future<void> _getStockPaymentList() async {
    paidAmount = 0.0;
    List<StockOrderPayment> list = await stockOrderPaymentProvider
        .getStockPaymentList(widget.stockHeader.syskey!);
    for (var payment in list) {
      paidAmount += payment.amount!;
    }
    changeAmount = paidAmount - widget.stockHeader.amount!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(7.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Slip Number: ${widget.stockHeader.slipNumber!}'),
                    const Text(
                        '---------------------------------------------------------------'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${widget.stockHeader.date}'),
                        Text('${widget.stockHeader.time}'),
                      ],
                    ),
                    Consumer<StockOrderViewProvider>(
                        builder: (context, provider, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Item'),
                          Text('${provider.stockDetailList.length}'),
                        ],
                      );
                    }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Amount'),
                        Text(
                            '${thousandsSeparatorsFormat(widget.stockHeader.amount!)} MMK'),
                      ],
                    ),
                    const Text(
                        '---------------------------------------------------------------'),
                  ]),
            ),
            Expanded(
              flex: 3,
              child: Consumer<StockOrderViewProvider>(
                  builder: (context, provider, _) {
                return ListView.builder(
                  itemCount: provider.stockDetailList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      //margin: const EdgeInsets.all(18),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${index + 1}.${provider.stockDetailList[index].stkName}'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Qty - ${provider.stockDetailList[index].qty}'),
                                Text(
                                    'Amount - ${thousandsSeparatorsFormat(provider.stockDetailList[index].amount!)} MMK'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                  '---------------------------------------------------------------'),
            ),
            // Expanded(
            //   child: Consumer<StockOrderPaymentProvider>(
            //       builder: (context, provider, _) {
            //     return ListView.builder(
            //       itemCount: provider.orderPaymentList.length,
            //       itemBuilder: (BuildContext context, int index) {
            //         return Card(
            //           //margin: const EdgeInsets.all(18),
            //           child: Padding(
            //             padding: const EdgeInsets.all(18.0),
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     provider.orderPaymentList[index].amount! > 0
            //                         ? Text(
            //                             '${provider.orderPaymentList[index].paymentdesc}')
            //                         : const Text(
            //                             'Change',
            //                             style:
            //                                 TextStyle(color: Colors.redAccent),
            //                           ),
            //                     Text(
            //                       '${thousandsSeparatorsFormat(provider.orderPaymentList[index].amount!)} MMK',
            //                       style: TextStyle(
            //                         color: provider.orderPaymentList[index]
            //                                     .amount! <
            //                                 0
            //                             ? Colors.redAccent
            //                             : null,
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ],
            //             ),
            //           ),
            //         );
            //       },
            //     );
            //   }),
            // ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Flexible(
                          flex: 1,
                          child: Text('Total Item(s) '),
                        ),
                        Flexible(
                          flex: 1,
                          child: Consumer<StockOrderViewProvider>(
                              builder: (context, provider, _) {
                            return Text('${provider.totalQty}');
                          }),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Flexible(
                          flex: 1,
                          child: Text('Total Amount'),
                        ),
                        Flexible(
                          flex: 1,
                          child: Text(
                              '${thousandsSeparatorsFormat(widget.stockHeader.amount!)} MMK'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Flexible(
                          flex: 1,
                          child: Text('Paid'),
                        ),
                        Flexible(
                          flex: 1,
                          child: Text(
                              '${thousandsSeparatorsFormat(paidAmount)} MMK'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Flexible(
                          flex: 1,
                          child: Text('Change'),
                        ),
                        Flexible(
                          flex: 1,
                          child: Text(
                            '${thousandsSeparatorsFormat(changeAmount)} MMK',
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
