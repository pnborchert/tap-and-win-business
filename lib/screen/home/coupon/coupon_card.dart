import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:tw_business_app/models/coupon.dart';
import 'package:tw_business_app/screen/home/coupon/coupon_details.dart';
import 'package:tw_business_app/screen/home/coupon/coupon_list.dart';
import 'package:tw_business_app/shared/api.dart';

class CouponCard extends StatefulWidget {
  final Coupon coupon;
  final Function setPushCoupon;
  final Function refreshCouponList;
  CouponCard({this.coupon, this.setPushCoupon, this.refreshCouponList});
  @override
  _CouponCardState createState() => _CouponCardState();
}

class _CouponCardState extends State<CouponCard> {
  @override
  void initState() {
    super.initState();
  }

  Widget statusBubble(Color color, double opacity) {
    return new Container(
      alignment: Alignment.centerLeft,
      width: 10,
      height: 10,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: color.withOpacity(opacity)),
    );
  }

  Future<String> showDetails(bool tapped) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CouponDetails(
                  coupon: widget.coupon,
                )));
  }

  List<Widget> displayStatus(
      bool is_active, bool is_valid, Timestamp expiry_date) {
    double opacityRed = 0.1;
    double opacityOrange = 0.1;
    double opacityGreen = 0.15;

    if ((is_active == false) & (is_valid == false)) {
      opacityRed = 1;
    } else if (expiry_date.toDate().difference(DateTime.now()).inDays < 30) {
      opacityOrange = 1;
    } else if ((is_active == false) | (is_valid == false)) {
      opacityOrange = 1;
    } else {
      opacityGreen = 1;
    }

    return [
      statusBubble(Colors.red, opacityRed),
      SizedBox(width: 5),
      statusBubble(Colors.orange, opacityOrange),
      SizedBox(width: 5),
      statusBubble(Colors.green, opacityGreen),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () async {
          String coupon_id = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CouponDetails(
                        coupon: widget.coupon,
                        refreshCouponList: widget.refreshCouponList,
                      )));
          if (coupon_id != null) {
            await widget.setPushCoupon(coupon_id);
          }
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
                  backgroundImage: NetworkImage(widget.coupon.image),
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
                padding: EdgeInsets.symmetric(vertical: 35, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: displayStatus(widget.coupon.is_active,
                      widget.coupon.is_valid, widget.coupon.expiry_date),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
