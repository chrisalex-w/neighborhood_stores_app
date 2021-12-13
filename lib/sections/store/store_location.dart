import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:neighborhood_stores_app/models/store.dart';

class StoreLocation extends StatefulWidget {
  final Store store;

  const StoreLocation({Key? key, required this.store}) : super(key: key);

  @override
  _StoreLocationState createState() => _StoreLocationState();
}

class _StoreLocationState extends State<StoreLocation>
with WidgetsBindingObserver {

  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _center;
  final Set<Marker> _markers = {};

  void _addMarker() {
    _markers.add(Marker(
      markerId: MarkerId(_center.toString()),
      position: _center!,
      infoWindow: InfoWindow(
        title: widget.store.name,
        snippet: widget.store.address,
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Workaround to avoid blank screen after resuming from background
      final GoogleMapController controller = await _controller.future;
      setState(() => controller.setMapStyle("[]"));
    }
  }

  @override
  void initState() {
    super.initState();
    _center = LatLng(
        widget.store.location?.latitude ?? 0.0,
        widget.store.location?.longitude ?? 0.0,
    );
    _addMarker();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Establecimiento',
          style: TextStyle(fontSize: 17.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _center!,
                zoom: 18.0,
              ),
              markers: _markers,
              onMapCreated: _onMapCreated,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.store.name!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        widget.store.address!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal,
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
          )
        ],
      ),
    );
  }
}
