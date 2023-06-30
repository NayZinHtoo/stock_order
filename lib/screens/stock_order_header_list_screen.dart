import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/stock_order_detail_screen.dart';

import '../providers/stock_order_view_provider.dart';

class StockHeaderListScreen extends StatefulWidget {
  const StockHeaderListScreen({super.key});

  @override
  State<StockHeaderListScreen> createState() => _StockHeaderListScreenState();
}

class _StockHeaderListScreenState extends State<StockHeaderListScreen> {
  late StockOrderViewProvider stockOrderViewProvider;

  @override
  void initState() {
    stockOrderViewProvider =
        Provider.of<StockOrderViewProvider>(context, listen: false);

    stockOrderViewProvider.getStockHeaderList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Stock Header'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Consumer<StockOrderViewProvider>(builder: (context, provider, _) {
        return provider.stockHeaderList.isEmpty
            ? Container(
                decoration: BoxDecoration(
                    color: const Color(0xFFF2FDFF),
                    borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.all(16),
                child: const Center(
                  child: Text(
                    'No Order Data',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              )
            : ListView.builder(
                itemCount: provider.stockHeaderList.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StockOrderDetailScreen(
                                  title: 'Order Detail',
                                  stockHeader: provider.stockHeaderList[index],
                                )),
                      );
                    },
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                      'SlipNumber : ${provider.stockHeaderList[index].slipNumber}'),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                    '${provider.stockHeaderList[index].amount} MMK',
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                    'Date: ${provider.stockHeaderList[index].date}'),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text('${provider.stockHeaderList[index].time}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
      }),
    );
  }
}
