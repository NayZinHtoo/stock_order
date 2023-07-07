import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/stock_item.dart';
import '../providers/stock_add_provider.dart';
import '../providers/stock_item_provider.dart';

class AddStockItemScreen extends StatefulWidget {
  final StockItem? stockItem;
  const AddStockItemScreen({super.key, this.stockItem});

  @override
  State<AddStockItemScreen> createState() => _AddStockItemScreenState();
}

class _AddStockItemScreenState extends State<AddStockItemScreen> {
  final _stockNamecontroller = TextEditingController();
  final _stockDesccontroller = TextEditingController();
  final _stockPriceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String btnString = 'Save';
  String? category = 'Food';
  var categories = [
    'Food',
    'Drink',
  ];
  File? image;
  String? imageString;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      imagetoByteSting(imageTemp);
      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future imagetoByteSting(File imageFile) async {
    try {
      Uint8List imagebytes = await imageFile.readAsBytes(); //convert to bytes
      String base64string =
          base64.encode(imagebytes); //convert bytes to base64 string
      setState(() => imageString = base64string);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future saveStockItem(BuildContext context) async {
    final stockProvider = Provider.of<StockProvider>(context, listen: false);
    final stockAddProvider =
        Provider.of<StockAddProvider>(context, listen: false);
    if (imageString == null || imageString == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose Image')),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      if (btnString == 'Save') {
        var stockItem = StockItem(
          name: _stockNamecontroller.text,
          description: _stockDesccontroller.text,
          price: double.parse(_stockPriceController.text),
          category: category,
          image: imageString,
          status: 0,
        );
        var id = await stockAddProvider.addStockItem(stockItem);
        stockItem.id = id;
        stockProvider.addStockItem(stockItem);
      } else {
        var stockItem = StockItem(
          id: widget.stockItem?.id,
          name: _stockNamecontroller.text,
          description: _stockDesccontroller.text,
          price: double.parse(_stockPriceController.text),
          category: category,
          image: imageString,
          status: 0,
        );
        stockProvider.updateStockItem(stockItem);
      }
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  void initState() {
    final name = widget.stockItem != null ? widget.stockItem?.name : '';
    final desc = widget.stockItem != null ? widget.stockItem?.description : '';
    final price = widget.stockItem != null ? '${widget.stockItem?.price}' : '';

    btnString = widget.stockItem != null ? 'Update' : 'Save';
    _stockNamecontroller.text = name!;
    _stockDesccontroller.text = desc!;
    _stockPriceController.text = price;
    category = widget.stockItem != null ? widget.stockItem?.category : 'Food';
    imageString = widget.stockItem != null ? widget.stockItem?.image : '';
    super.initState();
  }

  @override
  void dispose() {
    widget.stockItem?.description;
    _stockNamecontroller.dispose();
    _stockDesccontroller.dispose();
    _stockPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('ADD ITEMS'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Stock name"),
                TextFormField(
                  controller: _stockNamecontroller,
                  decoration: const InputDecoration(
                    hintText: 'Enter stock name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Please enter stock name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                const Text("Stock description"),
                TextFormField(
                  controller: _stockDesccontroller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Please enter stock description';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter stock description',
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 18),
                const Text("Stock Price"),
                TextFormField(
                  controller: _stockPriceController,
                  decoration: const InputDecoration(
                    hintText: 'Enter stock price',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Please enter stock price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                const Text("Category"),
                DropdownButtonFormField(
                  value: category,
                  decoration: const InputDecoration(),
                  icon: const Icon(
                    Icons.arrow_drop_down_sharp,
                    size: 30,
                    textDirection: TextDirection.rtl,
                  ),
                  items: categories.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      category = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.image,
                          color: Colors.white,
                        ),
                        Text(
                          "image",
                          style: TextStyle(color: Colors.white),
                        ),
                      ]),
                  onPressed: () {
                    pickImage();
                  },
                ),
                const SizedBox(height: 18),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: imageString!.isNotEmpty
                        ? Center(
                            child: Image.memory(
                              Uint8List.fromList(base64.decode('$imageString')),
                              height: 250,
                              width: double.maxFinite,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Text('*Please select an image'),
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        btnString,
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  onPressed: () {
                    saveStockItem(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
