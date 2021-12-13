import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Loading animation
const indicatorDotsBouncing = Center(
  child: SpinKitThreeBounce(
    color: Colors.blue,
    size: 30.0,
  ),
);

const messageStoresNotFound = Center(
  child: Text('No se encontraron negocios'),
);

const textInputDecoration = InputDecoration(
  //fillColor: Color(0xFFfafafa),//Colors.white,
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xFFe0e0e0),
      width: 1.0,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.black54,
      //color: Color(0xFF1775d1),
      width: 2.0,
    ),
  ),
  hintStyle: TextStyle(
    color: Color(0xFF616161),
    fontWeight: FontWeight.w400,
  ),
  isDense: true,
  contentPadding: EdgeInsets.symmetric(
    horizontal: 15.0,
    vertical: 12.0,
  ),
);
