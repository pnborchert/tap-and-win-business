
import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart';
import 'package:tw_business_app/screen/home/profile/dashboard.dart';
import 'package:tw_business_app/services/auth.dart';
/*
List<String> monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];
*/
List<String> monthNames = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];


/*
Future<dynamic> getDashboardData(String uid) async {
  String strURL = "ANONYMIZED";
  String route = "ANONYMIZED";

  // return list

  // make sure user is logged in
  String uid = AuthService().currentUser().uid;
  if (uid.isEmpty) {
    return null;
  }
  print(uid);

  // url to call
  Uri url = Uri.https(strURL, route, {
    "store_id": uid,
    'token': await AuthService().currentUser().getIdToken()
  });

  print(url.toString());
  try {
    Response res = await get(url);

    if (res.statusCode == 200) {
      print(res.body);
      dynamic _json = jsonDecode(res.body);

      Map<String, dynamic> result = {
        'PieTapsGender': pieTapsGender(_json['doughnut_taps_by_gender']),
        'BarTapsAge': barTapsAge(_json['chart_taps_by_age']),
        "BarTapsMonthly": barTapsMonthly(_json["taps_my_month"]),
        'PieCouponUsage': pieCouponUsage(_json),
        "revenue": _json["revenue"],
        "nTaps": _json["taps"],
        "customers": _json["customers"],
        "wonCoupons": _json["coupons_won_tot"],
      };
      // print(result);
      return result;
    } else {
      // print(res.body);
      return null;
    }
  } catch (e) {
    // no API response
    // print(e);
    return null;
  }
}

*/

dynamic pieTapsGender(String uid) async {
  String strURL = "ANONYMIZED";
  String route = "ANONYMIZED";
  Uri url = Uri.https(strURL, route, {
    "store_id": uid,
    'token': await AuthService().currentUser().getIdToken()
  });
  try {
    Response res = await get(url);

    if (res.statusCode == 200) {
      print(res.body);
      dynamic _json = jsonDecode(res.body);
      print(_json);
      return [
        new charts.Series<MySales, String>(
          id: 'Sales',
          colorFn: (MySales sales, _) => sales.color,
          //colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (MySales sales, _) => sales.label,
          measureFn: (MySales sales, _) => sales.value,
          //labelAccessorFn: (MySales sales, _) => '${sales.value}',
          data: [
            new MySales(charts.MaterialPalette.red.shadeDefault,
                "Male: " + _json["male"].toString(), _json["male"]),
            new MySales(charts.MaterialPalette.blue.shadeDefault,
                "Female: " + _json["female"].toString(), _json["female"]),
            new MySales(charts.MaterialPalette.green.shadeDefault,
                "Non-binary: " + _json["not_binary"].toString(), _json["not_binary"]),
            new MySales(charts.MaterialPalette.yellow.shadeDefault,
                "Not specified: " + _json["unrevealed"].toString(), _json["unrevealed"])
          ],
        )
      ];

    }
  }  catch (e) {
    // no API response
    // print(e);
    return null;
  }
  return null;
}

dynamic barTapsMonthly(String uid) async {
  String strURL = "ANONYMIZED";
  String route = "ANONYMIZED";
  Uri url = Uri.https(strURL, route, {
    "store_id": uid,
    'token': await AuthService().currentUser().getIdToken()
  });
  print(url);
  try {
    Response res = await get(url);
    if (res.statusCode == 200) {
      print(res.body);
      dynamic _json = jsonDecode(res.body);
      print(_json);
      List<int> month = _json['month'].cast<int>();
      List<int> count = _json['count'].cast<int>();
      List<OrdinalSales> data = [];
      int index;
      for (int i = 3; i >= 0; i--) {
        index = (month.length - i) % month.length;
        print(index);
        data.add(new OrdinalSales(monthNames[month[index] - 1], count[index]));
      }
      return [
        new charts.Series<OrdinalSales, String>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (OrdinalSales sales, _) => sales.label,
          measureFn: (OrdinalSales sales, _) => sales.value,
          data: data,
        )
      ];

    }
  }  catch (e) {
    // no API response
    // print(e);
    return null;
  }
  return null;
}

