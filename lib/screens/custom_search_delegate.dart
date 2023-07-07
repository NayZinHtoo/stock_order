import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/stock_detail.dart';
import '../models/stock_item.dart';
import '../providers/stock_order_provider.dart';
import '../utils/constant.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<StockItem> stockItemList;
  CustomSearchDelegate({required this.stockItemList});
  late StockOrderProvider stockOrderProvider;

// first overwrite to
// clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

// second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_ios),
    );
  }

// third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<StockItem> matchQuery = [];
    for (var stockItem in stockItemList) {
      if ('${stockItem.id!}'.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(stockItem);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text('${result.id!}'),
          subtitle: Text(result.name!),
        );
      },
    );
  }

// last overwrite to show the
// querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<StockItem> matchQuery = [];
    stockOrderProvider =
        Provider.of<StockOrderProvider>(context, listen: false);
    for (var stockItem in stockItemList) {
      if ('${stockItem.id!}'.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(stockItem);
      }
    }
    return ListView.separated(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return InkWell(
          onTap: () {
            var syskey = generatesyskey();
            final StockDetail stockDetail = StockDetail(
                syskey: syskey,
                stkId: result.id,
                stkName: result.name,
                qty: 1,
                stkprice: result.price,
                amount: result.price,
                status: 0);
            stockOrderProvider.addStockOrderItem(stockDetail);
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${result.id}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  result.name!,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${thousandsSeparatorsFormat(result.price!)} MMK',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(
        color: Colors.green,
        thickness: 1,
      ),
    );
  }
}
