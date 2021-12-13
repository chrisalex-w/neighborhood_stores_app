import 'package:flutter/material.dart';
import 'package:neighborhood_stores_app/models/order.dart';
import 'package:neighborhood_stores_app/services/auth.dart';
import 'package:neighborhood_stores_app/services/database.dart';
import 'package:neighborhood_stores_app/shared/constants.dart';
import 'package:neighborhood_stores_app/shared/order_tile.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final AuthService _authService = AuthService();
  final ScrollController _scrollController;
  final DatabaseService _databaseService;

  String _userId = '';
  List<Order> _orders = [];
  bool _isLoadingOrders = true;

  _OrdersState()
      : _databaseService = DatabaseService(),
        _scrollController = ScrollController();

  _getOrders() async {
    setState(() => _isLoadingOrders = true);

    if (_authService.getCurrentUser() != null) {
      _userId = _authService.getCurrentUser()!.uid;
      _orders = await _databaseService.getOrders(_userId);
    }
    setState(() => _isLoadingOrders = false);
  }

  @override
  void initState() {
    super.initState();
    _getOrders();
  }

  @override
  Widget build(BuildContext context) {
    if (_userId.isEmpty) {
      return const Center(
        child: Text(
          'Necesita registrarse o ingresar con \n'
          'su cuenta para poder realizar un pedido.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
      );
    } else if (_isLoadingOrders == false && _orders.isEmpty) {
      return const Center(
        child: Text(
          'No has realizado ningún pedido.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
      );
    } else if (_isLoadingOrders) {
      return indicatorDotsBouncing;
    } else {
      return ListView.builder(
        controller: _scrollController,
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          Order order = _orders[index];
          return OrderTile(order: order);
        },
      );
    }
  }
}
