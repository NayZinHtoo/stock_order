import 'dart:convert';
import 'dart:typed_data';

import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pos/providers/stock_order_provider.dart';
import 'package:stock_pos/screens/pos_payment_list_screen.dart';
import 'package:stock_pos/screens/pos_payment_setup_screen.dart';
import 'package:stock_pos/screens/stock_item_add_screen.dart';
import 'package:stock_pos/screens/stock_item_detail_screen.dart';
import 'package:stock_pos/screens/stock_order_cart_screen.dart';
import 'package:stock_pos/screens/stock_order_header_list_screen.dart';
import '../providers/stock_item_provider.dart';
import '../utils/constant.dart';

class StockListScreen extends StatefulWidget {
  const StockListScreen({super.key, required this.title});

  final String title;

  @override
  State<StockListScreen> createState() => _StockListScreenState();
}

class _StockListScreenState extends State<StockListScreen> {
  late StockProvider stockProvider;
  late StockOrderProvider stockOrderProvider;
  final TextEditingController _controller = TextEditingController();

  String? selectedCategory;
  final List<String> categories = [
    'All',
    'Food',
    'Drink',
  ];

  _StockListScreenState() {
    selectedCategory = categories.first;
  }

  @override
  void initState() {
    stockProvider = Provider.of<StockProvider>(context, listen: false);
    // stockOrderProvider =
    //     Provider.of<StockOrderProvider>(context, listen: false);
    stockProvider.getStockItem();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: AppColor.greenColor,
              ),
              accountName: const Text("Sale Admin"),
              accountEmail: const Text("testing@mit.co"),
              currentAccountPicture: CircleAvatar(
                child: Image.asset('assets/person.png'),
              ),
            ),
            ExpansionTile(
              title: const Text('Stock'),
              childrenPadding: const EdgeInsets.all(16),
              children: [
                ListTile(
                  title: const Text('List'),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const POSPaymentListScreen()),
                    // );
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('New'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddStockItemScreen()),
                    );
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Payment'),
              childrenPadding: const EdgeInsets.all(16),
              children: [
                ListTile(
                  title: const Text('List'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const POSPaymentListScreen()),
                    );
                  },
                ),
                ListTile(
                  title: const Text('New'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const POSPaymentSetupScreen()),
                    );
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Sale Stock'),
              childrenPadding: const EdgeInsets.all(16),
              children: [
                ListTile(
                  title: const Text('List'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StockHeaderListScreen()),
                    );
                  },
                ),
                ListTile(
                  title: const Text('New'),
                  onTap: () {
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
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                    flex: 1,
                    child: TextFormField(
                      controller: _controller,
                      textCapitalization: TextCapitalization.words,
                      onChanged: (value) {
                        stockProvider.filterSearchResults(
                            value, selectedCategory!);
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        hintText: 'Search',
                        prefixIcon: InkWell(
                            child: Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: 22,
                        )),
                      ),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ChipsChoice<String>.single(
                  padding: const EdgeInsets.all(4),
                  value: selectedCategory,
                  onChanged: (value) {
                    if (value == "All") {
                      stockProvider.getAllStockItem();
                    } else {
                      stockProvider.getStockItemByCategory(value);
                    }
                    setState(() => selectedCategory = value);
                  },
                  choiceStyle: C2ChipStyle.outlined(
                    foregroundStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    backgroundColor: Colors.white,
                    elevation: 1.0,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                    selectedStyle: const C2ChipStyle(
                      foregroundStyle: TextStyle(color: Colors.white),
                      backgroundColor: AppColor.greenColor,
                      backgroundOpacity: 1.0,
                    ),
                  ),
                  choiceItems: C2Choice.listFrom<String, String>(
                    source: categories,
                    value: (i, v) => v,
                    label: (i, v) => v,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                'Stocks Items',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ]),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xFFF2FDFF),
                  borderRadius: BorderRadius.circular(16)),
              height: double.maxFinite,
              width: double.maxFinite,
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Swipe left to delete item',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.grey),
                  ),
                  Consumer<StockProvider>(
                    builder: (context, provider, _) {
                      if (provider.stockItemList.isNotEmpty) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemCount: provider.stockItemList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            StockIemDetailScreen(
                                                stockItem: provider
                                                    .stockItemList
                                                    .toList()[index]),
                                      ),
                                    );
                                  },
                                  child: Dismissible(
                                    key: UniqueKey(),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) {
                                      provider.removeStockItem(provider
                                          .stockItemList
                                          .toList()[index]);
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
                                      elevation: 8,
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image.memory(
                                                Uint8List.fromList(base64.decode(
                                                    '${provider.stockItemList[index].image}')),
                                                height: 100,
                                                width: 100,
                                                fit: BoxFit.cover,
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${provider.stockItemList[index].id}',
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${provider.stockItemList[index].name}',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '    ${provider.stockItemList[index].description}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                      Text(
                                                        '${thousandsSeparatorsFormat(provider.stockItemList[index].price!)} MMK',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ]),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        //return const Center(child: CircularProgressIndicator());
                        return const Expanded(
                            child: Center(
                                child: Text(
                          'No Data',
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
        ],
      ),
      // floatingActionButton: Consumer<StockOrderProvider>(
      //   builder: (context, provider, _) {
      //     return Badge(
      //       alignment: AlignmentDirectional.topEnd,
      //       isLabelVisible: provider.stockDetailList.isEmpty ? false : true,
      //       label: Text('${provider.stockDetailList.length}'),
      //       child: FloatingActionButton(
      //         onPressed: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => const StockOrderCartScreen(
      //                 title: 'Sale Stock',
      //                 syskey: '',
      //               ),
      //             ),
      //           );
      //         },
      //         backgroundColor: AppColor.greenColor,
      //         tooltip: 'Order',
      //         child: const Icon(
      //           Icons.shopping_cart,
      //           color: Colors.white,
      //         ),
      //       ),
      //     );
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddStockItemScreen()),
          );
        },
        backgroundColor: AppColor.greenColor,
        tooltip: 'Add Stock',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
