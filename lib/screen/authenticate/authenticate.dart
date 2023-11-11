import 'package:flutter/material.dart';
import 'package:tw_business_app/screen/authenticate/background.dart';
import 'package:tw_business_app/screen/authenticate/register.dart';
import 'package:tw_business_app/screen/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(children: <Widget>[
            Background(toggleView: toggleView),
            showSignIn ? Register() : SignIn()
          ])),
    );
  }
}
