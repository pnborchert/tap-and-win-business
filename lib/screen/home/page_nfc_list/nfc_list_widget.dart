import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tw_business_app/models/nfc.dart';
import 'package:tw_business_app/models/user.dart';
import 'package:tw_business_app/screen/home/page_nfc_list/error_nonfc.dart';
import 'package:tw_business_app/screen/home/page_nfc_list/nfc_card.dart';
import 'package:tw_business_app/screen/home/page_nfc_list/request_nfc_sticker.dart';
import 'package:tw_business_app/services/auth.dart';

import 'package:tw_business_app/shared/api.dart';
import 'package:tw_business_app/shared/loading.dart';

import 'package:easy_localization/easy_localization.dart';

class NfcList extends StatefulWidget {
  const NfcList({Key key}) : super(key: key);

  @override
  _NfcListState createState() => _NfcListState();
}

class _NfcListState extends State<NfcList> {
  List<Nfc> _nlist;

  @override
  void initState() {
    super.initState();
    _getStickerList();
  }

  void _getStickerList() async {
    _nlist = await getNfcList();
    setState(() {});
  }

  Widget showList() {
    if ((_nlist != null)) {
      if (_nlist.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              physics: ScrollPhysics(),
              itemCount: _nlist.length,
              itemBuilder: (context, index) {
                return NfcCard(
                  nfc: _nlist[index],
                );
              },
            ),
          ),
        );
      } else {
        // return Loading();
        return NoNfc();
      }
    } else {
      return Loading();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authUser = Provider.of<User>(context);
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(25),
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  )),
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  //Background Color
                  elevation: MaterialStateProperty.all(3),
                  //Defines Elevation
                  shadowColor: MaterialStateProperty.all(
                      Colors.blue), //Defines shadowColor
                ),
                onPressed: () async {
                  if (! await AuthService().emailVerified()) {
                    Alert(
                      context: context,
                      type: AlertType.warning,
                      title: "Confirm Email",
                      desc:
                          "Please check your email box and validate your email for request Tap&Win Stickers. \n It's Free! ",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "Resend",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () async {
                            await AuthService().sendEmailVerification();
                            Navigator.pop(context);
                          },
                          color: Color.fromRGBO(0, 179, 134, 1.0),
                        ),
                        DialogButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          gradient: LinearGradient(colors: [
                            Color.fromRGBO(116, 116, 191, 1.0),
                            Color.fromRGBO(52, 138, 199, 1.0)
                          ]),
                        )
                      ],
                    ).show();
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RequestNfc()));
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'moreStickers'.tr(),
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ), /*TextButton.icon(
                icon: Icon(Icons.add, color: Colors.white),
                label: Text(
                  "More free T&W Stickers",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(4),
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.blue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17),
                          side: BorderSide(color: Colors.blue))),
                  shadowColor: MaterialStateProperty.all<Color>(Colors.grey),
                ),
                onPressed: () {

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RequestNfc()));


                },
              ),*/
            ),
            showList(),
          ],
        ),
      ),
    );
  }
}
