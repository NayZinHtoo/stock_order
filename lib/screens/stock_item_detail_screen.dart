import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pos/screens/stock_item_add_screen.dart';

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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddStockItemScreen(
                          stockItem: stockItem,
                        )),
              );
            },
            icon: const Icon(Icons.mode_edit_outlined),
          ),
        ],
        title: Text('${widget.stockItem?.name}'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Consumer<StockProvider>(builder: (context, provider, _) {
              final tempStockItem = provider.stockItemList
                  .where((item) => item.id == widget.stockItem!.id)
                  .toList()[0];
              //stockItem = widget.stockItem;
              stockItem = tempStockItem;
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
                      child: Image.memory(
                        Uint8List.fromList(
                            base64.decode('${stockItem!.image}')),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${stockItem!.name}',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              Text(
                                '${thousandsSeparatorsFormat(stockItem!.price!)} MMK',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
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
