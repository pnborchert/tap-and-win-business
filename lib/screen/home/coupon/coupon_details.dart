import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tw_business_app/models/coupon.dart';
import 'package:intl/intl.dart';
import 'package:tw_business_app/screen/home/coupon/edit_coupon.dart';
import 'package:tw_business_app/screen/home/coupon/qr_code.dart';
import 'package:tw_business_app/shared/api.dart';
import 'package:easy_localization/easy_localization.dart';

class CouponDetails extends StatefulWidget {
  final Coupon coupon;
  final Function refreshCouponList;

  CouponDetails({this.coupon, this.refreshCouponList});

  @override
  _CouponDetailsState createState() => _CouponDetailsState();
}

class _CouponDetailsState extends State<CouponDetails> {
  List<Widget> statusCoupon(bool is_active, bool is_valid) {
    Color colValid;
    Icon iconValid;
    Color colActive;
    Icon iconActive;

    if (is_active == true) {
      colActive = Colors.green;
      iconActive = Icon(Icons.check, color: colActive);
    } else {
      colActive = Colors.red;
      iconActive = Icon(Icons.close, color: colActive);
    }
    if (is_valid == true) {
      colValid = Colors.green;
      iconValid = Icon(Icons.check, color: colValid);
    } else {
      colValid = Colors.red;
      iconValid = Icon(
        Icons.close,
        color: colValid,
      );
    }

    return [
      Text(
        'valid'.tr(),
        style: TextStyle(color: colValid),
      ),
      iconValid,
      SizedBox(width: 15),
      Text(
        'active'.tr(),
        style: TextStyle(color: colActive),
      ),
      iconActive
    ];
  }

