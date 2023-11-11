import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tw_business_app/models/user.dart';
import 'package:tw_business_app/services/auth.dart';
import 'package:tw_business_app/shared/constants.dart';
import 'package:easy_localization/easy_localization.dart';
class LoginPrompt extends StatefulWidget {
  final AppUser user;
  final String newEmail;

  LoginPrompt({this.user, this.newEmail});

  @override
  _LoginPromptState createState() => _LoginPromptState();
}

class _LoginPromptState extends State<LoginPrompt> {
  final _formKey = GlobalKey<FormState>();
  String error = "";
  String password = "";

  @override
  void initState() {
    super.initState();
  }

  Future<int> _updateEmail(uid, String newEmail) async {
    int response;
    response = await AuthService().updateEmailCred(newEmail);

    // auth failed -> do not update email
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text('confirmEmailUpdate'.tr()),
        elevation: 0.0,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.vpn_key),
                title: TextFormField(
                  initialValue: null,
                  obscureText: true,
                  decoration:
                  textInputDecoration.copyWith(hintText: "Password"),
                  validator: (val) => val.isEmpty ? "Enter Password" : null,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
              ),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
              Center(
                  child: ButtonTheme(
                    minWidth: 150,
                    child: ElevatedButton(
                      child: Text('Submit'),
                      onPressed: () async {
                        int response;
                        if (_formKey.currentState.validate()) {
                          response = await AuthService()
                              .reauthenticateUser(widget.user.email, password);
                          if (response == 0) {
                            setState(() {
                              error = 'invalidEmail'.tr();
                            });
                          } else if (response == 1) {
                            if (widget.newEmail != null) {

                              response = await _updateEmail(
                                  widget.user.uid, widget.newEmail);
                              if (response == 1) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('accountSuccessfullyUpdate'.tr()),
                                    action: SnackBarAction(
                                      label: 'Confirm'.tr(),
                                      onPressed: () {},
                                    ),
                                  ),
                                );
                                Navigator.pop(context, response);
                              } else {
                                setState(() {
                                  error = 'invalidEmail'.tr();
                                });
                              }
                            } else {
                              response = 1;
                              Navigator.pop(context, response);
                            }
                          }
                        }
                      },
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
