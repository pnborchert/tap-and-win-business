import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tw_business_app/shared/constants.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitRotatingPlain(
          color: Colors.blue[300],
          size: 50,
        ),
      ),
    );
  }
}