  Widget statusExpiry(Timestamp expiry_date) {
    int _days = expiry_date.toDate().difference(DateTime.now()).inDays;
    Widget _date = Text(
        DateFormat('dd-MM-yyyy').format(widget.coupon.expiry_date.toDate()));
    if (_days < 30) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _date,
          Text(
            'daysLeft'.tr() + " $_days",
            style: TextStyle(color: Colors.orange),
          ),
        ],
      );
    } else {
      return _date;
    }
  }

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
        title: Text('details'.tr()),
      ),
      body: ListView(children: <Widget>[
        Stack(alignment: Alignment.topCenter, children: [
          Container(
            width: double.infinity,
            height: 100,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color(0xFF43bffb),
                      Color(0xFF0078ff),
                    ]),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 20),
            child: CircleAvatar(
              radius: 75,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(widget.coupon.image),
            ),
          ),
        ]),
        Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 10),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: widget.coupon.is_valid
                                ? (widget.coupon.is_active
                                    ? Colors.green
                                    : Colors.red)
                                : Colors.red),
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          widget.coupon.is_valid
                              ? 'status'.tr() +
                                  (widget.coupon.is_active
                                      ? 'active'.tr()
                                      : 'deactivated'.tr())
                              : 'inValidation'.tr(),
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: widget.coupon.is_valid
                                  ? (widget.coupon.is_active
                                      ? Colors.green
                                      : Colors.red)
                                  : Colors.red),
                        ))),
              ]),
        ),
        /*
        Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                statusCoupon(widget.coupon.is_active, widget.coupon.is_valid),
          ),
        ),
         */
        ListTile(
          leading: Icon(Icons.shopping_basket),
          title: Text('item').tr(),
          subtitle: Text(widget.coupon.title),
        ),
        ListTile(
          leading: Icon(Icons.date_range),
          title: Text('expiryDate').tr(),
          subtitle: statusExpiry(widget.coupon.expiry_date),
        ),
        ListTile(
          leading: Icon(Icons.euro_rounded),
          title: Text('regulaPrice').tr(),
          subtitle: Text(widget.coupon.old_price.toString()),
        ),
        ListTile(
          leading: Icon(Icons.euro_rounded),
          title: Text('discountedPrice').tr(),
          subtitle: Text(widget.coupon.new_price.toString()),
        ),
        ListTile(
          leading: Icon(Icons.text_snippet_outlined),
          title: Text(
            'Description'.tr(),
          ),
          subtitle: Text(widget.coupon.description),
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all<Size>(Size(120, 40)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                )),
                backgroundColor: MaterialStateProperty.all(Colors.blue[500]),
                //Background Color
                elevation: MaterialStateProperty.all(0),
                //Defines Elevation
                shadowColor: MaterialStateProperty.all(
                    Colors.blue[500]), //Defines shadowColor
              ),
              onPressed: () async {
                if (!(!widget.coupon.is_valid || !widget.coupon.is_active)) {
                  Alert(
                          context: context,
                          title: 'warning'.tr(),
                          desc: 'pleaseDeactivate'.tr())
                      .show();
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditCoupon(
                                coupon: widget.coupon,
                                refreshCouponList: widget.refreshCouponList,
                              )));
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.coupon.is_active
                      ? Icon(
                          Icons.lock,
                          color: Colors.white,
                        )
                      : Icon(
                          Icons.lock_open,
                          color: Colors.white,
                        ),
                  Text('edit'.tr(),
                      style: TextStyle(fontSize: 16.0, color: Colors.white)),
                ],
              ),
            )
            /*TextButton.icon(
              icon: widget.coupon.is_active
                  ? Icon(
                      Icons.lock,
                      color: Colors.white,
                    )
                  : Icon(
                      Icons.lock_open,
                      color: Colors.white,
                    ),
              label: Text('Edit',
                  style: TextStyle(fontSize: 16.0, color: Colors.white)),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue)),
              onPressed: () {
                if (!(!widget.coupon.is_valid || !widget.coupon.is_active)) {
                  Alert(
                          context: context,
                          title: "Warning",
                          desc: "Please deactivate the coupon before editing!")
                      .show();
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditCoupon(
                                coupon: widget.coupon,
                                refreshCouponList: widget.refreshCouponList,
                              )));
                }
              },
            )*/
            ,
            SizedBox(
              width: 10.0
            ),
            widget.coupon.is_active
                ? TextButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(Size(120, 40)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.red[400]),
                      //Background Color
                      elevation: MaterialStateProperty.all(0),
                      //Defines Elevation
                      shadowColor: MaterialStateProperty.all(
                          Colors.red[400]), //Defines shadowColor
                    ),
                    onPressed: () async {
                      await showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: Text('AreYouSure'.tr()),
                                content: Text('youCanEditOrDelete'.tr()),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await postStatusCoupon(widget.coupon.id);
                                      Navigator.pop(context);
                                      Navigator.pop(context, widget.coupon.id);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('deactivate'.tr(),
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white)),
                      ],
                    ),
                  )
                /*TextButton(
                    child: Text('Deactivate',
                        style: TextStyle(fontSize: 16.0, color: Colors.white)),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red)),
                    onPressed: () async {
                      await showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('Are you sure?'),
                                content: const Text(
                                    'You can edit or delete the coupon after deactivation.\n\nPlease note:\nInactive coupons will not be shown to customers (this does not affect already existing coupons).\nRe-activation requires a validation process, which may take a few days.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await postStatusCoupon(widget.coupon.id);
                                      Navigator.pop(context);
                                      Navigator.pop(context, widget.coupon.id);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ));
                    },
                  )*/
                : TextButton(
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all<Size>(Size(120, 40)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
                backgroundColor:
                MaterialStateProperty.all(Colors.green[400]),
                //Background Color
                elevation: MaterialStateProperty.all(0),
                //Defines Elevation
                shadowColor: MaterialStateProperty.all(
                    Colors.green[400]), //Defines shadowColor
              ),
              onPressed: () async {
                await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text('AreYouSure'.tr()),
                      content: Text('activationNotice'.tr()),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await postStatusCoupon(widget.coupon.id);
                            Navigator.pop(context);
                            Navigator.pop(context, widget.coupon.id);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('active'.tr(),
                      style:
                      TextStyle(fontSize: 16.0, color: Colors.white)),
                ],
              ),
            ),
          ],
        )
      ]),
    );
  }
}
