// API

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart';
import 'package:tw_business_app/models/coupon.dart';
import 'package:tw_business_app/models/nfc.dart';
import 'package:tw_business_app/models/nfc_request.dart';
import 'package:tw_business_app/models/scan.dart';
import 'package:tw_business_app/screen/home/profile/dashboard.dart';

import 'package:tw_business_app/services/auth.dart';

// import 'package:tw_business_app/models/coupon.dart';

final String domainPrefix = "ANONYMIZED"; 
final String userPrefix = "ANONYMIZED";
final String urlPrefix = "ANONYMIZED";
final String createCouponUrl = "ANONYMIZED";
final String updateCouponUrl = "ANONYMIZED";
final String updateInfoUrl = "ANONYMIZED";
final String helpUrl = "ANONYMIZED";

String _nfcURL;
Nfc nfc;
bool showBadge = false;

Future<void> parseNfcUrl(String url) async {
  if (url.contains(domainPrefix)) {
    final int start = url.indexOf("\?");
    _nfcURL = urlPrefix + url.substring(start, url.length);
  } else {
    print("URL does not contain $domainPrefix");
  }
}

Future<Nfc> tapAPI(String uid) async {
  if (_nfcURL != null && _nfcURL.isNotEmpty) {
    Uri url = Uri.parse(_nfcURL +
        userPrefix +
        uid +
        "&token=" +
        await AuthService().currentUser().getIdToken());
    //print(url);
    try {
      Response res = await get(url);

      if(res.statusCode == 250 || res.statusCode == 251 ){ //The nfc {nfc.id} is now in the dataset! (you are admin)
        dynamic _json = jsonDecode(res.body);
        Nfc nfc = Nfc(
            id: _json["id"].toString(),
            counter: _json["counter"],
            isValid: _json["is_valid"],
            number: -1,
            timestamp: null,
            groupId: -1,
            nTaps: -1,
            percentage: 1.0 -
                min(double.parse(_json["counter"].toString()), maxTaps) /
                    maxTaps,
            isActive: _json["is_active"],
        message: _json["message"],);

        print(nfc);
        return nfc;
      }

      if (res.statusCode == 201) { // the stcker has been just associated to the store, recall the api to get the info
        res = await get(url);
      }

      if (res.statusCode == 200) {
        dynamic _json = jsonDecode(res.body);
        Nfc nfc = Nfc(
            id: _json["id"].toString(),
            counter: _json["counter"],
            isValid: _json["is_valid"],
            number: _json["number"],
            timestamp: Timestamp.fromDate(DateTime.parse(_json["timestamp"])),
            groupId: _json["group_id"],
            nTaps: _json["n_taps"],
            percentage: 1.0 -
                min(double.parse(_json["counter"].toString()), maxTaps) /
                    maxTaps,
            isActive: _json["is_active"]);
        return nfc;
      } else {
        // status false or coupon empty
        print(res.body.toString());
        print("no nfc received.");
      }
    } catch (e) {
      // no json response
      print(e);
    }
  } else {
    // no tap -> proceed login
    // print("No NFC link received!");
  }
  return null;
}

Future<List<Coupon>> getCouponList() async {
  String strURL = "ANONYMIZED";
  String route = "ANONYMIZED";

  // return list
  List<Coupon> couponList;

  // make sure user is logged in
  String uid = AuthService().currentUser().uid;
  if (uid.isEmpty) {
    return null;
  }

  // url to call
  Uri url = Uri.https(strURL, route, {
    "store_id": uid,
    "token": await AuthService().currentUser().getIdToken()
  });
  try {
    Response res = await get(url);

    if (res.statusCode == 200) {
      final _jsonList = jsonDecode(res.body) as List;
      couponList = _jsonList.map((map) => Coupon.fromJSON(map)).toList();
      //print(res.body);
    }else{
      //print(res.body);
    }
  } catch (e) {
    // no API response
    // print(e);
  }
  return couponList;
}

Future<String> createCouponApi(Coupon coupon, String uid) async {
  try {
    Response res = await post(Uri.parse(createCouponUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'creation_date': coupon.creation_date.toDate().toString(),
          'title': coupon.title,
          'store_id': uid,
          'token': await AuthService().currentUser().getIdToken(),
          'expiry_date': coupon.expiry_date.toDate().toString(),
          'old_price': coupon.old_price.toString(),
          'new_price': coupon.new_price.toString(),
          'description': coupon.description,

                  }));
    if (res.statusCode == 200) {
      dynamic _json = jsonDecode(res.body);
      return _json['coupon_id'];
    } else {
      // status false or coupon empty
      print("no coupon received.");
      return null;
    }
  } catch (e) {
    // no json response
    // print(e);
    return null;
  }

  return null;
}

