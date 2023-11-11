import 'package:flutter/material.dart';
import 'package:tw_business_app/models/coupon.dart';
import 'package:tw_business_app/screen/home/coupon/coupon_card.dart';
import 'package:tw_business_app/screen/home/coupon/coupon_details.dart';
import 'package:tw_business_app/screen/home/coupon/create_coupon.dart';
import 'package:tw_business_app/screen/home/coupon/error_nocoupon.dart';
import 'package:tw_business_app/shared/api.dart';
import 'package:tw_business_app/shared/constants.dart';
import 'package:tw_business_app/shared/loading.dart';
import 'package:easy_localization/easy_localization.dart';
class CouponList extends StatefulWidget {
  const CouponList({Key key}) : super(key: key);

  @override
  _CouponListState createState() => _CouponListState();
}

class _CouponListState extends State<CouponList> {
  String pushCoupon;
  List<Coupon> _clist;

  void setPushCoupon(String coupon_id) async {
    pushCoupon = coupon_id;
    await refreshCouponList();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showPushCoupon());
  }

  void _showPushCoupon() {
    if (_clist.isNotEmpty) {
      _clist.forEach((el) {
        if (el.id == pushCoupon) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CouponDetails(
                    coupon: el,
                  )));
          pushCoupon = "";
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    refreshCouponList();
  }

  Future<void> refreshCouponList() async {
    _clist = await getCouponList();
    setState(() {});
  }

  Widget showList() {
    if ((_clist != null)) {
      if (_clist.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              physics: ScrollPhysics(),
              itemCount: _clist.length,
              itemBuilder: (context, index) {
                return CouponCard(
                  coupon: _clist[index],
                  setPushCoupon: setPushCoupon,
                  refreshCouponList: refreshCouponList,
                );
              },
            ),
          ),
        );
      } else {
        // return Loading();
        return NoCoupons();
      }
    } else {
      return Loading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(25),
              child:
              TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),

                      )
                  ),
                  backgroundColor:
                  MaterialStateProperty.all(Colors.blue),
                  //Background Color
                  elevation: MaterialStateProperty.all(3),
                  //Defines Elevation
                  shadowColor: MaterialStateProperty.all(
                      Colors.blue), //Defines shadowColor
                ),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateCoupon())).then((value) {
                    refreshCouponList();
                    setState(() {});
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'createNewCoupon'.tr(),
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              /*TextButton.icon(
                icon: Icon(Icons.add, color: Colors.white),
                label: Text(
                  "Create New Coupon",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(4),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17),
                          side: BorderSide(color: Colors.blue))),
                  shadowColor: MaterialStateProperty.all<Color>(Colors.grey),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateCoupon())).then((value) {
                    refreshCouponList();
                    setState(() {});
                  });
                },
              ),*/
            ),
            showList(),
          ],
        ),
      ),
    );
  }
}
