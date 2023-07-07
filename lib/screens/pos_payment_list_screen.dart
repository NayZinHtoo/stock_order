import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pos/providers/pos_payment_provider.dart';
import 'package:stock_pos/screens/pos_payment_setup_screen.dart';

import '../utils/constant.dart';

class POSPaymentListScreen extends StatefulWidget {
  const POSPaymentListScreen({super.key});

  @override
  State<POSPaymentListScreen> createState() => _POSPaymentListScreenState();
}

class _POSPaymentListScreenState extends State<POSPaymentListScreen> {
  @override
  void initState() {
    final provider = Provider.of<PosPaymentProvider>(context, listen: false);
    provider.getAllPaymentList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Payment List'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Consumer<PosPaymentProvider>(
              builder: (context, provider, _) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: provider.paymentList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          provider.removePosPayment(
                              provider.paymentList.toList()[index].id!);
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
                          elevation: 2,
                          // margin: const EdgeInsets.symmetric(
                          //   vertical: 5,
                          // ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${provider.paymentList[index].id}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  '${provider.paymentList[index].desc}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              POSPaymentSetupScreen(
                                                  posPayment: provider
                                                      .paymentList[index])),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const POSPaymentSetupScreen()),
          );
        },
        backgroundColor: AppColor.greenColor,
        tooltip: 'Order',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
