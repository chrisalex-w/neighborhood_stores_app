import 'package:flutter/material.dart';
import 'package:neighborhood_stores_app/models/store.dart';

class StoreTile extends StatelessWidget {

  final Store store;
  const StoreTile({Key? key, required this.store})  : super(key: key);

  Text _buildNameText() {
    return Text(
      store.name ?? '',
      style: const TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
    );
  }

  Text _buildAddressText() {
    return Text(
      store.address ?? '',
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.2,
        color: Colors.grey[700],
      ),
    );
  }

  Text _buildLandlineText() {
    return Text(
      'Tel. ${store.landline}',
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.2,
        color: Colors.grey[700],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: MediaQuery.of(context).size.height * 0.040,
            backgroundColor: Colors.grey[300],
            backgroundImage: NetworkImage(store.imageLogoUrl!),
          ),
          const SizedBox(width: 18.0),
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.70,
                    child: _buildNameText(),
                  ),
                ],
              ),
              const SizedBox(height: 6.0),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.70,
                    child: _buildAddressText(),
                  ),
                ],
              ),
              const SizedBox(height: 6.0),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.70,
                    child: _buildLandlineText(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}