import 'package:flutter/material.dart';
import 'package:tw_business_app/models/coupon.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCoupon extends StatefulWidget {
  final Coupon coupon;
  QRCoupon({this.coupon});
  @override
  _QRCouponState createState() => _QRCouponState();
}

class _QRCouponState extends State<QRCoupon> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.coupon.title),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
              child: QrImage(
                padding: EdgeInsets.all(5.0),
                data: widget.coupon.id.toString(),
                version: QrVersions.auto,
                size: 250.0,
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        new TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
