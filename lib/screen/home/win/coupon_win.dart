import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:tw_business_app/models/coupon.dart';
import 'package:tw_business_app/screen/home/coupon/customer_coupon_details.dart';

class ScreenWin extends StatefulWidget {
  final Coupon coupon;
  ScreenWin({this.coupon});
  @override
  _ScreenWinState createState() => _ScreenWinState();
}

class _ScreenWinState extends State<ScreenWin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width - 50,
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CouponDetails(
                          coupon: widget.coupon,
                        )));
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(width: 2, color: Colors.white70),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(5, 2),
                  ),
                ]),
            child: Stack(
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  tileColor: Colors.white,
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: FirebaseImage(
                        "ANONYMIZED" + widget.coupon.image),
                  ),
                  title: Text(
                    widget.coupon.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 30)),
                      Text(
                        widget.coupon.new_price.toString() + "€",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.green[800],
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        widget.coupon.old_price.toString(),
                        style:
                            TextStyle(decoration: TextDecoration.lineThrough),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
