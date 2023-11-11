import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tw_business_app/models/coupon.dart';
// import 'package:tw_business_app/models/storeMarker.dart';
import 'package:tw_business_app/models/user.dart';
import 'package:tw_business_app/shared/api.dart';
import 'package:tw_business_app/shared/constants.dart';

class DataBaseService {
  final String uid;

  DataBaseService({this.uid});

  // collection reference
  final CollectionReference customerCollection =
      FirebaseFirestore.instance.collection("Customer");

  final CollectionReference customercouponCollection =
      FirebaseFirestore.instance.collection("CustomerCoupon");

  final CollectionReference storeCollection =
      FirebaseFirestore.instance.collection("Store");

  // int _markerIdCounter = 0;

  Future updateFCMToken() async {
    await FirebaseMessaging.instance.getToken().then((token) async {
      await postFCM(uid, token);
    });
  }

  Future updateCustomerData(String email, int gender, int is_store, int points,
      String username) async {
    await FirebaseMessaging.instance.getToken().then((token) async {
      await customerCollection.doc(uid).set({
        'email': email,
        'gender': gender,
        'is_store': is_store,
        'points': points,
        'fcm_token': token.toString(),
        'image_file': default_image,
        'username': username,
      });
    });
  }

  Stream<List<Future<Coupon>>> get userCoupons {}
}

// Coupon List from snapshot
// List<Future<Coupon>> _couponListFromSnapshot(QuerySnapshot snapshot) {
//   return snapshot.docs.map((doc) async {
//     DocumentReference docRef = doc.data()["coupon_id"];
//     return await docRef.get().then((nestedDoc) {
//       return Coupon(
//           title: nestedDoc.data()["title"],
//           tap_id: doc.data()["tap_id"],
//           store_id: nestedDoc.data()["store_id"],
//           creation_date: nestedDoc.data()["creation_date"],
//           expiry_date: nestedDoc.data()["expiry_date"],
//           is_active: nestedDoc.data()["is_active"],
//           old_price: nestedDoc.data()["old_price"],
//           new_price: nestedDoc.data()["new_price"],
//           image: nestedDoc.data()["image"]);
//     });
//   }).toList();
// }

// stream for user coupons
// Stream<List<Future<Coupon>>> get userCoupons {
//   return customercouponCollection
//       .doc(uid)
//       .collection("Coupon")
//       .snapshots()
//       .map(_couponListFromSnapshot);
// }

// List<Future<StoreMarker>> _markerListFromSnapshot(QuerySnapshot snapshot) {
//   return snapshot.docs.map((store) async {
//     _markerIdCounter++;
//     return StoreMarker(
//       markerId: MarkerId('marker_$_markerIdCounter'),
//       position: LatLng(store.data()["location"].latitude,
//           store.data()["location"].longitude),
//       infoWindow: InfoWindow(title: store.data()["name"]),
//       displayTitle: store.data()["name"],
//       image: store.data()["image"],
//       category: categoryLookup[categoryLookup
//           .indexWhere((e) => e["index"] == store.data()["category"])]["name"],
//     );
//   }).toList();
// }

// stream for store markers
//   Stream<List<Future<StoreMarker>>> get storeMarkers {
//     return storeCollection.snapshots().map(_markerListFromSnapshot);
//   }
// }
