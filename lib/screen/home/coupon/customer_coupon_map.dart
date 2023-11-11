/*
import 'dart:async';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:tw_business_app/models/storeMarker.dart';
import 'package:tw_business_app/screen/home/coupon/store_card.dart';
import 'package:tw_business_app/shared/loading.dart';


class CouponMap extends StatefulWidget {
  @override
  _CouponMapState createState() => _CouponMapState();
}

class _CouponMapState extends State<CouponMap> {
  StoreCard _displayStoreCard;
  LatLng _currentLocation;
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _initBrussels = CameraPosition(
    target: LatLng(50.8503, 4.3517),
    zoom: 14,
  );
  Location _location = Location();
  void _moveToLocation() async {
    final GoogleMapController controller = await _controller.future;
    _location.getLocation().then((l) => controller.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(l.latitude, l.longitude), zoom: 16))));
  }

  @override
  Widget build(BuildContext context) {
    final markers = Provider.of<List<Future<StoreMarker>>>(context);
    if (markers == null) {
      // print("No Stores found ...");
      return Loading();
    } else {
      return FutureBuilder<List<StoreMarker>>(
          future: Future.wait(markers),
          builder: (BuildContext context,
              AsyncSnapshot<List<StoreMarker>> snapshot) {
            if (snapshot.hasData) {
              Set<Marker> _marker = <Marker>{};
              snapshot.data.forEach((element) {
                _marker.add(Marker(
                  markerId: element.markerId,
                  position: element.position,
                  infoWindow: element.infoWindow,
                  onTap: () async {
                    // LatLng _currentLocation;
                    await _location.getLocation().then((value) => {
                          _currentLocation =
                              LatLng(value.latitude, value.longitude)
                        });
                    double _distance = Geolocator.distanceBetween(
                        _currentLocation.latitude,
                        _currentLocation.longitude,
                        element.position.latitude,
                        element.position.longitude);
                    setState(() {
                      _displayStoreCard = StoreCard(
                        store: element,
                        distance: _distance,
                      );
                    });
                  },
                ));
              });

              return Stack(children: <Widget>[
                Scaffold(
                  body: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _initBrussels,
                    myLocationEnabled: true,
                    rotateGesturesEnabled: false,
                    scrollGesturesEnabled: true,
                    tiltGesturesEnabled: false,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    onTap: (argument) {
                      setState(() {
                        _displayStoreCard = null;
                      });
                    },
                    markers: _marker,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      _moveToLocation();
                    },
                  ),
                ),
                Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 8.0),
                    child: _displayStoreCard,
                  ),
                ),
              ]);
            } else {
              return Loading();
            }
          });
    }
  }
}*/
