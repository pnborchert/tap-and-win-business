import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:tw_business_app/models/coupon.dart';
import 'package:intl/intl.dart';
import 'package:tw_business_app/screen/home/coupon/qr_code.dart';
import 'package:tw_business_app/shared/constants.dart';

class CouponDetails extends StatefulWidget {
  final Coupon coupon;
  CouponDetails({this.coupon});
  @override
  _CouponDetailsState createState() => _CouponDetailsState();
}

class _CouponDetailsState extends State<CouponDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xFF43bffb),
                Color(0xFF0078ff),
              ]),
        )),
        title: Text("Details"),
      ),
      body: ListView(children: <Widget>[
        // Center(
        //   child: CircleAvatar(
        //     radius: 100,
        //     child: Image(
        //       image: FirebaseImage(
        //           'anonymous' + widget.coupon.image),
        //       fit: BoxFit.cover,
        //       // width: 150,
        //       // height: 150,
        //     ),
        //   ),
        // ),
        Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 20),
          child: CircleAvatar(
            radius: 75,
            backgroundColor: Colors.white,
            backgroundImage: FirebaseImage(
                'anonymous' + widget.coupon.image),
          ),
        ),
        Center(child:
        Padding(
          padding:EdgeInsets.only(top: 10.0,left: 10.0, right: 10.0,bottom: 4.0),
          child: Text("\"" + widget.coupon.description +"\""  , textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.italic),),
        ),),
        ListTile(
          leading: Icon(Icons.shopping_basket),
          title: Text("Item"),
          subtitle: Text(widget.coupon.title),
        ),
        ListTile(
          leading: Icon(Icons.date_range),
          title: Text("Expiry Date"),
          subtitle: Text(DateFormat('dd-MM-yyyy')
              .format(widget.coupon.expiry_date.toDate())),
        ),
        ListTile(
          leading: Icon(Icons.euro_rounded),
          title: Text("Orginal Price"),
          subtitle: Text(widget.coupon.old_price.toString()),
        ),
        ListTile(
          leading: Icon(Icons.euro_rounded),
          title: Text("New Price"),
          subtitle: Text(widget.coupon.new_price.toString()),
        ),
        Center(
            child: ButtonTheme(
          minWidth: 150,
          child: ElevatedButton(
            child: Text('Use'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => QRCoupon(
                  coupon: widget.coupon,
                ),
              );
            },
          ),
        ))
      ]),
    );
  }
}
