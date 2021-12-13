import 'package:neighborhood_stores_app/models/store.dart';

class Product {
  final String? id;
  final String? productId;
  final String? name;
  final int? price;
  int? quantity;
  int? totalValue;
  final Store store;

  Product({
    this.id,
    this.productId,
    this.name,
    this.price,
    this.quantity,
    this.totalValue,
    required this.store,
  });
}