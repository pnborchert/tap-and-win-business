import 'package:flutter/material.dart';
import 'package:tw_business_app/models/coupon.dart';
import 'package:tw_business_app/screen/home/coupon/coupon_list.dart';
import 'package:tw_business_app/screen/home/twpage.dart';
import 'package:tw_business_app/services/auth.dart';
import 'package:tw_business_app/services/database.dart';
import 'package:provider/provider.dart';

// coupon page
final TWPage pageCoupon = new TWPage(
  title: Text("Coupon", style: TextStyle(color: Colors.black)),
  content: CouponList(),
  bottom: null,
  tabs: 0,
);

// final TWPage pageCoupon = new TWPage(
//   title: Text("Coupon", style: TextStyle(color: Colors.black)),
//   content: StreamProvider<List<Future<Coupon>>>.value(
//     initialData: null,
//     value:
//         DataBaseService(uid: new AuthService().currentUser().uid).userCoupons,
//     child: CouponList(),
//   ),
//   bottom: null,
//   tabs: 0,
// );

// coupon page
// final TWPage pageCoupon = new TWPage(
//   title: Text("Coupon", style: TextStyle(color: Colors.black)),
//   content: TabBarView(children: [
//     // First Tab
//     StreamProvider<List<Future<Coupon>>>.value(
//       initialData: null,
//       value:
//           DataBaseService(uid: new AuthService().currentUser().uid).userCoupons,
//       child: CouponList(),
//     ),
//     // Second Tab
//     StreamProvider<List<Future<StoreMarker>>>.value(
//       initialData: null,
//       value: DataBaseService().storeMarkers,
//       child: CouponMap(),
//     ),
//   ]),
//   bottom: TabBar(
//     tabs: [
//       Tab(icon: Icon(Icons.list)),
//       Tab(icon: Icon(Icons.map)),
//     ],
//   ),
//   tabs: 2,
// );
