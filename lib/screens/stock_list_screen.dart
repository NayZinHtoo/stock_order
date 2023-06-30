import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pos/models/stock_detail.dart';
import 'package:stock_pos/providers/stock_order_provider.dart';
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
    stockOrderProvider =
        Provider.of<StockOrderProvider>(context, listen: false);
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StockHeaderListScreen()),
              );
            },
            icon: const Icon(Icons.list),
          ),
        ],
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
                  Consumer<StockProvider>(
                    builder: (context, provider, _) {
                      if (provider.stockItemList.isNotEmpty) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemCount: provider.stockItemList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  elevation: 8,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(children: [
                                      Image.asset(
                                        '${provider.stockItemList[index].image}',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.fill,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '${provider.stockItemList[index].id}'),
                                              Text(
                                                  '${provider.stockItemList[index].name}'),
                                              Text(
                                                '${provider.stockItemList[index].description}',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                              ),
                                              Text(
                                                '${provider.stockItemList[index].price} MMK',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColor.greenColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                                child: provider
                                                            .stockItemList[
                                                                index]
                                                            .isSlelected ==
                                                        true
                                                    ? const Text(
                                                        'REMOVE',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    : const Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'ADD',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          SizedBox(
                                                            width: 5.0,
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .shopping_cart_sharp,
                                                            size: 17,
                                                            color: Colors.white,
                                                          ),
                                                        ],
                                                      ),
                                                onPressed: () {
                                                  provider.setStockItemSelected(
                                                    provider
                                                        .stockItemList[index]
                                                        .id!,
                                                  );
                                                  if (provider
                                                      .stockItemList[index]
                                                      .isSlelected) {
                                                    final StockDetail
                                                        stockDetail =
                                                        StockDetail(
                                                            stkId: provider
                                                                .stockItemList[
                                                                    index]
                                                                .id,
                                                            stkName: provider
                                                                .stockItemList[
                                                                    index]
                                                                .name,
                                                            qty: 1,
                                                            stkprice: provider
                                                                .stockItemList[
                                                                    index]
                                                                .price,
                                                            amount: provider
                                                                .stockItemList[
                                                                    index]
                                                                .price,
                                                            status: 0);
                                                    stockOrderProvider
                                                        .addStockOrderItem(
                                                            stockDetail);
                                                  } else {
                                                    stockOrderProvider
                                                        .removeStockOrderItem(
                                                            provider
                                                                .stockItemList[
                                                                    index]
                                                                .id!);
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ]),
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
      floatingActionButton:
          Consumer<StockOrderProvider>(builder: (context, provider, _) {
        return Badge(
          alignment: AlignmentDirectional.topEnd,
          isLabelVisible: provider.stockDetailList.isEmpty ? false : true,
          label: Text('${provider.stockDetailList.length}'),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const StockOrderCartScreen(title: 'Order Cart')),
              );
            },
            backgroundColor: AppColor.greenColor,
            tooltip: 'Order',
            child: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          ),
        );
      }),
    );
  }
}
