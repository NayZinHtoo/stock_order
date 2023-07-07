class StockItem {
  int? id;
  String? name;
  String? description;
  double? price;
  String? category;
  String? image;
  int? status = 0;
  bool isSlelected;

  StockItem({
    this.id,
    this.name,
    this.description,
    this.price,
    this.category,
    this.image,
    this.status,
    this.isSlelected = false,
  });

  StockItem.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        name = result["name"],
        description = result["description"],
        price = result["price"],
        category = result["category"],
        image = result["image"],
        status = result["status"],
        isSlelected = false;

  Map<String, Object> toMap() {
    return {
      'name': name!,
      'description': description!,
      'price': price!,
      'category': category!,
      'image': image!,
      'status': status!,
    };
  }
}
