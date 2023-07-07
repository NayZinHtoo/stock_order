import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pos/screens/order_payment_screen.dart';
import 'package:stock_pos/screens/stock_order_cart_screen.dart';
import '../screens/stock_order_detail_screen.dart';

import '../providers/stock_order_view_provider.dart';
import '../utils/constant.dart';

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
        title: const Text('Sale List'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: () {
              stockOrderViewProvider.getStockHeaderList();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
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
                    'No Sale Data',
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
                    child: Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.horizontal,
                      onDismissed: (direction) {
                        provider
                            .removeStockHeader(provider.stockHeaderList[index]);
                      },
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirm"),
                              content: const Text(
                                  "Are you sure you wish to delete this item?"),
                              actions: <Widget>[
                                ElevatedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text("Yes")),
                                ElevatedButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("No"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      background: Container(
                        decoration: ShapeDecoration(
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20.0),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.delete_sweep, color: Colors.white),
                            Text(
                              'Delete',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(
                                  'System Key: ${provider.stockHeaderList[index].syskey}'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Text(
                                        'SlipNumber : ${provider.stockHeaderList[index].slipNumber}'),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Text(
                                      'Amount: ${thousandsSeparatorsFormat(provider.stockHeaderList[index].amount!)} MMK',
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                      'Date: ${provider.stockHeaderList[index].date}'),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                      '${provider.stockHeaderList[index].time}'),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ElevatedButton(
                                    onPressed: provider.stockHeaderList[index]
                                                .status ==
                                            1
                                        ? () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    StockOrderCartScreen(
                                                  title: 'Sale Stock',
                                                  syskey:
                                                      '${provider.stockHeaderList[index].syskey}',
                                                ),
                                              ),
                                            );
                                          }
                                        : null,
                                    child: const Text('Add other items'),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: provider.stockHeaderList[index]
                                                .status ==
                                            1
                                        ? () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderPaymentSreen(
                                                        pid:
                                                            '${provider.stockHeaderList[index].syskey}',
                                                        slipNo: provider
                                                            .stockHeaderList[
                                                                index]
                                                            .slipNumber!,
                                                        totalAmount: provider
                                                            .stockHeaderList[
                                                                index]
                                                            .amount!,
                                                      )),
                                            );
                                          }
                                        : null,
                                    child: const Text('Bill Payment'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StockOrderCartScreen(
                title: 'Sale Stock',
                syskey: '',
              ),
            ),
          );
        },
        backgroundColor: AppColor.greenColor,
        tooltip: 'Order Stock',
        child: const Icon(
          Icons.shopping_cart,
          color: Colors.white,
        ),
      ),
    );
  }
}
