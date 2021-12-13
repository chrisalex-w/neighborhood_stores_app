import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neighborhood_stores_app/models/order.dart';

class OrderTile extends StatelessWidget {
  final Order order;
  const OrderTile({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    DateTime date = order.timestamp!.toDate();
    String orderDate = DateFormat('dd/MM/yyyy, hh:mm a').format(date);

    String orderDelivery;
    if (order.delivery == 'At home') {
      orderDelivery = 'Entregado a domicilio';
    } else {
      orderDelivery = 'Retiro en tienda';
    }

    return Card(
      margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
      shape: RoundedRectangleBorder(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.only(top: 16.0, bottom: 4.0),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: MediaQuery.of(context).size.height * 0.025,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.check_circle,
                size: 35,
                color: Colors.greenAccent[700],
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          orderDate,
                          style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          orderDelivery,
                          style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.green[700],
                          height: 1.2,
                        ),),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    children: <Widget>[
                      SizedBox(width: MediaQuery.of(context).size.width * 0.5,
                          child: Text('${order.store.name}')),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${order.quantity} producto(s)'),
                      Text('\$ ${order.total}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