Future<String> getImageAPI(String uid) async {
  String strURL = "ANONYMIZED";
  String route = "ANONYMIZED";
  Uri url = Uri.https(strURL, route, {
    'store_id': uid,
    'token': await AuthService().currentUser().getIdToken()
  });
  //print(url.toString());
  try {
    Response res = await get(url);
    if (res.statusCode == 200) {
      final _json = jsonDecode(res.body);
      return _json['url'];
    }
    return null;
  } catch (e) {
    // no API respons
    print(e);
  }
  return null;
}

Future<Scan> couponValidation(String uid, String tapId) async {
  String strURL = "ANONYMIZED";
  String route = "ANONYMIZED";
  Uri url = Uri.https(strURL, route, {
    'store_id': uid,
    'tap_id': tapId,
    'token': await AuthService().currentUser().getIdToken()
  });
  try {
    Response res = await get(url);
    print(url);

    print(res.statusCode);
    print(res.body);
    if ([401,402,403, 404,200].contains(res.statusCode)) {
      print(res.body);
      final _json = jsonDecode(res.body);
      print(_json);
      return Scan.fromJSON(_json);
    }
    return null;
  } catch (e) {
    // no API respons
    // print(e);
    return null;
  }
  return null;
}

Future<bool> updateInfo(String uid, String email, String phone) async {
  try {
    Response res = await post(Uri.parse(updateInfoUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'phone': phone,
          'store_id': uid,
          'token': await AuthService().currentUser().getIdToken(),
        }));
    if (res.statusCode == 200) {
      return true;
    } else {
      // status false or coupon empty
      print(res.body);
      return false;
    }
  } catch (e) {
    // no json response
    // print(e);
    return false;
  }

  return null;
}

Future<List<Nfc>> getNfcList() async {
  String strURL = "ANONYMIZED";
  String route = "ANONYMIZED";

  // return list
  List<Nfc> nfcList;

  // make sure user is logged in
  String uid = AuthService().currentUser().uid;
  if (uid.isEmpty) {
    return null;
  }

  // url to call
  Uri url = Uri.http(strURL, route, {
    "store_id": uid,
    'token': await AuthService().currentUser().getIdToken()
  });

  try {
    Response res = await get(url);

    if (res.statusCode == 200) {
      final _jsonList = jsonDecode(res.body) as List;
      nfcList = _jsonList.map((map) => Nfc.fromJSON(map)).toList();
      return nfcList;
    } else {
      //print(res.body);
      return nfcList;
    }
  } catch (e) {
    // no API response
    print(e);
    return nfcList;
  }
}

Future<NfcRequest> getNfcRequest() async {
  String strURL = "ANONYMIZED";
  String route = "ANONYMIZED";

  // return list

  // make sure user is logged in
  String uid = AuthService().currentUser().uid;
  if (uid.isEmpty) {
    return null;
  }

  // url to call
  Uri url = Uri.http(strURL, route, {
    "store_id": uid,
    'token': await AuthService().currentUser().getIdToken()
  });
  NfcRequest nfcRequest = NfcRequest();
  try {
    Response res = await get(url);

    if (res.statusCode == 200) {
      //print(res.body);
      dynamic _json = jsonDecode(res.body);
      nfcRequest = new NfcRequest(
          id: _json["id"],
          counter: _json["counter"],
          status: _json["status"],
          statusCode: _json["status_code"],
          track: _json["track"],
          service: _json["service"]);
      return nfcRequest;
    } else {
      //print(res.body);
      return nfcRequest;
    }
  } catch (e) {
    // no API response
    // print(e);
    return null;
  }
}

Future<String> postNfcRequest(int counter) async {
  // return list

  // make sure user is logged in
  String uid = AuthService().currentUser().uid;
  if (uid.isEmpty) {
    return null;
  }

  try {
    Response res =
        await post(Uri.parse("ANONYMIZED"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'counter': counter,
              'store_id': uid,
              'token': await AuthService().currentUser().getIdToken(),
            }));

    if (res.statusCode == 200) {
      //print(res.body);
      dynamic _json = jsonDecode(res.body);

      return _json['request_id'];
    } else {
      // status false or coupon empty
      // print("no request received.");
      return null;
    }
  } catch (e) {
    // no json response
    // print(e);
    return null;
  }
}

Future<void> postFCM(String uid, String fcm_token) async {

  try {
    Response res =
        await post(Uri.parse("ANONYMIZED"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'fcm_token': fcm_token,
              'store_id': uid,
              'token': await AuthService().currentUser().getIdToken()
            }));

    if (res.statusCode == 200) {

    } else {
      // status false or coupon empty
      // print("no request received.");
    }
  } catch (e) {
    // no json response
    print(e);
  }
}



