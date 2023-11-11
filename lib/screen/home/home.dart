import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tw_business_app/ChangeLanguage.dart';
import 'package:tw_business_app/models/scan.dart';
import 'package:tw_business_app/screen/home/coupon/page_coupon.dart';
import 'package:tw_business_app/screen/home/help.dart';
import 'package:tw_business_app/screen/home/nfc/page_nfc.dart';
import 'package:tw_business_app/screen/home/page_nfc_list/page_nfc_list.dart';
import 'package:tw_business_app/screen/home/profile/page_profile.dart';
import 'package:tw_business_app/screen/home/qr_validation_camera.dart';

import 'package:tw_business_app/screen/home/scan/scan_list_widget.dart';
import 'package:tw_business_app/screen/home/twpage.dart';
import 'package:tw_business_app/screen/intro/page_intro.dart';
import 'package:tw_business_app/services/auth.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tw_business_app/shared/api.dart';
import 'package:easy_localization/easy_localization.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  final AuthService _auth = AuthService();
  int _selectedIndex = 0;
  List<TWPage> _pageOptions = <TWPage>[
    pageNfc,
    pageCoupon,
    pageNfcList,
    pageProfile,
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _pageOptions.elementAt(_selectedIndex).tabs,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            String tapId = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QRViewExample(),
                ));
            if (tapId != null) {
              Scan scan =
                  await couponValidation(_auth.currentUser().uid, tapId);
              if (scan!= null) {
                if(scan.code == 200) {
                  Alert(
                    context: context,
                    title: 'compliments'.tr(),
                    desc: 'theCouponsHasBeenUsed'.tr() + "\n" +
                        scan.description,
                    image: Image.asset("assets/images/success.png"),
                  ).show();
                }else{
                  Alert(
                    context: context,
                    title: "Oops!",
                    desc: "Error:" + "\n" + scan.description,
                    image: Image.asset("assets/images/fail.png"),
                  ).show();
                }
              } else {
                Alert(
                  context: context,
                  title: "Oops!",
                  desc: 'error'.tr(),
                  image: Image.asset("assets/images/fail.png"),
                ).show();
              }
            }

            // Add your onPressed code here!
          },
          child: const Icon(Icons.qr_code_scanner, size: 34),
          backgroundColor: Colors.orange,
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
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
          title: _pageOptions.elementAt(_selectedIndex).title,
          // backgroundColor: Colors.white,
          elevation: 0.0,
          actions: <Widget>[
            PopupMenuButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await _auth.signOut();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.logout,
                                color: Colors.black,
                              ),
                              Text(
                                " Logout",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                        ),
                        value: 1,
                      ),
                      PopupMenuItem(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HelpForm()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.help,
                                color: Colors.black,
                              ),
                              Text(
                                " Help",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                        ),
                        value: 2,
                      ),
                      PopupMenuItem(
                        child: TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            buildLanguageDialog(context);
                            setState(() {});
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.emoji_flags_rounded,
                                color: Colors.black,
                              ),
                              Text(
                                " Language",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                        ),
                        value: 3,
                      ),
                      PopupMenuItem(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Introduction()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.black,
                              ),
                              Text(
                                " Info",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                        ),
                        value: 4,
                      ),
                    ])
          ],
          bottom: _pageOptions.elementAt(_selectedIndex).bottom,
        ),
        body: _pageOptions.elementAt(_selectedIndex).content,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
          ]),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                  rippleColor: Colors.grey[300],
                  hoverColor: Colors.grey[100],
                  gap: 8,
                  activeColor: Colors.black,
                  iconSize: 24,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  duration: Duration(milliseconds: 400),
                  tabBackgroundColor: Colors.grey[100],
                  tabs: [
                    GButton(
                      // vibration, tap_and_play, speaker_phone, contactless, compass_calibration
                      icon: Icons.tap_and_play,
                      text: 'Tap',
                    ),
                    GButton(
                      // card_giftcard, redeem, local_offer, local_play
                      icon: Icons.local_play,
                      text: 'Coupon',
                    ),
                    GButton(
                      // card_giftcard, redeem, local_offer, local_play
                      icon: Icons.control_point_duplicate_rounded,
                      text: 'Sticker',
                    ),
                    GButton(
                      icon: Icons.person,
                      text: 'Profile',
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
