import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tw_business_app/models/nfc.dart';

import 'package:easy_localization/easy_localization.dart';
class NfcDetails extends StatelessWidget {
  final Nfc nfc;

  const NfcDetails({Key key, this.nfc}) : super(key: key);

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
        title: Text('stickerDetails'.tr()),
      ),
      body: ListView(children: <Widget>[
        Center(
          child: CircleAvatar(

            backgroundColor: Colors.grey[100],
            radius: 100,
            child: Image(
              image: Image.asset('assets/images/sticker.png').image,

              fit: BoxFit.cover,
              // width: 150,
              // height: 150,
            ),
          ),
        ),
        Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 10),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  nfc.isValid ? 'active'.tr() : 'deactivated'.tr(),
                  style:
                  TextStyle(color: nfc.isValid ? Colors.green : Colors.red),
                ),
              ]),
        ),

        ListTile(
          leading: Icon(Icons.format_list_numbered_rounded),
          title: Text("Sticker n° "),
          subtitle: Text(nfc.number.toString()),
        ),

        ListTile(
          leading: Icon(Icons.people_alt_rounded ),
          title: Text('customerTaps'.tr()),
          subtitle: Text(nfc.nTaps.toString()),
        ),

        ListTile(
          leading: Icon(Icons.local_hospital_rounded),
          title: Text('stickerLife'.tr()),
          subtitle: LinearProgressIndicator(
            value: nfc.percentage,
            color: nfc.percentage > 0.5 ? Colors.green : ( nfc.percentage > 0.2 ? Colors.orange : Colors.red),
            backgroundColor: nfc.percentage > 0.5 ? Colors.green[200] : ( nfc.percentage > 0.2 ? Colors.orange[200] : Colors.red[200]),
            minHeight: 5,
          ),
        ),
        nfc.message == null ? SizedBox.shrink() : Text(nfc.message),
      ]),
    );
  }
}
