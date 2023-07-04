import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/stock_detail.dart';
import '../models/stock_item.dart';
import '../providers/stock_item_provider.dart';
import '../providers/stock_order_provider.dart';
import '../utils/constant.dart';

class StockIemDetailScreen extends StatefulWidget {
  final StockItem? stockItem;
  const StockIemDetailScreen({super.key, required this.stockItem});

  @override
  State<StockIemDetailScreen> createState() => _StockIemDetailScreenState();
}

class _StockIemDetailScreenState extends State<StockIemDetailScreen> {
  late StockOrderProvider stockOrderProvider;
  StockItem? stockItem;
  @override
  Widget build(BuildContext context) {
    stockOrderProvider =
        Provider.of<StockOrderProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text('${widget.stockItem?.name}'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Consumer<StockProvider>(builder: (context, provider, _) {
              stockItem = widget.stockItem;
              return Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
                //color: Colors.grey.withOpacity(0.5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        '${stockItem!.image}',
                        height: 250,
                        width: double.maxFinite,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 16),
                      decoration: BoxDecoration(
                          color: const Color(0xFFF2FDFF),
                          borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${stockItem!.name}',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Text(
                            '${stockItem!.description}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: stockItem?.isSlelected == true
                            ? Theme.of(context).colorScheme.error
                            : AppColor.greenColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: stockItem?.isSlelected == true
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'REMOVE',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          : const Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'ADD',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Icon(
                                  Icons.shopping_cart_sharp,
                                  size: 17,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                      onPressed: () {
                        provider.setStockItemSelected(
                          stockItem!.id!,
                        );
                        if (stockItem!.isSlelected) {
                          var syskey = generatesyskey();
                          final StockDetail stockDetail = StockDetail(
                              syskey: syskey,
                              stkId: stockItem!.id,
                              stkName: stockItem!.name,
                              qty: 1,
                              stkprice: stockItem!.price,
                              amount: stockItem!.price,
                              status: 0);
                          stockOrderProvider.addStockOrderItem(stockDetail);
                        } else {
                          stockOrderProvider
                              .removeStockOrderItem(stockItem!.id!);
                        }
                      },
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
