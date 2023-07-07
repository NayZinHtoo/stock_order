import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:stock_pos/providers/stock_item_provider.dart';
import 'package:stock_pos/providers/stock_order_provider.dart';
import 'package:stock_pos/screens/custom_search_delegate.dart';
import 'package:stock_pos/screens/order_payment_screen.dart';
import '../models/stock_header.dart';
import '../utils/constant.dart';

class StockOrderCartScreen extends StatefulWidget {
  const StockOrderCartScreen(
      {super.key, required this.title, required this.syskey, this.slipNo = 0});

  final String title;
  final String syskey;
  final int? slipNo;

  @override
  State<StockOrderCartScreen> createState() => _StockOrderCartScreenState();
}

class _StockOrderCartScreenState extends State<StockOrderCartScreen> {
  late StockOrderProvider stockOrderProvider;
  late StockProvider stockProvider;
  late StockHeader stockHeader;

  late double _totalAmount = 0.0;
  late String _parentId = '';
  late int _slipNo = 0;

  //late List<StockDetail> previousStockDetailList;
  //late List<StockDetail> removedStockDetailList;

  @override
  void initState() {
    stockOrderProvider =
        Provider.of<StockOrderProvider>(context, listen: false);
    stockProvider = Provider.of<StockProvider>(context, listen: false);
    stockProvider.getStockItem();
    if (widget.syskey.isNotEmpty) {
      stockOrderProvider.getStockOrderDetilList(widget.syskey);
      _parentId = widget.syskey;
      _slipNo = widget.slipNo!;
      //previousStockDetailList = stockOrderProvider.stockDetailList;
    }
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
            if (stockOrderProvider.stockDetailList.isNotEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Warning"),
                    content: const Text(
                        "Are you sure you wish to discard your order item(s)?"),
                    actions: <Widget>[
                      ElevatedButton(
                          onPressed: () {
                            stockOrderProvider.clearData();
                            Navigator.of(context).pop(true);
                            Navigator.pop(context);
                          },
                          child: const Text("Disard")),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Cancel"),
                      ),
                    ],
                  );
                },
              );
            } else {
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.close),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(
                      stockItemList: stockProvider.stockItemList));
            },
            icon: const Icon(Icons.search),
          ),
        ],
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
                      'SALE ITEMS',
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
                                      // for (var stockDetail
                                      //     in previousStockDetailList) {
                                      //   if (stockOrderProvider
                                      //           .stockDetailList[index]
                                      //           .stkId! ==
                                      //       stockDetail.id) {
                                      //     removedStockDetailList
                                      //         .add(stockDetail);
                                      //   }
                                      // }
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
                                                  subtitle: Text(
                                                    '${thousandsSeparatorsFormat(provider.stockDetailList[index].stkprice!)}MMK',
                                                  ),
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
                                                  '${thousandsSeparatorsFormat(provider.stockDetailList[index].amount!)}MMK',
                                                ),
                                              ),
                                            ),
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
                            'No Sale Items',
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
                          child: Text(
                              '${thousandsSeparatorsFormat(provider.totalAmount)}MMK'),
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
                        ? () async {
                            _totalAmount = provider.totalAmount;
                            if (_parentId.isEmpty) {
                              stockHeader = await provider.orderStockItem(
                                  stockOrderProvider.stockDetailList);
                              _parentId = stockHeader.syskey!;
                              _slipNo = stockHeader.slipNumber!;
                              //stockProvider.getStockItem();
                            } else {
                              await provider.updateSaleStockItem(
                                  stockOrderProvider.stockDetailList,
                                  _parentId);
                            }
                            stockProvider.resetStockItemSelected();
                            showToast();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderPaymentSreen(
                                        pid: _parentId,
                                        slipNo: _slipNo,
                                        totalAmount: _totalAmount,
                                      )),
                            );
                            //Navigator.pop(context);
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
