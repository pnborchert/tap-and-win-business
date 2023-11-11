import 'package:flutter/material.dart';

class NoCoupons extends StatefulWidget {
  const NoCoupons({Key key}) : super(key: key);

  @override
  _NoCouponsState createState() => _NoCouponsState();
}

class _NoCouponsState extends State<NoCoupons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
        ),
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
          child: Text("No Coupons found :(",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }
}
