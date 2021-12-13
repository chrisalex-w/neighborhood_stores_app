import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  final String? id;
  final String? name;
  final String? category;
  final String? address;
  final GeoPoint? location;
  final String? landline;
  final String? cellphone;
  final String? website;
  final String? imageLogoUrl;

  Store({
    this.id,
    this.name,
    this.category,
    this.address,
    this.location,
    this.landline,
    this.cellphone,
    this.website,
    this.imageLogoUrl,
  });
}