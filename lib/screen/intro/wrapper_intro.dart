import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tw_business_app/screen/home/home.dart';
import 'package:tw_business_app/screen/intro/page_intro.dart';

class WrapperIntro extends StatefulWidget {
  const WrapperIntro({Key key}) : super(key: key);

  @override
  _WrapperIntroState createState() => _WrapperIntroState();
}

class _WrapperIntroState extends State<WrapperIntro> {
  bool showIntro = false;
  SharedPreferences prefs;

  void switchShowIntro() {
    setState(() {
      showIntro = false;
      prefs.setBool("showIntro", false);
    });
  }

  void initPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      showIntro = (prefs.getBool('showIntro') ?? true);
      // showIntro = true;
    });
  }

  @override
  void initState() {
    super.initState();
    initPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return showIntro ? Introduction(switchShowIntro: switchShowIntro) : Home();
  }
}
