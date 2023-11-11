import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tw_business_app/models/coupon.dart';
import 'package:tw_business_app/screen/home/coupon/customer_coupon_card.dart';
import 'package:tw_business_app/shared/api.dart';
import 'package:tw_business_app/shared/loading.dart';

class CouponList extends StatefulWidget {
  @override
  _CouponListState createState() => _CouponListState();
}

class _CouponListState extends State<CouponList> {
  @override
  Widget build(BuildContext context) {
    showBadge = false;
    final coupons = Provider.of<List<Future<Coupon>>>(context);
    if (coupons == null) {
      // print("No Coupons found ...");
      return Loading();
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Coupon>>(
            future: Future.wait(coupons),
            builder:
                (BuildContext context, AsyncSnapshot<List<Coupon>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return CouponCard(
                      coupon: snapshot.data[index],
                    );
                  },
                );
              } else {
                return Loading();
              }
            }),
      );
    }
  }
}
