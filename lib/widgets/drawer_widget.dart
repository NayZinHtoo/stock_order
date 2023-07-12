import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock_pos/screens/stock_list_screen.dart';

import '../screens/pos_payment_list_screen.dart';
import '../screens/pos_payment_setup_screen.dart';
import '../screens/stock_item_add_screen.dart';
import '../screens/stock_order_header_list_screen.dart';
import '../utils/constant.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const StockListScreen(title: 'ITEMS')),
                  );
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
            title: const Text('Sale'),
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
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
