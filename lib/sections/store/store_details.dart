import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neighborhood_stores_app/models/store.dart';
import 'package:neighborhood_stores_app/sections/store/store_location.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreDetails extends StatefulWidget {

  final Store store;
  const StoreDetails({Key? key, required this.store}) : super(key: key);

  @override
  _StoreDetailsState createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {

  static const TextStyle _infoStyle = TextStyle(
    color: Colors.black,
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const EdgeInsets _infoPadding = EdgeInsets.symmetric(
      horizontal: 4.0, vertical: 12.0);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Información',
          style: TextStyle(fontSize: 17.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  color: Colors.grey[50],
                  child: FittedBox (
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: (Colors.grey[300])!,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                        shape: BoxShape.rectangle,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.32,
                          height: MediaQuery.of(context).size.width * 0.32,
                          //height: 90.0,
                          //width: 90.0,
                          color: Colors.white,
                          child: Image.network(
                            widget.store.imageLogoUrl!,//"assets/logo_exito.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  widget.store.name ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  widget.store.category ?? '', //'Restaurante',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20.0),
            const Divider(),
            const SizedBox(height: 20.0),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoreLocation(
                      store: widget.store,
                    ),
                  ),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: _infoPadding,
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.place_rounded),
                    const SizedBox(width: 10.0),
                    Text(
                      widget.store.address ?? '',
                      style: _infoStyle,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              //color: Colors.amber,
              width: MediaQuery.of(context).size.width,
              padding: _infoPadding,
              child: Row(
                children: <Widget>[
                  const Icon(Icons.phone_rounded),
                  const SizedBox(width: 10.0),
                  Text(
                    widget.store.landline ?? '',
                    style: _infoStyle,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              //color: Colors.amber,
              width: MediaQuery.of(context).size.width,
              padding: _infoPadding,
              child: Row(
                children: <Widget>[
                  const Icon(Icons.phone_rounded),
                  const SizedBox(width: 10.0),
                  Text(
                    widget.store.cellphone ?? '',
                    style: _infoStyle,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                print('here');
                String url = widget.store.website ?? '';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  print('cant launch');
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: _infoPadding,
                child: Wrap(
                  children: <Widget>[
                    const Icon(Icons.language_outlined),
                    const SizedBox(width: 10.0),
                    Text(
                      widget.store.website ?? '',
                      style: _infoStyle,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            FittedBox(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.24,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                  child: Image.asset(
                      "assets/heroes.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}