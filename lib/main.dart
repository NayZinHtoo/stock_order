import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pos/providers/pos_payment_provider.dart';
import 'package:stock_pos/providers/stock_add_provider.dart';
import 'package:stock_pos/providers/stock_order_payment_provider.dart';
import 'package:stock_pos/utils/color_schemes.g.dart';
import '../providers/stock_item_provider.dart';
import '../screens/stock_list_screen.dart';
import '../providers/stock_order_provider.dart';
import '../providers/stock_order_view_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: StockProvider()),
        ChangeNotifierProvider.value(value: StockOrderProvider()),
        ChangeNotifierProvider.value(value: StockOrderViewProvider()),
        ChangeNotifierProvider.value(value: PosPaymentProvider()),
        ChangeNotifierProvider.value(value: StockOrderPaymentProvider()),
        ChangeNotifierProvider.value(value: StockAddProvider()),
      ],
      child: MaterialApp(
        title: 'Stock Pos',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
            inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(width: 0, color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(width: 0, color: Colors.white),
              ),
              filled: true,
              fillColor: lightColorScheme.surfaceVariant,
              border: InputBorder.none,
            )),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        home: const StockListScreen(title: 'ITEMS'),
      ),
    );
  }
}
