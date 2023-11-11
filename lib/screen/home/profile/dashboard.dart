import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import 'package:tw_business_app/models/user.dart';
import 'package:tw_business_app/shared/api.dart';
import 'package:tw_business_app/shared/dashboard_api.dart';
import 'package:tw_business_app/shared/loading.dart';
import 'package:easy_localization/easy_localization.dart';

class allDashboardData {
  List<charts.Series<OrdinalSales, String>> barTapsAge;
  List<charts.Series<OrdinalSales, String>> barTapsMonthly;
  List<charts.Series<MySales, String>> pieTapsGender;

  //List<charts.Series<LinearSales, int>> dataLine;
  List<charts.Series<MySales, String>> pieCouponUsage;
  double revenue;
  int nTaps;
  int customers;
  int wonCoupons;

  allDashboardData(
      {this.barTapsAge,
        this.barTapsMonthly,
        //this.dataLine,
        this.pieTapsGender,
        this.pieCouponUsage,
        this.nTaps,
        this.revenue,
        this.customers,
        this.wonCoupons});
}

/// Sample ordinal data type.
class OrdinalSales {
  final String label;
  final int value;

  OrdinalSales(this.label, this.value);
}

class GaugeSegment {
  final String segment;
  final int size;

  GaugeSegment(this.segment, this.size);
}

class MySales {
  final charts.Color color;
  final String label;
  final int value;

  MySales(this.color, this.label, this.value);
}

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}

class DashboardPage extends StatefulWidget {
  final List<charts.Series> seriesListBar;
  final bool animate;
  final List<charts.Series> seriesListLIne;

