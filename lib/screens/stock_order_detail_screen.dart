import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pos/models/stock_header.dart';

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

  @override
  void initState() {
    stockOrderViewProvider =
        Provider.of<StockOrderViewProvider>(context, listen: false);

    stockOrderViewProvider.getStockDetailList(widget.stockHeader.syskey!);

    super.initState();
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
              padding: EdgeInsets.all(16.0),
              child: Text(
                  '---------------------------------------------------------------'),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
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
                        // const SizedBox(
                        //   width: 150,
                        // ),
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
                        // const SizedBox(
                        //   width: 100,
                        // ),
                        Flexible(
                          flex: 1,
                          child: Text(
                              '${thousandsSeparatorsFormat(widget.stockHeader.amount!)} MMK'),
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
