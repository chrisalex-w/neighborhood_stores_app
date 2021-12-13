import 'package:flutter/material.dart';
import 'package:neighborhood_stores_app/models/order.dart';
import 'package:neighborhood_stores_app/models/product.dart';
import 'package:neighborhood_stores_app/services/auth.dart';
import 'package:neighborhood_stores_app/services/database.dart';

class Payment extends StatefulWidget {
  final Order order;
  const Payment({Key? key, required this.order}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService;

  bool _isAtHomeSelected = true;
  bool _isProcessingOrder = false;

  _PaymentState() : _databaseService = DatabaseService();

  _processOrder() async {
    setState(() => _isProcessingOrder = true);

    if (_authService.getCurrentUser() != null) {
      String userId = _authService.getCurrentUser()!.uid;

      Order order = widget.order;
      if (_isAtHomeSelected) {
        order.delivery = 'At home';
      } else {
        order.delivery = 'At store';
      }
      _databaseService.addOrder(userId, widget.order);

      for (Product product in widget.order.products!) {
        await _databaseService.removeFromShoppingCart(userId, product);
      }
    }
    setState(() => _isProcessingOrder = false);
  }

  Widget _buildTextButton(String text) {
    return TextButton(
      child: Text(text),
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14.0,
        ),
        primary: Colors.white,
        backgroundColor: Colors.blue[600],
      ),
      onPressed: () {
        _isAtHomeSelected = !_isAtHomeSelected;
      },
    );
  }

  Widget _buildOutlinedButton(String text) {
    return OutlinedButton(
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blue[700],
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(width: 2.0, color: (Colors.blue[700])!),
        padding: const EdgeInsets.only(),
      ),
      onPressed: () {
        setState(() => _isAtHomeSelected = !_isAtHomeSelected);
      },
    );
  }

  Widget _buildAtHomeButton(Widget buttonType) {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.width * 0.12,
        margin: const EdgeInsets.only(left: 8.0, right: 16.0),
        child: buttonType, //_buildTextButton(text),
      ),
    );
  }

  Widget _buildAtStoreButton(Widget buttonType) {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.width * 0.12,
        margin: const EdgeInsets.only(left: 16.0, right: 8.0),
        child: buttonType, //_buildTextButton(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pago',
          style: TextStyle(fontSize: 17.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        elevation: 0.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(height: 30.0),
              const Text(
                '¿Cómo deseas retirar el pedido?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 30.0),
              Row(
                children: [
                  if (_isAtHomeSelected) ...[
                    _buildAtStoreButton(_buildOutlinedButton('En tienda')),
                    _buildAtHomeButton(_buildTextButton('A domicilio')),
                  ] else ...[
                    _buildAtStoreButton(_buildTextButton('En tienda')),
                    _buildAtHomeButton(_buildOutlinedButton('A domicilio')),
                  ],
                ],
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
            ),
            height: MediaQuery.of(context).size.width * 0.12,
            width: double.infinity,
            child: TextButton(
              child: const Text('Confirmar pedido'),
              style: TextButton.styleFrom(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                ),
                primary: Colors.white,
                backgroundColor: Colors.blue[600],
              ),
              onPressed: _isProcessingOrder ? () {} : () async {
                await _processOrder();
                Navigator.of(context)..pop()..pop();
              },
            ),
          )
        ],
      ),
    );
  }
}
