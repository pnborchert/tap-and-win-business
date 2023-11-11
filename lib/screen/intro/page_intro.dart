import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:tw_business_app/shared/constants.dart';
import 'package:easy_localization/easy_localization.dart';
class Introduction extends StatefulWidget {
  const Introduction({Key key, this.switchShowIntro}) : super(key: key);
  final Function switchShowIntro;

  @override
  _IntroductionState createState() => _IntroductionState();
}

final introKey = GlobalKey<IntroductionScreenState>();

Widget _buildImage(String assetName, [double width = 350]) {
  return Image.asset('assets/$assetName', width: width);
}

class _IntroductionState extends State<Introduction> {
  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    void pop() {
      if (widget.switchShowIntro == null) {
        return Navigator.pop(context);
      } else {
        return widget.switchShowIntro();
      }
    }

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      showNextButton: false,
      showDoneButton: true,
      pages: [
        PageViewModel(
          title: "findOutHow".tr(),
          bodyWidget: Column(
            children: [
              ListTile(
                title: Text("Advertising".tr()),
                subtitle: Text(
                    "whatYouCan".tr()),
              ),
              ListTile(
                title: Text("loyalty".tr()),
                subtitle: Text(
                    "yourService".tr()),
              ),
            ],
          ),
          image: _buildImage('images/sticker_logo.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "getStarted".tr(),
          body:
              "requestSticker".tr(),
          image: _buildImage('images/sticker_info.gif'),
          decoration: pageDecoration.copyWith(
            bodyFlex: 2,
            imageFlex: 4,
            bodyAlignment: Alignment.bottomCenter,
            imageAlignment: Alignment.topCenter,
          ),
          reverse: true,
        ),
        PageViewModel(
          title: "activateSticker".tr(),
          body:
              "tapOnSticker".tr(),
          image: _buildImage('images/tap_gif_rectangle2.gif'),
          decoration: pageDecoration.copyWith(
            imageFlex: 3,
            bodyAlignment: Alignment.center,
            imageAlignment: Alignment.center,
          ),
          reverse: false,
        ),
        PageViewModel(
          title: "createCoupon".tr(),
          body:
          "createCouponBecause".tr(),
          image: _buildImage("images/coupon_info.gif"),
          decoration: pageDecoration.copyWith(
            bodyFlex: 2,
            imageFlex: 4,
            bodyAlignment: Alignment.bottomCenter,
            imageAlignment: Alignment.topCenter,
          ),
          reverse: true,
        ),
        /*
        PageViewModel(
          title: "Create a Coupon",
          body:
              "Create and customize your coupons fast and easy. The coupons are validated by us before customers can win them.",
          image: _buildImage("images/coupon_info.gif"),//'images/img2.jpg'
          decoration: pageDecoration,
        ),

         */
        PageViewModel(
          title: "Dashboard",
          body: "growingBusiness".tr(),
          decoration: pageDecoration.copyWith(
            bodyFlex: 3,
            imageFlex: 4,
            bodyAlignment: Alignment.bottomCenter,
            imageAlignment: Alignment.topCenter,
          ),
          image: _buildImage('images/dashbaord_simple.png'),
          reverse: true,
        ),
      ],
      onDone: () => pop(),
      onSkip: () => pop(),
      done: Text('done'.tr(), style: TextStyle(color: Colors.white)),
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip:  Text(
        "skip".tr(),
        style: TextStyle(color: Colors.white),
      ),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(15.0),
      controlsPadding: const EdgeInsets.all(5.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeColor: Colors.white,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        gradient: LinearGradient(colors: blueGradients),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
