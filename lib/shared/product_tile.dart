import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neighborhood_stores_app/models/product.dart';

class ProductTile extends StatelessWidget {
  final Function()? onPressedAdd;
  final Function()? onPressedRemove;

  final Product product;
  final bool isStoreNameVisible;
  final bool isAddButtonVisible;
  final bool isQuantityVisible;
  final bool belongsToShoppingCart;
  final String? storeName;
  final bool? quantity;

  const ProductTile({
    Key? key,
    required this.product,
    required this.isStoreNameVisible,
    required this.isAddButtonVisible,
    required this.isQuantityVisible,
    required this.belongsToShoppingCart,
    this.storeName = '',
    this.quantity,
    required this.onPressedAdd,
    required this.onPressedRemove,
  }) : super(key: key);

  Text _buildProductNameText() {
    return Text(
      product.name ?? '',
      style: const TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w500,
        height: 1.2,
      ),
    );
  }

  Text _buildStoreNameText() {
    return Text(
      storeName ?? '',
      style: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: Colors.grey[700],
      ),
    );
  }

  Text _buildPriceText() {
    return Text(
      '\$ ${product.price.toString()}',
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: Colors.blue[700],
      ),
    );
  }

  IconButton _buildRemoveIconButton() {
    return IconButton(
      color: Colors.blue[700],
      splashColor: Colors.transparent,
      iconSize: 32.0,
      icon: const Icon(
        Icons.remove_circle_outline_outlined,
      ),
      onPressed: onPressedRemove,
    );
  }

  IconButton _buildAddIconButton() {
    return IconButton(
      color: Colors.blue[700],
      splashColor: Colors.transparent,
      iconSize: 32.0,
      icon: const Icon(
        Icons.add_circle_outlined,
      ),
      onPressed: onPressedAdd,
    );
  }

  Widget _buildAddTextButton() {
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      child: TextButton(
        child: const Text('Agregar'),
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13.0,
          ),
          primary: Colors.white,
          backgroundColor: Colors.blue[600],
        ),
        onPressed: onPressedAdd,
      ),
    );
  }

  Widget _buildForShoppingCart(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.60,
                child: _buildProductNameText(),
              ),
              Text(
                '\$ ${product.totalValue.toString()}',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 26.0),
          Row(
            children: <Widget>[
              _buildRemoveIconButton(),
              const SizedBox(width: 7.0),
              Text(product.quantity.toString()),
              const SizedBox(width: 7.0),
              _buildAddIconButton(),
            ],
          ),
        ],
      )
    );
  }


  Widget _buildForCatalog(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.only(top: 16.0, bottom: 4.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.60,
                child: _buildProductNameText(),
              ),
            ],
          ),
          const SizedBox(height: 7.0),
          Row(
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.60,
                child: _buildStoreNameText(),
              ),
            ],
          ),


          const SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPriceText(),
              Row(
                children: [
                  if (!isAddButtonVisible && isQuantityVisible) ...[
                    _buildRemoveIconButton(),
                    const SizedBox(width: 7.0),
                    Text(product.quantity.toString()),
                    const SizedBox(width: 7.0),
                    _buildAddIconButton(),
                  ] else ...[
                    Visibility(
                      child: _buildAddTextButton(),
                      visible: isAddButtonVisible && !isQuantityVisible,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                    ),
                  ]
                ]
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (belongsToShoppingCart) {
      return _buildForShoppingCart(context);
    } else {
      return _buildForCatalog(context);
    }
  }
}
