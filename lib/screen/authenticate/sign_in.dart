import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tw_business_app/screen/authenticate/forgot_password.dart';
import 'package:tw_business_app/services/auth.dart';
import 'package:tw_business_app/shared/constants.dart';
import 'package:tw_business_app/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Column(children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: "Email"),
                          //validator: (val),
                          inputFormatters:
                           [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                        //inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))], //--> does not work: it does not remove the eventual spaces
                        validator: (val) => val.isEmpty ? "Enter email" : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: "Password"),
                        validator: (val) => val.length < 6
                            ? "Password too short, enter 6 characters"
                            : null,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                final emailSendReset = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPassword()));
                                if (emailSendReset != null) {
                                  _auth.resetPassword(emailSendReset);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                          'Reset password link sent, check your email!'),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white, elevation: 0.0),
                              child: Text(
                                "Forgot password?",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                dynamic result = await _auth
                                    .signInEmailPassword(email, password);
                                if (result == null) {
                                  setState(() {
                                    loading = false;
                                    error = "Wrong email or password";
                                  } // else stream will find update and show homepage
                                      );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue[600]),
                            child: Text(
                              "Sign in",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      )
                    ],
                  ),
                )),
          ]);
  }
}
