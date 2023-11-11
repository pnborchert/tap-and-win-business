import 'package:flutter/material.dart';
//import 'package:tw_business_app/models/storeMarker.dart';
//import 'package:tw_business_app/screen/home/coupon/coupon_map.dart';
import 'package:tw_business_app/screen/home/twpage.dart';
import 'package:tw_business_app/services/database.dart';
import 'package:provider/provider.dart';



// map page
final TWPage pageMap = new TWPage(
  title: Text("Find a store", style: TextStyle(color: Colors.black)),
  /*
  content: StreamProvider<List<Future<StoreMarker>>>.value(
    initialData: null,
    value: DataBaseService().storeMarkers,
    child: CouponMap(),
  ),*/
  bottom: null,
  tabs: 0,
);