dynamic barTapsAge(String uid) async {
  String strURL = "ANONYMIZED";
  String route = "ANONYMIZED";
  Uri url = Uri.https(strURL, route, {
    "store_id": uid,
    'token': await AuthService().currentUser().getIdToken()
  });
  try {
    Response res = await get(url);

    if (res.statusCode == 200) {
      print(res.body);
      dynamic _json = jsonDecode(res.body);
      print(_json);
      return [
        new charts.Series<OrdinalSales, String>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (OrdinalSales sales, _) => sales.label,
          measureFn: (OrdinalSales sales, _) => sales.value,
          data: [
            new OrdinalSales("<20", _json["0-20"]),
            new OrdinalSales("20-30", _json["20-30"]),
            new OrdinalSales("30-40", _json["30-40"]),
            new OrdinalSales("30-50", _json["40-50"]),
            new OrdinalSales(">50", _json["50-60"] + _json["60-100"]),
            new OrdinalSales("Not\nspecified", _json["unrevealed"])
          ],
        )
      ];


    }
  }  catch (e) {
    // no API response
    print(e);
    return null;
  }
  return null;
}


dynamic pieCouponUsage(String uid) async {
  String strURL = "ANONYMIZED";
  String route = "ANONYMIZED";
  Uri url = Uri.https(strURL, route, {
    "store_id": uid,
    'token': await AuthService().currentUser().getIdToken()
  });
  try {
    Response res = await get(url);

    if (res.statusCode == 200) {
      //print(res.body);
      dynamic _json = jsonDecode(res.body);

      //print(_json);
      return [
        new charts.Series<MySales, String>(
          id: 'Sales',
          colorFn: (MySales sales, _) => sales.color,
          //colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (MySales sales, _) => sales.label,
          measureFn: (MySales sales, _) => sales.value,
          //labelAccessorFn: (MySales sales, _) => '${sales.value}',
          data: [
            new MySales(
                charts.MaterialPalette.blue.shadeDefault,
                "Unused: " + _json["n_still_to_use_coupons"].toString(),
                _json["n_still_to_use_coupons"]),
            new MySales(
                charts.MaterialPalette.green.shadeDefault,
                "Used: " + _json["n_used_coupons"].toString(),
                _json["n_used_coupons"]),
          ],
        )
      ];


    }
  }  catch (e) {
    // no API response
    print(e);
    return null;
  }
  return null;
}

Future<double> revenue(String uid) async {
  String strURL = "ANONYMIZED";
  String route = "ANONYMIZED";
  Uri url = Uri.https(strURL, route, {
    "store_id": uid,
    'token': await AuthService().currentUser().getIdToken()
  });
  try {
    Response res = await get(url);

    if (res.statusCode == 200) {
      //print(res.body);
      dynamic _json = jsonDecode(res.body);
      //print(_json);
      return _json["revenue"];



    }
  }  catch (e) {
    // no API response
    print(e);
    return null;
  }
  return null;
}

Future<int> nTaps(String uid) async {
  String strURL = "ANONYMIZED";
  String route = "ANONYMIZED";
  Uri url = Uri.https(strURL, route, {
    "store_id": uid,
    'token': await AuthService().currentUser().getIdToken()
  });
  try {
    Response res = await get(url);

    if (res.statusCode == 200) {
      //print(res.body);
      dynamic _json = jsonDecode(res.body);
      //print(_json);
      return _json["n_taps"];



    }
  }  catch (e) {
    // no API response
    print(e);
    return null;
  }
  return null;
}

Future<int> nCustomers(String uid) async {
  String strURL = "ANONYMIZED";
  String route = "ANONYMIZED";
  Uri url = Uri.https(strURL, route, {
    "store_id": uid,
    'token': await AuthService().currentUser().getIdToken()
  });
  try {
    Response res = await get(url);

    if (res.statusCode == 200) {
      //print(res.body);
      dynamic _json = jsonDecode(res.body);
      //print(_json);
      return _json["n_customers"];

    }
  }  catch (e) {
    // no API response
    print(e);
    return null;
  }
  return null;
}

Future<int> nWonCoupons(String uid) async {
  String strURL = "ANONYMIZED";
  String route = "ANONYMIZED";
  Uri url = Uri.https(strURL, route, {
    "store_id": uid,
    'token': await AuthService().currentUser().getIdToken()
  });
  try {
    Response res = await get(url);

    if (res.statusCode == 200) {
      //print(res.body);
      dynamic _json = jsonDecode(res.body);
      //print(_json);
      return _json["n_won_coupons"];

    }
  }  catch (e) {
    // no API response
    print(e);
    return null;
  }
  return null;
}



