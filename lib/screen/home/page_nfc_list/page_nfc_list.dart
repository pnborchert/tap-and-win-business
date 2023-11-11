import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tw_business_app/screen/home/page_nfc_list/nfc_list_widget.dart';
import 'package:tw_business_app/screen/home/twpage.dart';
import 'package:tw_business_app/services/auth.dart';
import 'package:tw_business_app/services/database.dart';

final TWPage pageNfcList = new TWPage(
  title: Text("Sticker", style: TextStyle(color: Colors.black)),
  content: StreamProvider<User>.value(
    initialData: null,
    value: AuthService().authUser,
    child: NfcList(),
  ),
  bottom: null,
  tabs: 0,
);
// final TWPage pageNfcList = new TWPage(
//   title: Text("Sticker", style: TextStyle(color: Colors.black)),
//   content: NfcList(),
//   bottom: null,
//   tabs: 0,
// );
