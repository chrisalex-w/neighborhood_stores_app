import 'package:flutter/material.dart';
import 'package:neighborhood_stores_app/models/product.dart';
import 'package:neighborhood_stores_app/sections/store/store_catalog.dart';
import 'package:neighborhood_stores_app/services/auth.dart';
import 'package:neighborhood_stores_app/services/database.dart';

import 'package:collection/collection.dart';
import 'package:neighborhood_stores_app/shared/constants.dart';
import 'package:neighborhood_stores_app/shared/loading_items.dart';
import 'package:neighborhood_stores_app/shared/product_tile.dart';
import 'package:neighborhood_stores_app/shared/search_bar.dart';


class HomeProducts extends StatefulWidget {
  const HomeProducts({Key? key}) : super(key: key);

  @override
  _HomeProductsState createState() => _HomeProductsState();
}

class _HomeProductsState extends State<HomeProducts> {
  final AuthService _authService = AuthService();

  final int _itemsPerPage = 12;
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

  _HomeProductsState() :
        _databaseService = DatabaseService(),
        _scrollController = ScrollController();

  _getProducts() async {
    _moreProductsAvailable = true;
    setState(() => _isLoadingProducts = true);

    _products = await _databaseService.getProductsFromHome(_itemsPerPage);

    if (_authService.getCurrentUser() != null) {
      _userId = _authService.getCurrentUser()!.uid;
      _shoppingCart = await _databaseService.getShoppingCart(_userId);
    }
    setState(() => _isLoadingProducts = false);
  }

  _getMoreProducts() async {
    if (_moreProductsAvailable == false) return;
    if (_isLoadingMoreProducts == true) return;

    _products.addAll(await _databaseService.getMoreProductsFromHome(
        _itemsPerPage, moreProductsAvailable, isLoadingMoreProducts));
  }

  _searchProduct(String name) async {
    if (name.isNotEmpty) {
      List<Product> search = await _databaseService.searchProduct(name);
      setState(() => _products = search);
    } else {
      _getProducts();
    }
  }

  Product? searchProductInCart(Product storeProduct) {
    return _shoppingCart
        .firstWhereOrNull((product) => product.productId == storeProduct.id);
  }

  int? getProductQuantity(Product? cartProduct) {
    if (cartProduct != null) {
      return cartProduct.quantity;
    } else {
      return 0;
    }
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
  void didUpdateWidget(HomeProducts oldWidget) {
    super.didUpdateWidget(oldWidget);
    _getProducts();
  }

  @override
  Widget build(BuildContext context) {

    String storeId = '';
    if (_shoppingCart.isNotEmpty) {
      storeId = _shoppingCart.first.store.id!;
    }

    return Stack(
      children: <Widget>[
        CustomSearchBar(
          hintText: 'Buscar',
          onChanged: _searchProduct,
        ),
        _isLoadingProducts == true
            ? indicatorDotsBouncing //Then, check if _products.isEmpty
            : Positioned(
                top: MediaQuery.of(context).size.height * 0.080,
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

                    return GestureDetector(
                      child: ProductTile(
                        product: cartProduct ?? storeProduct,
                        isStoreNameVisible: false,
                        isAddButtonVisible: isAddButtonVisible,
                        isQuantityVisible: isQuantityVisible,
                        belongsToShoppingCart: false,
                        storeName: storeProduct.store.name,
                        onPressedAdd: _isUpdatingCart ? () {}
                            : () => addToCart(storeProduct, cartProduct),
                        onPressedRemove: _isUpdatingCart ? () {}
                            : () => removeFromCart(cartProduct),
                      ),
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoreCatalog(
                              store: _products.elementAt(index).store,
                            ),
                          ),
                        );
                      },
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
    );
  }
}
