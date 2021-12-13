import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neighborhood_stores_app/models/product.dart';
import 'package:neighborhood_stores_app/models/store.dart';

class Order {
  final Timestamp? timestamp;
  final Store store;
  final int quantity;
  final int total;
  String? delivery;
  List<Product>? products;

  Order({
    this.timestamp,
    required this.store,
    required this.quantity,
    required this.total,
    this.delivery,
    this.products,
  });
}