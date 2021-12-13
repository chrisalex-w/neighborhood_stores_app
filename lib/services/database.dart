import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neighborhood_stores_app/models/order.dart';
import 'package:neighborhood_stores_app/models/product.dart';
import 'package:neighborhood_stores_app/models/store.dart';
import 'package:neighborhood_stores_app/models/user.dart';

class DatabaseService {

  final String? userId;
  DocumentSnapshot? _lastDocument;

  DatabaseService({
    this.userId,
  });

  final CollectionReference userCollection = FirebaseFirestore
      .instance.collection('users');

  final Query productCollections = FirebaseFirestore
      .instance.collectionGroup('products');

  final CollectionReference cartCollection = FirebaseFirestore
      .instance.collection('shopping_cart');

  final CollectionReference storeCollection = FirebaseFirestore
      .instance.collection('stores');

  Future updateUserData(UserData userData) async {
    return await userCollection.doc(userId).set({
      'name': userData.name,
      'address': userData.address,
      'landline': userData.landline,
      'cellphone': userData.cellphone,
    });
  }

  Future getUserData(String? userId) async {
    DocumentSnapshot snapshot = await userCollection
        .doc(userId).get();

    return UserData(
      name: snapshot.get('name'),
      address: snapshot.get('address'),
      landline: snapshot.get('landline'),
      cellphone: snapshot.get('cellphone'),
    );
  }

  Future deleteUserData() async {
    return await userCollection.doc(userId).delete();
  }

  Future getStores(String category) async {
    QuerySnapshot snapshot;

    if (category.isEmpty) {
      snapshot = await storeCollection
          .orderBy('name')
          .get();

    } else {
      snapshot = await storeCollection
          .where('category', isEqualTo: category)
          .orderBy('name')
          .get();
    }

    return snapshot.docs.map((doc) =>
        _storeFromSnapshot(doc, false)).toList();
  }

  Future getProductsFromHome(int itemsPerPage) async {
    QuerySnapshot snapshot = await productCollections
        .orderBy('name')
        .limit(itemsPerPage)
        .get();

    _lastDocument = snapshot.docs[snapshot.docs.length - 1];

    return snapshot.docs.map((doc) {
      return Product(
        id: doc.get('id'),
        name: doc.get('name') ?? '',
        price: doc.get('price') ?? 0,
        store: _storeFromSnapshot(doc, true),
      );
    }).toList();
  }

  Future getMoreProductsFromHome(
      int itemsPerPage,
      Function(bool) moreProductsAvailable,
      Function(bool) isLoadingMoreProducts) async {

    isLoadingMoreProducts(true);

    QuerySnapshot snapshot = await productCollections
        .orderBy('name')
        .startAfter([_lastDocument?.get('name')])
        .limit(itemsPerPage)
        .get();

    if (snapshot.docs.length < itemsPerPage) {
      moreProductsAvailable(false);
      if (snapshot.docs.isEmpty) return;
    }

    _lastDocument = snapshot.docs[snapshot.docs.length - 1];

    List<Product> products =  snapshot.docs.map((doc) {
      return Product(
        id: doc.get('id') ?? '',
        productId: doc.get('store')['productId'],
        name: doc.get('name') ?? '',
        price: doc.get('price') ?? 0,
        store: _storeFromSnapshot(doc, true),
      );
    }).toList();

    isLoadingMoreProducts(false);
    return products;
  }

  Future searchStore(String name, String category) async {
    QuerySnapshot snapshot;

    if (category.isEmpty) {
      snapshot = await storeCollection
          .orderBy('name')
          .startAt([name])
          .endAt([name + '\uf8ff'])
          .get();

    } else {
      snapshot = await storeCollection
          .where('category', isEqualTo: category)
          .orderBy('name')
          .startAt([name])
          .endAt([name + '\uf8ff'])
          .get();
    }

    return snapshot.docs.map((doc) {
      return _storeFromSnapshot(doc, false);
    }).toList();
  }

  Future searchProduct(String name) async {
    QuerySnapshot snapshot = await productCollections
        .orderBy('name')
        .startAt([name]).endAt([name + '\uf8ff'])
        .get();

    return snapshot.docs.map((doc) {
      return Product(
        id: doc.get('id') ?? '',
        productId: doc.get('store')['productId'],
        name: doc.get('name') ?? '',
        price: doc.get('price') ?? 0,
        quantity: 0,
        store: _storeFromSnapshot(doc, true),
      );
    }).toList();
  }

  Future getShoppingCart(String? userId) async {
    QuerySnapshot snapshot = await userCollection
        .doc(userId).collection('shopping_cart').get();

    await Future.delayed(const Duration(milliseconds: 300));

    return snapshot.docs.map((doc) {
      return Product(
        id: doc.id,
        productId: doc.get('productId'),
        name: doc.get('product') ?? '',
        price: doc.get('price') ?? 0,
        quantity: doc.get('quantity') ?? 0,
        store: _storeFromSnapshot(doc, true),
      );
    }).toList();
  }

