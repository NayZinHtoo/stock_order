import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:stock_pos/providers/stock_item_provider.dart';
import 'package:stock_pos/providers/stock_order_provider.dart';
import '../utils/constant.dart';

class StockOrderCartScreen extends StatefulWidget {
  const StockOrderCartScreen({super.key, required this.title});

  final String title;

  @override
  State<StockOrderCartScreen> createState() => _StockOrderCartScreenState();
}

class _StockOrderCartScreenState extends State<StockOrderCartScreen> {
  late StockOrderProvider stockOrderProvider;
  late StockProvider stockProvider;

  @override
  void initState() {
    stockOrderProvider =
        Provider.of<StockOrderProvider>(context, listen: false);
    stockProvider = Provider.of<StockProvider>(context, listen: false);
    super.initState();
  }

  void showToast() {
    Fluttertoast.showToast(
        msg: 'Your order is confirmed',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Column(
          children: [
            Text(widget.title),
            const Icon(Icons.shopping_cart),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xFFF2FDFF),
                    borderRadius: BorderRadius.circular(16)),
                height: double.maxFinite,
                width: double.maxFinite,
                //padding: const EdgeInsets.all(8.0),
                //margin: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ORDER ITEMS',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.grey),
                    ),
                    Consumer<StockOrderProvider>(
                      builder: (context, provider, _) {
                        if (provider.stockDetailList.isNotEmpty) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: provider.stockDetailList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {},
                                  child: Dismissible(
                                    key: UniqueKey(),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) {
                                      stockProvider.setStockItemSelected(
                                          stockOrderProvider
                                              .stockDetailList[index].stkId!);
                                      stockOrderProvider.removeStockOrderItem(
                                          stockOrderProvider
                                              .stockDetailList[index].stkId!);
                                    },
                                    background: Container(
                                      decoration: ShapeDecoration(
                                        color: Colors.red,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                      ),
                                      alignment: Alignment.centerRight,
                                      padding:
                                          const EdgeInsets.only(right: 20.0),
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.delete_sweep,
                                              color: Colors.white),
                                          Text(
                                            'Delete',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    child: Card(
                                      elevation: 1,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Flexible(
                                                flex: 3,
                                                child: ListTile(
                                                  title: Text(provider
                                                          .stockDetailList
                                                          .toList()[index]
                                                          .stkName ??
                                                      ''),
                                                  subtitle: Text(provider
                                                          .stockDetailList
                                                          .toList()[index]
                                                          .stkName ??
                                                      ''),
                                                )),
                                            Flexible(
                                                flex: 3,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          stockOrderProvider
                                                              .qtyCalculate(
                                                                  index: index,
                                                                  isIncreased:
                                                                      false);
                                                        },
                                                        icon: const Icon(Icons
                                                            .chevron_left)),
                                                    Text(provider
                                                        .stockDetailList
                                                        .toList()[index]
                                                        .qty
                                                        .toString()),
                                                    IconButton(
                                                        onPressed: () {
                                                          stockOrderProvider
                                                              .qtyCalculate(
                                                                  index: index,
                                                                  isIncreased:
                                                                      true);
                                                        },
                                                        icon: const Icon(Icons
                                                            .chevron_right))
                                                  ],
                                                )),
                                            Flexible(
                                                flex: 2,
                                                child: SizedBox(
                                                    width: 150,
                                                    child: Text(
                                                        '${provider.stockDetailList.toList()[index].amount}MMK'))),
                                          ]),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return const Expanded(
                              child: Center(
                                  child: Text(
                            'No Order Items',
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          )));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Consumer<StockOrderProvider>(builder: (context, provider, _) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Flexible(
                          flex: 2,
                          child: Text('Summary'),
                        ),
                        Flexible(
                          flex: 2,
                          child: Text('${provider.totlalQty}'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Flexible(
                          flex: 2,
                          child: Text('Total Amount'),
                        ),
                        Flexible(
                          flex: 2,
                          child: Text('${provider.totalAmount} MMK'),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(8),
                      backgroundColor: AppColor.greenColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: provider.stockDetailList.isNotEmpty
                        ? () {
                            provider.orderStockItem(
                                stockOrderProvider.stockDetailList);
                            //stockProvider.getStockItem();
                            stockProvider.resetStockItemSelected();
                            showToast();
                            Navigator.pop(context);
                          }
                        : null,
                    child: const Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Confirm Order',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
