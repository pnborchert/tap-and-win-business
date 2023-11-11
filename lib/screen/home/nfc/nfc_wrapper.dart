import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math' as math show sin, pi, sqrt;
import 'package:easy_localization/easy_localization.dart';
import 'package:tw_business_app/screen/home/nfc/nfc_widget.dart';
import 'package:tw_business_app/shared/animation_ripple/circle_painter.dart';

class NfcWrapper extends StatefulWidget {
  @override
  _NfcWrapperState createState() => _NfcWrapperState();
}

class _NfcWrapperState extends State<NfcWrapper> with TickerProviderStateMixin {
  bool activated = false;
  bool platformSupport = true;
  AnimationController _controller;

  void switchActivated() {
    setState(() {
      if (Platform.isIOS) {
        activated = !activated;
      }
    });
  }

  Future<bool> checkPlatform() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    // filter old iphone models
    // NOTE: Iphone 6/6s/6plus/6splus model correspondence https://www.theiphonewiki.com/wiki/Models#iPhone
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      // if old iphone return false
      if (["iphone7,1", "iphone7,2", "iphone8,1", "iphone8,2"]
          .contains(iosInfo.model.toLowerCase())) {
        return false;
      }
    }
    return true;
  }

  Future<bool> checkNFC() async {
    return await NFC.isNDEFSupported;
  }

  void showDialogNFC() {
    Alert(
      context: context,
      title: 'nfcAlert'.tr(),
      desc: 'nfcAlertMessage'.tr(),
      image:  Image.asset(
          "assets/images/nfcsquare.gif"
      ),
    ).show();
    /*
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('nfcAlert'.tr())),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/nfcsquare.gif",
                    height: 125,
                  ),
                  Flexible(child: Text('nfcAlertMessage'.tr()))
                ],
              )
            ],
          );
        });

     */
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _controller.repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return platformSupport
        ? activated
        ? ActivateNfc(switchActivated: switchActivated)
        : Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "tapToActivate".tr(),
          style: TextStyle(
              fontFamily: "Arial",
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 30,
        ),
        CustomPaint(
          painter: CirclePainter(
            _controller,
            circleSize: -50,
            color: Colors.grey[400].withOpacity(0.1),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF43bffb),
                            Color(0xFF0078ff),
                          ]),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(
                              5, 5), // changes position of shadow
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: IconButton(
                      iconSize: 200,
                      icon: Image.asset(
                        'assets/images/logo_square.png',
                      ),
                      onPressed: () async {
                        // check platform
                        bool platformCheck = await checkPlatform();
                        // check nfc availability
                        bool nfcCheck = await checkNFC();

                        if (platformCheck) {
                          if (nfcCheck) {
                            // read NFC
                            setState(() => activated = !activated);
                          } else {
                            // turn on NFC
                            showDialogNFC();
                          }
                        } else {
                          // show device not supported
                          setState(() => platformSupport = false);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    )
        : AnimatedOpacity(
      opacity: 0.0,
      duration: Duration(milliseconds: 1000),
      child: Text(
        "This device does not support NFC...".tr(),
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black),
      ),
    );
  }
}
