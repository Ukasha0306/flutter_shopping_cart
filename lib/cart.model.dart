class Cart {
  late final int? id;
  final String? productId;
  final String? productName;
  final String? image;
  final String? unitTag;
  final int? initialPrice;
  final int? finalPrice;
  final int? quantity;

  Cart({
    required this.id,
    required this.productName,
    required this.image,
    required this.productId,
    required this.finalPrice,
    required this.initialPrice,
    required this.unitTag,
    required this.quantity,
  });

  Cart.fromMap(Map<dynamic, dynamic> res)
      : id = res['id'],
        productId = res["productId"],
        productName = res["productName"],
        image = res["image"],
        initialPrice = res["initialPrice"],
        finalPrice = res["finalPrice"],
        unitTag = res["unitTag"],
        quantity = res['quantity'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'image': image,
      'initialPrice': initialPrice,
      'finalPrice': finalPrice,
      'unitTag': unitTag,
      'quantity': quantity,
    };
  }
}
