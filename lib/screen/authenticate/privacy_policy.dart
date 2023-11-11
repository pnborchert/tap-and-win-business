
import 'package:flutter/material.dart';


import 'package:flutter/services.dart' show rootBundle;


class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key key}) : super(key: key);

  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  String data = '';

  fetchFileData() async {
    String responseText;
    responseText = await rootBundle.loadString('assets/res/privacy_policy.txt');
    setState(() {
      data = responseText;
    });
  }

  @override
  void initState() {
    fetchFileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          // adding margin

          margin: const EdgeInsets.all(15.0),
          // adding padding

          padding: const EdgeInsets.all(3.0),

          // SingleChildScrollView should be
          // wrapped in an Expanded Widget
          child: Expanded(
            //contains a single child which is scrollable
            child: SingleChildScrollView(

              //for horizontal scrolling
                scrollDirection: Axis.vertical,
                child: Text(
                  data,
                  style: TextStyle(fontSize: 18),
                )),
          ),
        ),
      ),
    );
  }
}
