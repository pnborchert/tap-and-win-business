import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
//import 'package:tw_business_app/models/coupon.dart';
import 'package:tw_business_app/models/user.dart';
import 'package:tw_business_app/screen/authenticate/authenticate.dart';
import 'package:tw_business_app/screen/intro/wrapper_intro.dart';
import 'package:tw_business_app/services/auth.dart';
//import 'package:tw_business_app/screen/home/win/win.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);

    // return home or athenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      user.updateFCMToken();


      /*
      if(! AuthService().currentUser().emailVerified){
        Alert(
          context: context,
          type: AlertType.warning,
          title: "Confirm Email",
          desc: "Please check your email box and validate your email ",
          buttons: [
            DialogButton(
              child: Text(
                "Resend",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () async{ AuthService().currentUser().sendEmailVerification();},
              color: Color.fromRGBO(0, 179, 134, 1.0),
            ),
            DialogButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              gradient: LinearGradient(colors: [
                Color.fromRGBO(116, 116, 191, 1.0),
                Color.fromRGBO(52, 138, 199, 1.0)
              ]),
            )
          ],
        ).show();



      }

       */
      /*
      callAPI(user.uid).then((Coupon coupon) {
        if (!coupon.isNull()) {
          // show win
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WinCoupon(coupon: coupon)));
        } else {}
      });

       */
      return WrapperIntro();
    }
  }
}
