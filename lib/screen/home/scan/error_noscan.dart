import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
class noScan extends StatefulWidget {
  const noScan({Key key}) : super(key: key);

  @override
  _noScanState createState() => _noScanState();
}

class _noScanState extends State<noScan> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF43bffb),
                      Color(0xFF0078ff),
                    ]),
                shape: BoxShape.circle),
            child: IconButton(
              padding: EdgeInsets.all(10),
              iconSize: 100,
              icon: Image.asset(
                'assets/images/logo_square.png',
              ),
              onPressed: () {
                setState(() {});
              },
            )),
        Container(
          padding: EdgeInsets.only(top: 10),
          child: Text('noScanFound'.tr(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }
}
