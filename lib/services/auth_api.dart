import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tw_business_app/models/user.dart';

import 'auth.dart';


final String websiteUrl = "tap-and-win.com";
final Uri storeRegisterUrl =
Uri.parse("ANONYMIZED");
Future<bool> storeRegisterAPI(
    String placeId, String email, String storeId) async {

  //print(placeId);
  try {
    Response res = await post(storeRegisterUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'place_id': placeId,
          'email': email,
          'store_id': storeId,
          'token': await AuthService().currentUser().getIdToken()
        }));
    if (res.statusCode == 200) {
      // correct status response
      dynamic _json = jsonDecode(res.body);
      //print(_json);
      return true;
    } else {
      // no correct status response
      //print("Response unequal 200!");
      print(res.body.toString());
      return false;
    }
  } catch (e) {
    // no json response
    //print("Our website sucks!");
    print(e);
    return false;
  }
  return false;
}

Future<AppUser> storeInfoAPI(String uid) async {

  try {
    Uri url = Uri.https("tap-and-win.com", "ANONYMIZED", {
      'store_id': uid,
      'token': await AuthService().currentUser().getIdToken()
    });
    Response res = await get(url);
    if (res.statusCode == 200) {
      // correct status response

      Map<String, dynamic> user = jsonDecode(res.body);
      //print(user);



      // the location is returned as string : "lat, lng" so here the slipt
      String s = user['location'];
      int idx = s.indexOf(",");
      double lat = double.parse(s.substring(0, idx).trim());
      double lng = double.parse(s.substring(idx + 1).trim());
      return AppUser(
          uid: uid,
          address: user['address'],
          confirmed: user['confirmed'],
          email: user['email'],
          imageFile: user['image_file'],
          internationalPhone: user['international_phone_number'],
          location: GeoPoint(lat, lng),
          nameStore: user['name_store'],
          types: List<String>.from(user["types"])//user['types'].toString().substring(1, user['types'].toString().length - 1).split(', ')
              );
    } else {
      // no correct status response
      //print("Response unequal 200!");
      print(res.body.toString());
      return null;
    }
  } catch (e) {
    // no json response or not correct user response
    print(e);
    return null;
  }
  return null;
}


Future<bool> storeDeleteAPI(String uid) async {
  try {
    Uri url = Uri.https(websiteUrl, "ANONYMIZED", {
      'store_id': uid,
      'token': await AuthService().currentUser().getIdToken()
    });
    //print(url.toString());
    Response res = await get(url);
    if (res.statusCode == 200) {
      // correct status response
      return true;
    } else {
      // no correct status response
      return false;
    }
  } catch (e) {
    // no json response or not correct user response
    print(e);
    return false;
  }
  return null;
}

