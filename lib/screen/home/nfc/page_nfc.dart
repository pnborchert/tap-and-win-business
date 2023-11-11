import 'package:flutter/material.dart';
import 'package:tw_business_app/screen/home/nfc/nfc_wrapper.dart';
import 'package:tw_business_app/screen/home/twpage.dart';

final TWPage pageNfc = new TWPage(
  title: Text("Activate NFC reader", style: TextStyle(color: Colors.black)),
  content: NfcWrapper(),
  bottom: null,
  tabs: 0,
);