  Future updateShoppingCart(String userId, Product product) async {
    await FirebaseFirestore.instance
        .collection('users/$userId/shopping_cart')
        .doc(product.id)
        .set({
      'id': product.id,
      'productId': product.productId,
      'product': product.name,
      'price': product.price,
      'quantity': product.quantity,
      'store': {
        'id': product.store.id,
        'name': product.store.name,
        'category': product.store.category,
        'address': product.store.address,
        'location': product.store.location,
        'landline': product.store.landline,
        'cellphone': product.store.cellphone,
        'website': product.store.website,
        'logo': product.store.imageLogoUrl,
      }
    });
  }

  Future removeFromShoppingCart(String userId, Product product) async {
    FirebaseFirestore.instance
        .collection('users/$userId/shopping_cart')
        .doc(product.id)
        .delete();
  }

  String getNextCartProductId(userId) {
    return FirebaseFirestore.instance
        .collection('users/$userId/shopping_cart')
        .doc()
        .id;
  }

  Future getProductsFromStore(String? storeName, int itemsPerPage) async {
    QuerySnapshot snapshot1 = await storeCollection
        .where('name', isEqualTo: storeName)
        .get();

    QuerySnapshot snapshot2 = await FirebaseFirestore.instance
        .collection('stores/${snapshot1.docs.single.id}/products')
        .orderBy('name')
        .limit(itemsPerPage)
        .get();

    _lastDocument = snapshot2.docs[snapshot2.docs.length - 1];

    return snapshot2.docs.map((doc) {
      return Product(
        id: doc.id,
        name: doc.get('name') ?? '',
        price: doc.get('price') ?? 0,
        store: _storeFromSnapshot(doc, true),
      );
    }).toList();
  }

  Future getMoreProductsFromStore(
      int itemsPerPage,
      String? storeName,
      Function(bool) moreProductsAvailable,
      Function(bool) isLoadingMoreProducts) async {

    isLoadingMoreProducts(true);

    QuerySnapshot snapshot1 = await FirebaseFirestore.instance
        .collection('stores')
        .where('name', isEqualTo: storeName)
        .get();

    QuerySnapshot snapshot2 = await FirebaseFirestore.instance
        .collection('stores/${snapshot1.docs.single.id}/products')
        .orderBy('name')
        .startAfter([_lastDocument!.get('name')])
        .limit(itemsPerPage)
        .get();

    if (snapshot2.docs.length < itemsPerPage) {
      moreProductsAvailable(false);
      if (snapshot2.docs.isEmpty) return;
    }

    _lastDocument = snapshot2.docs[snapshot2.docs.length - 1];

    List<Product> products =  snapshot2.docs.map((doc) {
      return Product(
        id: doc.get('id') ?? '',
        productId: doc.get('store')['productId'],
        name: doc.get('name') ?? '',
        price: doc.get('price') ?? 0,
        store: _storeFromSnapshot(doc, true),
      );
    }).toList();

    isLoadingMoreProducts(false);
    return products;
  }

  Future addOrder(String userId, Order order) async {
    await FirebaseFirestore.instance
        .collection('users/$userId/orders')
        .add({
      'date': order.timestamp,
      'store': {
        'id': order.store.id,
        'name': order.store.name,
        'category': order.store.category,
        'address': order.store.address,
        'location': order.store.location,
        'landline': order.store.landline,
        'cellphone': order.store.cellphone,
        'website': order.store.website,
        'logo': order.store.imageLogoUrl,
      },
      'quantity': order.quantity,
      'total': order.total,
      'delivery': order.delivery,
    });
  }

  Future getOrders(String userId) async {
    QuerySnapshot snapshot = await userCollection
        .doc(userId).collection('orders')
        .get();

    return snapshot.docs.map((doc) {
      return Order(
        timestamp: doc.get('date'),
        store: _storeFromSnapshot(doc, true),
        quantity: doc.get('quantity'),
        total: doc.get('total'),
        delivery: doc.get('delivery'),
      );
    }).toList();
  }

  Store _storeFromSnapshot(DocumentSnapshot snapshot, bool isField) {
    if (isField) {
      return Store(
        id: snapshot.get('store')['id'],
        name: snapshot.get('store')['name'],
        category: snapshot.get('store')['category'],
        address: snapshot.get('store')['address'],
        location: snapshot.get('store')['location'],
        landline: snapshot.get('store')['landline'],
        cellphone: snapshot.get('store')['cellphone'],
        website: snapshot.get('store')['website'],
        imageLogoUrl: snapshot.get('store')['logo'],
      );
    } else {
      return Store(
        id: snapshot.get('id'),
        name: snapshot.get('name'),
        category: snapshot.get('category'),
        address: snapshot.get('address'),
        location: snapshot.get('location'),
        landline: snapshot.get('landline'),
        cellphone: snapshot.get('cellphone'),
        website: snapshot.get('website'),
        imageLogoUrl: snapshot.get('logo'),
      );
    }
  }
}