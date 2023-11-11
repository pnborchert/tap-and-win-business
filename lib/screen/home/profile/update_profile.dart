import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tw_business_app/models/user.dart';
import 'package:tw_business_app/screen/home/profile/login_prompt.dart';
import 'package:tw_business_app/services/auth_api.dart';
import 'package:tw_business_app/shared/api.dart';
import 'package:tw_business_app/shared/constants.dart';
import 'package:tw_business_app/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
class UpdateProfile extends StatefulWidget {
  final AppUser user;

  UpdateProfile({this.user});

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}


class _UpdateProfileState extends State<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();

  // text field state
  String email = "";
  String phone = "";
  String error = "";
  List<String> _genderList = [];

  Future<bool> _updateUserData(uid) async {
    return await updateInfo(uid, email, phone);

    /*
    await customerCollection.doc(uid).update({
      "username": username,
      "gender":
          genderLookup[genderLookup.indexWhere((l) => l["name"] == gender)]
              ["index"],
    });

     */
  }

  @override
  void initState() {
    super.initState();

    /*
    gender = widget.user.gender;
    username = widget.user.name;
    email = widget.user.email;
    genderLookup.forEach((el) {
      _genderList.add(el["name"]);
    });

     */
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
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
          title: Text('updateProfile'.tr()),
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
                onPressed: () {
                  Alert(
                    context: context,
                    title: 'seriously'.tr(),
                    desc: 'sureDeleteAccount'.tr(),
                    buttons: [
                      DialogButton(
                          child: Text(
                            'delete'.tr(),
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () async {
                            bool hasBeenDeleted =
                            await storeDeleteAPI(widget.user.uid);
                            print(hasBeenDeleted);
                            if (hasBeenDeleted) {
                              final AuthService _auth = AuthService();
                              _auth.signOut();
                              Navigator.pop(context);
                              Navigator.pop(context);
                            } else {
                              Navigator.pop(context);
                              Alert(
                                  context: context,
                                  title: "Oops!",
                                  desc:
                                  'error'.tr())
                                  .show();
                            }
                          },
                          color: Colors.red),
                      DialogButton(
                          child: Text(
                            'back'.tr(),
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          color: Colors.blue)
                    ],
                  ).show();
                },
                icon: Icon(
                  Icons.delete_rounded,
                  color: Colors.red,
                ),
                label: Text(
                  'deleteAccount'.tr(),
                  style: TextStyle(color: Colors.red),
                ))
          ],
        ),
        body: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.email),
                  title: TextFormField(
                    initialValue: widget.user.email,
                    decoration: textInputDecoration.copyWith(hintText: "Email"),
                    validator: (val) => val.isEmpty ? 'enterEmail'.tr() : null,
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                ),
                /*ListTile(
                  leading: Icon(Icons.store),
                  title: TextFormField(
                    initialValue: widget.user.nameStore,
                    decoration:
                        textInputDecoration.copyWith(hintText: "Name Store"),
                    validator: (val) => val.isEmpty ? "Enter Name Store" : null,
                    onChanged: (val) {
                      setState(() => nameStore = val);
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.emoji_people),
                  title: DropdownButtonFormField<String>(
                    decoration: textInputDecoration,
                    value: phone,
                    isExpanded: true,
                    items: _genderList.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() => gender = val);
                    },
                  ),
                ),*/
                ListTile(
                  leading: Icon(Icons.phone),
                  title: TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: widget.user.internationalPhone,
                    decoration:
                    textInputDecoration.copyWith(hintText: 'phone'.tr()),
                    validator: (val) =>
                    val.isEmpty ? 'enterYourNumber'.tr() : null,
                    onChanged: (val) {
                      setState(() => phone = val);
                    },
                  ),
                ),

                Center(
                  child: ButtonTheme(
                    minWidth: 150,
                    child: ElevatedButton(
                        child: Text('Submit'),
                        onPressed: () async {
                          final response = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPrompt(
                                    user: widget.user,
                                    newEmail: (email != widget.user.email &&
                                        email != "")
                                        ? email
                                        : null,
                                  )));
                          if (response == 1) {
                            bool res = await _updateUserData(widget.user.uid);
                            print(res);
                          }
                          Navigator.pop(context);
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
