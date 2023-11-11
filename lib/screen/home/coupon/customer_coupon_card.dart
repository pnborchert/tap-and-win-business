import 'dart:io';

import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:tw_business_app/models/coupon.dart';
import 'package:tw_business_app/screen/home/coupon/customer_coupon_details.dart';
import 'package:tw_business_app/screen/home/coupon/qr_code.dart';

class CouponCard extends StatefulWidget {
  final Coupon coupon;
  final bool localImage;

  CouponCard({this.coupon, this.localImage});

  @override
  _CouponCardState createState() => _CouponCardState();
}

class _CouponCardState extends State<CouponCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
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
                  backgroundImage:
                      (widget.localImage != null && widget.localImage)
                          ? Image.file(File(widget.coupon.image)).image
                          : NetworkImage(widget.coupon.image),
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
                      widget.coupon.new_price > 0
                          ? (widget.coupon.new_price.toString() + "€")
                          : "Free",
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
                      style: TextStyle(decoration: TextDecoration.lineThrough),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: ElevatedButton(
                  child: Text("Use"),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => QRCoupon(
                        coupon: widget.coupon,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
