import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      ],
      child: MaterialApp(
        title: 'Stock Pos',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF004E53),
          scaffoldBackgroundColor: Colors.white,
          cardColor: Colors.white,
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: const Color(0xff02432e)),
        ),
        home: StockListScreen(title: 'Stock Pos'),
      ),
    );
  }
}