  const DashboardPage(
      {Key key, this.seriesListBar, this.animate, this.seriesListLIne})
      : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleDataBar() {
    final data = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

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

  static List<charts.Series<LinearSales, int>> _createSampleDataLine() {
    final data = [
      new LinearSales(0, 5),
      new LinearSales(1, 25),
      new LinearSales(2, 100),
      new LinearSales(3, 75),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<GaugeSegment, String>> _createSampleDataGauge() {
    final data = [
      new GaugeSegment('Low', 75),
      new GaugeSegment('Acceptable', 100),
      new GaugeSegment('High', 50),
      new GaugeSegment('Highly Unusual', 5),
    ];

    return [
      new charts.Series<GaugeSegment, String>(
        id: 'Segments',
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        data: data,
      )
    ];
  }

  /// Create series list with one series
  static List<charts.Series<MySales, String>> _createSampleDataPie() {
    final data = [
      new MySales(charts.MaterialPalette.red.shadeDefault, '2014', 5),
      new MySales(charts.MaterialPalette.blue.shadeDefault, '2015', 25),
      new MySales(charts.MaterialPalette.yellow.shadeDefault, '2016', 100),
    ];
    return [
      new charts.Series<MySales, String>(
        id: 'Sales',
        colorFn: (MySales sales, _) => sales.color,
        //colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (MySales sales, _) => sales.label,
        measureFn: (MySales sales, _) => sales.value,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    AppUser _authUser = Provider.of<AppUser>(context);

    Future<allDashboardData> _getDashboardData(String uid) async {
      // for parallel calls
      dynamic pieTapsGenderResult = pieTapsGender(uid);
      dynamic barTapsMonthlyResult = barTapsMonthly(uid);
      dynamic barTapsAgeResult = barTapsAge(uid);
      dynamic pieCouponUsageResult = pieCouponUsage(uid);
      Future<double> revenueResult = revenue(uid);
      Future<int> nTapsResult = nTaps(uid);
      Future<int> nCustomersResult = nCustomers(uid);
      Future<int> nWonCouponsResult = nWonCoupons(uid);

      return allDashboardData(
          pieTapsGender: await pieTapsGenderResult,
          barTapsMonthly: await barTapsMonthlyResult,
          barTapsAge: await barTapsAgeResult,
          pieCouponUsage: await pieCouponUsageResult,
          revenue: await revenueResult,
          nTaps: await nTapsResult,
          customers: await nCustomersResult,
          wonCoupons: await nWonCouponsResult);
    }

    return FutureBuilder<allDashboardData>(
        future: _getDashboardData(_authUser.uid),
        builder: (context, allDashboardData) {
          return allDashboardData.hasData
              ? Scaffold(
            // appBar: AppBar(
            //   flexibleSpace: Container(
            //       decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //         begin: Alignment.topLeft,
            //         end: Alignment.topRight,
            //         colors: [
            //           Color(0xFF43bffb),
            //           Color(0xFF0078ff),
            //         ]),
            //   )),
            //   title: Text("Dashboard"),
            //   elevation: 0.0,
            // ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(right: 10, left: 10, top: 20),
                  child:
                  Column(mainAxisSize: MainAxisSize.min, children: <
                      Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width:
                          MediaQuery.of(context).size.width / 2 - 10,
                          height: 80,
                          child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(10.0)),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(
                                        Icons.euro_rounded,
                                        size: 30,
                                        color: Colors.yellow[600],
                                      ),
                                      title: Text('revenue'.tr(),
                                          style: TextStyle(
                                              color: Colors.black)),
                                      subtitle: Text(
                                          allDashboardData.data.revenue
                                              .toString() +
                                              " €",
                                          style: TextStyle(
                                              color: Colors.black)),
                                    ),
                                  ])),
                        ),
                        Container(
                          width:
                          MediaQuery.of(context).size.width / 2 - 10,
                          height: 80,
                          child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(10.0)),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(
                                          Icons.emoji_people_rounded,
                                          size: 30,
                                          color: Colors.blue),
                                      title: Text('uniqueCustomers'.tr(),
                                          style: TextStyle(
                                              color: Colors.black)),
                                      subtitle: Text(
                                          allDashboardData.data.customers
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.black)),
                                    ),
                                  ])),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width:
                          MediaQuery.of(context).size.width / 2 - 10,
                          height: 80,
                          child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(10.0)),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(
                                        Icons.local_play,
                                        size: 30,
                                        color: Colors.orange[800],
                                      ),
                                      title: Text('activeCoupons'.tr(),
                                          style: TextStyle(
                                              color: Colors.black)),
                                      subtitle: Text(
                                          allDashboardData.data.wonCoupons
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.black)),
                                    ),
                                  ])),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width:
                          MediaQuery.of(context).size.width / 2 - 10,
                          height: 250,
                          child: Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  title: Text('Coupons'),
                                ),
                                SizedBox(
                                    height: 180,
                                    width: MediaQuery.of(context).size.width /2 -10,
                                    child: charts.PieChart(
                                      allDashboardData
                                          .data.pieCouponUsage,
                                      animate: false,
                                      // Configure the width of the pie slices to 30px. The remaining space in
                                      // the chart will be left as a hole in the center. Adjust the start
                                      // angle and the arc length of the pie so it resembles a gauge.
                                      /*defaultRenderer:
                                                new charts.ArcRendererConfig(
                                                    arcWidth: 15,
                                                    startAngle: 1 * pi,
                                                    arcLength: 1 * pi),*/
                                      behaviors: [
                                        new charts.DatumLegend(
                                            horizontalFirst: false
                                        )
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width:
                          MediaQuery.of(context).size.width / 2 - 10,
                          height: 250,
                          child: Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  title: Text('Total taps'),
                                  //subtitle: Text(''),
                                ),
                                SizedBox(
                                  height: 180,
                                  width:
                                  MediaQuery.of(context).size.width /
                                      2 -
                                      10,
                                  child: charts.BarChart(
                                    allDashboardData.data.barTapsMonthly,
                                    animate: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    /*
                          Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.emoji_people_rounded),
                                  title: Text('Customers'),
                                  //subtitle: Text('Subtitle 2.'),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.7,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: charts.LineChart(
                                    allDashboardData.data.barTapsMonthly,
                                    animate: false,
                                  ),
                                ),
                              ],
                            ),
                          ),

                           */
                    Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text('Customers - Gender'),
                          ),
                          SizedBox(
                              height:
                              MediaQuery.of(context).size.width * 0.7,
                              width:
                              MediaQuery.of(context).size.width * 0.8,
                              child: charts.PieChart(
                                allDashboardData.data.pieTapsGender,
                                animate: false,

                                // Add the series legend behavior to the chart to turn on series legends.
                                // By default the legend will display above the chart.
                                behaviors: [
                                  new charts.DatumLegend(
                                    // Positions for "start" and "end" will be left and right respectively
                                    // for widgets with a build context that has directionality ltr.
                                    // For rtl, "start" and "end" will be right and left respectively.
                                    // Since this example has directionality of ltr, the legend is
                                    // positioned on the right side of the chart.
                                    position: charts.BehaviorPosition.end,
                                    // By default, if the position of the chart is on the left or right of
                                    // the chart, [horizontalFirst] is set to false. This means that the
                                    // legend entries will grow as new rows first instead of a new column.
                                    horizontalFirst: false,
                                    // This defines the padding around each legend entry.
                                    cellPadding: new EdgeInsets.only(
                                        right: 4.0, bottom: 4.0),
                                    // Set [showMeasures] to true to display measures in series legend.
                                    showMeasures: true,
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width:
                          MediaQuery.of(context).size.width / 2 + 40,
                          height: 250,
                          child: Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  title: Text('customerAge'.tr()),
                                ),
                                SizedBox(
                                  height: 180,
                                  width:
                                  MediaQuery.of(context).size.width /
                                      2,
                                  child: charts.BarChart(
                                    allDashboardData.data.barTapsAge,
                                    vertical: false,
                                    animate: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ),
          )
              : Loading();
        });
  }
}