Future<void> postStatusCoupon(String couponId) async {
  String uid = AuthService().currentUser().uid;
  if (uid.isEmpty) {
    return;
  }
  try {
    Response res = await post(
        Uri.parse("ANONYMIZED"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'coupon_id': couponId,
          'store_id': uid,
          'token': await AuthService().currentUser().getIdToken()
        }));

    if (res.statusCode != 200) {
      // status false or coupon empty
      // print("no request received.");
    }
  } catch (e) {
    // no json response
    // print(e);
  }
}



Future<String> updateCouponApi(Coupon coupon, String uid) async {
  try {
    Response res = await post(Uri.parse(updateCouponUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'coupon_id': coupon.id,
          'creation_date': coupon.creation_date.toDate().toString(),
          'title': coupon.title,
          'store_id': uid,
          'token': await AuthService().currentUser().getIdToken(),
          'expiry_date': coupon.expiry_date.toDate().toString(),
          'old_price': coupon.old_price.toString(),
          'new_price': coupon.new_price.toString(),
        }));
    if (res.statusCode == 200) {
      dynamic _json = jsonDecode(res.body);

      return _json['coupon_id'];
    } else {
      // status false or coupon empty
      // print(res.statusCode);
      // print(res.body);
      // print("no coupon received.");
      return null;
    }
  } catch (e) {
    // no json response

    print(e);
    return null;
  }

  return null;
}


Future<bool> deleteCouponAPI(String uid, String couponId) async {
  try {
    String strURL = "ANONYMIZED";
    String route = "ANONYMIZED";
    Uri url = Uri.https(strURL, route,  {
      'store_id': uid,
      'token': await AuthService().currentUser().getIdToken(),
      'coupon_id': couponId,
    });

    Response res = await get(url);
    if (res.statusCode == 200) {

      // correct status response
      return true;
    } else {
      print(res.body);
      // no correct status response
      return false;
    }
  } catch (e) {
    // no json response or not correct user response
    // print(e);
    return false;
  }
  return null;
}



Future<String> helpAPI(String message, String category, String uid) async {
  try {
    String model = "";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      model = androidInfo.model.toString();
    }
    if(Platform.isIOS){
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      model = iosInfo.model.toString();
    }

    final String helpUrl = "ANONYMIZED";
    Response res = await post(Uri.parse(helpUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'category': category,
          'message':message,
          'is_store': true,
          'user_id':uid,
          'token': await AuthService().currentUser().getIdToken(),
          'model':model
        }));


    if (res.statusCode == 200) {
      dynamic _json = jsonDecode(res.body);
      return _json['help_id'];
    } else {
      // status false or coupon empty
      print(res.body.toString());
      print("error.");
      return null;
    }
  } catch (e) {
    // no json response
    // print(e);
    return null;
  }

  return null;
}



Future<String> feedbackAPI(String message, int rating, String uid) async {
  try {
    final String helpUrl = "ANONYMIZED";
    Response res = await post(Uri.parse(helpUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'rating': rating,
          'message':message,
          'is_store': true,
          'user_id':uid,
          'token': await AuthService().currentUser().getIdToken(),
        }));


    if (res.statusCode == 200) {
      dynamic _json = jsonDecode(res.body);
      return _json['feedback_id'];
    } else {
      // status false or coupon empty
      // print(res.body.toString());
      // print("error.");
      return null;
    }
  } catch (e) {
    // no json response
    // print(e);
    return null;
  }

  return null;
}




Future<String> updateLanguage(String lang ) async {
  // return list

  // make sure user is logged in
  String uid = AuthService().currentUser().uid;
  if (uid.isEmpty) {
    return null;
  }

  try {
    Response res =
    await post(Uri.parse("ANONYMIZED"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'language': lang,
          'store_id': uid,
          'token': await AuthService().currentUser().getIdToken(),
        }));

    if (res.statusCode == 200) {

      dynamic _json = jsonDecode(res.body);

      return _json['language'];
    } else {
      // status false or coupon empty
      print("no request received.");
      return null;
    }
  } catch (e) {
    // no json response

    print(e);
    return null;
  }
}


Future<List<Scan>> getScanList() async {
  String strURL = "ANONYMIZED";
  String route = "ANONYMIZED";

  // return list
  List<Scan> scanList;

  // make sure user is logged in
  String uid = AuthService().currentUser().uid;
  if (uid.isEmpty) {
    return null;
  }

  // url to call
  Uri url = Uri.http(strURL, route, {
    "store_id": uid,
    'token': await AuthService().currentUser().getIdToken()
  });
  print(url);
  try {
    Response res = await get(url);

    if (res.statusCode == 200) {
      final _jsonList = jsonDecode(res.body) as List;
      scanList = _jsonList.map((map) => Scan.fromJSON(map)).toList();
      return scanList;
    } else {
      //print(res.body);
      return scanList;
    }
  } catch (e) {
    // no API response
    print(e);
    return scanList;
  }
}

