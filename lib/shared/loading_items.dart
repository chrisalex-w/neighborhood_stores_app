import 'package:flutter/material.dart';
import 'constants.dart';

class LoadingMoreItems extends StatelessWidget {
  final bool isOverlapping;

  const LoadingMoreItems({
    Key? key, required this.isOverlapping,
  }) : super(key: key);

  Widget _buildLoadingSection() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Container(
        //height: 150,
        child: indicatorDotsBouncing,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Colors.white.withOpacity(0.0),
              Colors.white.withOpacity(1.0),
            ],
            tileMode: TileMode.repeated,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isOverlapping) {
      return Positioned(
          top: MediaQuery.of(context).size.height * 0.70,
          left: 0.0,
          right: 0.0,
          bottom: 0.0,
          child:_buildLoadingSection(),
      );
    } else {
      return Column(
        children: <Widget>[
          _buildLoadingSection(),
        ],
      );
    }
  }
}