import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:neighborhood_stores_app/models/product.dart';
import 'package:neighborhood_stores_app/models/store.dart';
import 'package:neighborhood_stores_app/sections/orders/shopping_cart.dart';
import 'package:neighborhood_stores_app/sections/store/store_details.dart';
import 'package:neighborhood_stores_app/services/auth.dart';
import 'package:neighborhood_stores_app/services/database.dart';
import 'package:neighborhood_stores_app/shared/constants.dart';
import 'package:neighborhood_stores_app/shared/loading_items.dart';
import 'package:neighborhood_stores_app/shared/product_tile.dart';

class StoreCatalog extends StatefulWidget {
  final Store store;
  const StoreCatalog({Key? key, required this.store}) : super(key: key);

  @override
  _StoreCatalogState createState() => _StoreCatalogState();
}

class _StoreCatalogState extends State<StoreCatalog> {
  final AuthService _authService = AuthService();

  final int _itemsPerPage = 8;
  final ScrollController _scrollController;
  final DatabaseService _databaseService;

  String? _userId = '';
  List<Product> _products = [];
  List<Product> _shoppingCart = [];

  bool _isLoadingProducts = true;
  bool _isLoadingMoreProducts = false;
  bool _moreProductsAvailable = true;
  bool _isUpdatingCart = false;

  void isLoadingMoreProducts(bool isLoading) {
    setState(() => _isLoadingMoreProducts = isLoading);
  }

  void moreProductsAvailable(bool isLoading) {
    setState(() => _moreProductsAvailable = isLoading);
  }

  _StoreCatalogState() :
        _databaseService = DatabaseService(),
        _scrollController = ScrollController();

  _getProducts() async {
    _moreProductsAvailable = true;
    setState(() => _isLoadingProducts = true);

    _products = await _databaseService.getProductsFromStore(
        widget.store.name, _itemsPerPage);

    if (_authService.getCurrentUser() != null) {
      _userId = _authService.getCurrentUser()!.uid;
      _shoppingCart = await _databaseService.getShoppingCart(_userId);
    }
    setState(() => _isLoadingProducts = false);
  }

  _getMoreProducts() async {
    if (_moreProductsAvailable == false) return;
    if (_isLoadingMoreProducts == true) return;

    _products.addAll(await _databaseService.getMoreProductsFromStore(
        _itemsPerPage,
        widget.store.name,
        moreProductsAvailable,
        isLoadingMoreProducts));
  }

  Product? searchProductInCart(Product storeProduct) {
    return _shoppingCart
        .firstWhereOrNull((product) => product.productId == storeProduct.id);
  }

  bool setAddButtonVisibility(
      String storeId, Product? cartProduct, Product storeProduct) {
    bool isVisible;
    if (_userId!.isNotEmpty && cartProduct == null &&
        (_shoppingCart.isEmpty || storeProduct.store.id == storeId)) {
      isVisible = true;
    } else {
      isVisible = false;
    }
    return isVisible;
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

  addToCart(Product storeProduct, Product? cartProduct) async {
    setState(() => _isUpdatingCart = true);

    if (cartProduct != null) {
      Product product = Product(
        id: cartProduct.id,
        productId: cartProduct.productId,
        name: cartProduct.name,
        price: cartProduct.price,
        quantity: cartProduct.quantity! + 1,
        store: cartProduct.store,
      );

      await _databaseService.updateShoppingCart(_userId!, product);

      setState(() {
        int index = _shoppingCart.indexOf(cartProduct);
        _shoppingCart[index].quantity = product.quantity!;
        _isUpdatingCart = false;
      });
    } else {
      String id = _databaseService.getNextCartProductId(_userId);

      Product product = Product(
        id: id,
        productId: storeProduct.id,
        name: storeProduct.name,
        price: storeProduct.price,
        quantity: 1,
        store: storeProduct.store,
      );

      await _databaseService.updateShoppingCart(_userId!, product);

      setState(() {
        _shoppingCart.add(product);
        _isUpdatingCart = false;
      });
    }
  }

  removeFromCart(Product? cartProduct) async {
    setState(() => _isUpdatingCart = true);

    if (cartProduct!.quantity == 1) {
      await _databaseService.removeFromShoppingCart(_userId!, cartProduct);

      setState(() {
        _shoppingCart.remove(cartProduct);
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

      await _databaseService.updateShoppingCart(_userId!, product);

      setState(() {
        int index = _shoppingCart.indexOf(cartProduct);
        _shoppingCart[index].quantity = cartProduct.quantity! - 1;
        _isUpdatingCart = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _getProducts();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;

      if (maxScroll - currentScroll <= delta) {
        _getMoreProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String storeId = '';
    if (_shoppingCart.isNotEmpty) {
      storeId = _shoppingCart.first.store.id!;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '', style: TextStyle(fontSize: 17.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        //backgroundColor: Colors.white,
        //foregroundColor: Colors.black,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            //padding: const EdgeInsets.only(right: 8.0),
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShoppingCart(),
                ),
              );
              setState(() => _getProducts());
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0.0,
            height: MediaQuery.of(context).size.height * 0.11,
            width: MediaQuery.of(context).size.width,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoreDetails(
                      store: widget.store,
                    ),
                  ),
                );
              },
              child: Container(
                color: Colors.grey[50],
                margin: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 18.0
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.store.name ?? '',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 30.0,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(widget.store.imageLogoUrl!),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.11,
            height: MediaQuery.of(context).size.height * 0.005,
            width: MediaQuery.of(context).size.width,
            child: Container(
              color: Colors.grey[200],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.115,
            height: MediaQuery.of(context).size.height * 0.07,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Productos y servicios',
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  /* // For future versions, button to allow searches in store
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.grey[600]),
                    onPressed: () {
                    },
                  ),
                  */
                ],
              ),
            ),
          ),
          _isLoadingProducts == true
              ? indicatorDotsBouncing :
          Positioned(
            top: MediaQuery.of(context).size.height * 0.185,
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: ListView.separated(
              controller: _scrollController,
              itemCount: _products.length,
              itemBuilder: (context, index) {

                Product storeProduct = _products.elementAt(index);
                Product? cartProduct = searchProductInCart(storeProduct);

                bool isAddButtonVisible = setAddButtonVisibility(
                    storeId, cartProduct, storeProduct);
                bool isQuantityVisible = setQuantityVisibility(cartProduct);


                return ProductTile(
                  product: cartProduct ?? storeProduct,
                  isStoreNameVisible: true,
                  isAddButtonVisible: isAddButtonVisible,
                  isQuantityVisible: isQuantityVisible,
                  belongsToShoppingCart: false,
                  storeName: storeProduct.store.name,
                  onPressedAdd: _isUpdatingCart ? () {}
                      : () => addToCart(storeProduct, cartProduct),
                  onPressedRemove: _isUpdatingCart ? () {}
                      : () => removeFromCart(cartProduct),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
          ),
          _isLoadingMoreProducts && _moreProductsAvailable
              ? const LoadingMoreItems(isOverlapping: true)
              : Container(),
        ],
      ),
    );
  }
}