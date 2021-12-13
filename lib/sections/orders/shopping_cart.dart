import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neighborhood_stores_app/models/order.dart';
import 'package:neighborhood_stores_app/models/product.dart';
import 'package:neighborhood_stores_app/sections/orders/payment.dart';
import 'package:neighborhood_stores_app/services/auth.dart';
import 'package:neighborhood_stores_app/services/database.dart';
import 'package:neighborhood_stores_app/shared/constants.dart';
import 'package:neighborhood_stores_app/shared/product_tile.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({Key? key}) : super(key: key);

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final AuthService _authService = AuthService();

  final ScrollController _scrollController;
  final DatabaseService _databaseService;

  String _userId = '';
  List<Product> _shoppingCart = [];
  Order? _order;

  bool _isLoadingCart = true;
  bool _isUpdatingCart = false;

  _ShoppingCartState() :
        _databaseService = DatabaseService(),
        _scrollController = ScrollController();

  _getShoppingCart() async {
    setState(() => _isLoadingCart = true);

    if (_authService.getCurrentUser() != null) {
      _userId = _authService.getCurrentUser()!.uid;
      _shoppingCart = await _databaseService.getShoppingCart(_userId);

      if (_shoppingCart.isNotEmpty) _setOrder();
    }
    setState(() => _isLoadingCart = false);
  }

  _setOrder() {
    int total = 0;

    for (Product product in _shoppingCart) {
      int? quantity = product.quantity;
      int? price = product.price;
      product.totalValue = quantity! * price!;
      total = total + product.totalValue!;
    }

    _order = Order(
      timestamp: Timestamp.now(),
      store: _shoppingCart.first.store,
      quantity: _shoppingCart.length,
      total: total,
      products: _shoppingCart,
    );
  }

  bool setQuantityVisibility(Product? cartProduct) {
    bool isVisible;
    if (cartProduct != null) {
      isVisible = true;
    } else {
      isVisible = false;
    }
    return isVisible;
  }

  addToCart(Product cartProduct) async {
    setState(() => _isUpdatingCart = true);

    Product product = Product(
      id: cartProduct.id,
      productId: cartProduct.productId,
      name: cartProduct.name,
      price: cartProduct.price,
      quantity: cartProduct.quantity! + 1,
      store: cartProduct.store,
    );

    await _databaseService.updateShoppingCart(_userId, product);

    setState(() {
      int index = _shoppingCart.indexOf(cartProduct);
      _shoppingCart[index].quantity = product.quantity;

      _setOrder();
      _isUpdatingCart = false;
    });
  }

  removeFromCart(Product? cartProduct) async {
    setState(() => _isUpdatingCart = true);

    if (cartProduct!.quantity == 1) {
      await _databaseService.removeFromShoppingCart(_userId, cartProduct);

      setState(() {
        _shoppingCart.remove(cartProduct);
        if (_shoppingCart.isEmpty) _order = null;
        _isUpdatingCart = false;
      });
    } else {
      Product product = Product(
        id: cartProduct.id,
        productId: cartProduct.productId,
        name: cartProduct.name,
        price: cartProduct.price,
        quantity: cartProduct.quantity! - 1,
        store: cartProduct.store,
      );

      await _databaseService.updateShoppingCart(_userId, product);

      setState(() {
        int index = _shoppingCart.indexOf(cartProduct);
        _shoppingCart[index].quantity = cartProduct.quantity! - 1;

        _setOrder();
        _isUpdatingCart = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getShoppingCart();
  }

  _buildShoppingCart(BuildContext context) {
    if (_userId.isEmpty) {
      return const Center(
        child: Text(
          'Necesita registrarse o ingresar con \n su cuenta para poder comprar.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
      );
    } else if (_isLoadingCart == false && _order == null) {
      return const Center(
        child: Text(
          'No has agregado productos al carrito.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
      );
    } else if (_isLoadingCart) {
      return indicatorDotsBouncing;
    } else {
      return Column(
      children: <Widget>[
        Container(
          color: Colors.grey[50],
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 16.0
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _shoppingCart.first.store.name ?? '',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      '${_shoppingCart.length} producto(s)',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.grey[300],
                backgroundImage: NetworkImage(
                    _shoppingCart.first.store.imageLogoUrl ?? '',
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            controller: _scrollController,
            itemCount: _shoppingCart.length,
            itemBuilder: (context, index) {

              final Product cartProduct = _shoppingCart[index];

              return ProductTile(
                product: cartProduct,
                isStoreNameVisible: false,
                isAddButtonVisible: false,
                belongsToShoppingCart: true,
                isQuantityVisible: true,
                onPressedAdd: _isUpdatingCart ? () {}
                    : () => addToCart(cartProduct),
                onPressedRemove: _isUpdatingCart ? () {}
                    : () => removeFromCart(cartProduct),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
          ),
        ),
        Container(
          color: Colors.amber,
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 14.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  <Widget>[
                  const Text(
                    'Total',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  Text('\$ ${_order?.total ?? ''}', //25.700
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const Divider(),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.12,
                width: double.infinity,
                child: TextButton(
                  child: const Text('Continuar'),
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                    ),
                    primary: Colors.white,
                    backgroundColor: Colors.blue[600],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Payment(order: _order!),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Carrito de compras',
          style: TextStyle(fontSize: 17.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        elevation: 0.0,
      ),
      body: _buildShoppingCart(context),
    );
  }
}