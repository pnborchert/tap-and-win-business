import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tw_business_app/screen/authenticate/privacy_policy.dart';
import 'package:tw_business_app/screen/authenticate/search_store.dart';
import 'package:tw_business_app/screen/authenticate/terms_conditions.dart';
import 'package:tw_business_app/services/auth.dart';
import 'package:tw_business_app/shared/constants.dart';
import 'package:tw_business_app/shared/loading.dart';
import 'package:google_place/google_place.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool agree = false;
  bool storeNotSearched = false;

  // text field state
  String email = "";
  String password = "";
  //String repeatPassword = "";
  String error = "";

  TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 10.0);
  TextStyle linkStyle = TextStyle(color: Colors.blue);

  DetailsResult detailsResult;
  ImageProvider image = NetworkImage(
      "ANONYMIZED");

  bool checkResult(DetailsResult result) {
    //print(result.placeId);
    return result != null &&
        result.formattedAddress != null &&
        result.geometry != null &&
        result.geometry.location != null &&
        result.name != null;
  }

  bool valideForm() {
    if(detailsResult== null){
      setState(() {
        storeNotSearched = true;
      });
    }else{
      setState(() {
        storeNotSearched = false;
      });
    }
    return agree && detailsResult != null && _formKey.currentState.validate();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Column(children: <Widget>[
            SizedBox(
              height: 20,
            ),
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
                      TextFormField(
                        inputFormatters:
                        [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                        decoration:

                            textInputDecoration.copyWith(hintText: "Email"),
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
                      /*
                      TextFormField(
                        decoration:
                        textInputDecoration.copyWith(hintText: "Repeat Password"),
                        validator: (val) =>
                        val != password
                            ? "Password does not match with the previous"
                            : null,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() => repeatPassword = val);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),

                       */
                      GestureDetector(
                        onTap: () async {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          SearchStoreStateReturn result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchStore()));
                          final image_result = Uint8List.fromList(result.image);
                          ImageProvider provider =
                              MemoryImage(Uint8List.fromList(image_result));
                          if (checkResult(result.detailsResult)) {
                            setState(() {
                              detailsResult = result.detailsResult;
                              image = provider;
                            });
                          } else {
                            Alert(
                                    context: context,
                                    title: "Oops!",
                                    desc:
                                        "Some error occurs. Is the internet connection active?")
                                .show();
                          }
                        },
                        child: detailsResult != null
                            ? Card(
                                borderOnForeground: true,
                                elevation: 4.0,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: image,
                                        radius: 30,
                                      ),
                                      title: Text(detailsResult.name.length > 25
                                          ? detailsResult.name
                                                  .substring(0, 25) +
                                              '..'
                                          : detailsResult.name),
                                      subtitle: Text(detailsResult
                                                  .formattedAddress.length >
                                              25
                                          ? detailsResult.formattedAddress
                                                  .substring(0, 25) +
                                              '..'
                                          : detailsResult.formattedAddress),
                                    ),
                                  ],
                                ),
                              )
                            : TextButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18.0),
                                          side: storeNotSearched ? BorderSide(color: Colors.red, width: 2.0) : BorderSide(color: Colors.blue)
                                      )
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.blue),
                                  //Background Color
                                  elevation: MaterialStateProperty.all(3),
                                  //Defines Elevation
                                  shadowColor: MaterialStateProperty.all(
                                      Colors.blue), //Defines shadowColor
                                ),
                                onPressed: () async {
                                  SearchStoreStateReturn result =
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SearchStore()));
                                  final image_result =
                                      Uint8List.fromList(result.image);
                                  ImageProvider provider = MemoryImage(
                                      Uint8List.fromList(image_result));
                                  if (checkResult(result.detailsResult)) {
                                    setState(() {
                                      detailsResult = result.detailsResult;
                                      image = provider;
                                    });
                                  } else {
                                    Alert(
                                            context: context,
                                            title: "Oops!",
                                            desc:
                                                "Some error occurs. Is the internet connection active?")
                                        .show();
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.manage_search_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'SEARCH YOUR STORE',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                      ),
                      Row(children: [
                        Checkbox(
                          value: agree,
                          onChanged: (value) {
                            setState(() {
                              agree = value;
                            });
                          },
                        ),
                        RichText(
                          text: TextSpan(
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(text: 'I agree with '),
                              TextSpan(
                                  text: 'Terms and Conditions',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.blue),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = ()
                                    async {
                                      const url = "ANONYMIZED";
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    }
                                /*{
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TermsConditions()),
                                      );
                                    }*/
                              ),
                            ],
                          ),
                        ),
                      ]),
                      SizedBox(
                        height: 2,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (valideForm()) {
                            setState(() {
                              loading = true;
                            });
                            dynamic result = await _auth.registerEmailPassword(
                                email, password, detailsResult.placeId);
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error = "Invalid email";
                              }
                                  // else stream will find update and show homepage
                                  );
                            }
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                agree && detailsResult != null
                                    ? Colors.blue[600]
                                    : Colors.grey)),
                        child: Text(
                          "Sign up",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 2.0,
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
