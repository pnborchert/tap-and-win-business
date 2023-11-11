import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:tw_business_app/models/nfc.dart';
import 'package:tw_business_app/screen/home/nfc/nfc_details.dart';

import 'package:tw_business_app/services/auth.dart';
import 'package:tw_business_app/shared/animation_ripple/circle_painter.dart';
import 'package:tw_business_app/shared/animation_ripple/curve_wave.dart';
import 'package:tw_business_app/shared/api.dart';
import 'package:tw_business_app/shared/constants.dart';
import 'package:easy_localization/easy_localization.dart';

class ActivateNfc extends StatefulWidget {
  const ActivateNfc({
    Key key,
    this.size = 100.0,
    this.color = colBlue,
    this.onPressed,
    this.child,
    this.switchActivated,
  }) : super(key: key);
  final double size;
  final Color color;
  final Widget child;
  final VoidCallback onPressed;
  final Function switchActivated;

  @override
  _ActivateNfcState createState() => _ActivateNfcState();
}

class _ActivateNfcState extends State<ActivateNfc>
    with TickerProviderStateMixin {
  AnimationController _controller;
  bool _ripple = true;
  double _fadeIn = 0.5;
  double _fadeIn2 = 0.0;
  String _userUID = AuthService().currentUser().uid;

  // Read NFC
  StreamSubscription<NDEFMessage> _stream;
  bool _supportsNFC = false;

  // _tags is a list of scanned tags
  List<NDEFMessage> _tags = [];

  // _readNFC() calls `NFC.readNDEF()` and stores the subscription and scanned
  // tags in state
  void _readNFC(BuildContext context) {
    try {
      // ignore: cancel_subscriptions
      StreamSubscription<NDEFMessage> subscription =
          NFC.readNDEF().listen((tag) {
        // On new tag, add it to state
        setState(() {
          _tags.insert(0, tag);
          //print(tag.payload.toString());

          // call api
          //print(_userUID);
          print(tag.payload.toString());
          parseNfcUrl(tag.payload.toString()).then((v) async {
            await tapAPI(_userUID).then((Nfc nfc) {
              if (nfc != null) {
                _stream.cancel();
                // show win
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NfcDetails(nfc: nfc)))
                    .then((value) => widget.switchActivated());
              } else {

                showAlert(context,"Oops!", 'error'.tr());


                //print("No Coupon obtained!");
              }
            });
          });
        });
      },
              // When the stream is done, remove the subscription from state
              onDone: () {
        setState(() {
          //_stream = null;
          _stream.cancel();
        });
      }, onError: (e) {
        setState(() {
          //_stream = null;
          _stream.cancel();
        });
        if (_tags.isEmpty) {
          setState(() => _ripple = !_ripple);
          _ripple ? _controller.repeat() : _controller.reset();
          widget.switchActivated();
        }

        if (!(e is NFCUserCanceledSessionException)) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Error!"),
              content: Text(e.toString()),
            ),
          );
        }
      });

      setState(() {
        _stream = subscription;
      });
    } catch (err) {
      print("error: $err");
    }
  }

  @override
  void initState() {
    super.initState();
    // NFC supported?
    NFC.isNDEFSupported.then((supported) async {
       DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        print('Running on ${iosInfo.utsname.machine}');
        setState(() {
          _supportsNFC =
              supported && !["iphone7,1","iphone7,2","iphone8,1","iphone8,2"].contains(iosInfo.model.toLowerCase()); // NOTE: Iphone 6/6s/6plus/6splus corresponds to https://www.theiphonewiki.com/wiki/Models#iPhone
          _readNFC(context);
        });
      } else {
        setState(() {
          _supportsNFC = supported;
          _readNFC(context);
        });
     }
    });

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    )..repeat();
    Future.delayed(Duration(milliseconds: 400), () {
      setState(() {
        _fadeIn = 1.0;
        _fadeIn2 = 1.0;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    _stream?.cancel();
  }

  Widget _logoButton() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.size),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: <Color>[
                widget.color,
                Color.lerp(widget.color, Colors.black, .02)
              ],
            ),
          ),
          child: ScaleTransition(
            scale: Tween(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(
                parent: _controller,
                curve: const CurveWave(),
              ),
            ),
            child: IconButton(
              iconSize: 200,
              icon: Image.asset(
                'assets/images/logo_square.png',
              ),
              onPressed: () {
                setState(() => _ripple = !_ripple);
                _ripple ? _controller.repeat() : _controller.reset();
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _fadeIn,
      duration: Duration(milliseconds: 1000),
      child: Center(
        child: _supportsNFC
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    !_ripple ? 'tapToActivate'.tr() : "",
                    style: TextStyle(
                        fontFamily: "Arial",
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  CustomPaint(
                    painter: CirclePainter(
                      _controller,
                      circleSize: 0,
                      color: widget.color,
                    ),
                    child: Stack(children: [
                      SizedBox(
                          width: widget.size * 5,
                          height: widget.size * 4,
                          child: _logoButton()),
                    ]),
                  ),
                ],
              )
            : AnimatedOpacity(
                opacity: _fadeIn2,
                duration: Duration(milliseconds: 1000),
                child: Text(
                  'noNFC'.tr(),
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
      ),
    );
  }
}
