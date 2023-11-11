import 'package:flutter/material.dart';
import 'package:tw_business_app/models/nfc.dart';
import 'package:tw_business_app/models/scan.dart';
import 'package:tw_business_app/screen/home/nfc/nfc_details.dart';

class ScanCard extends StatefulWidget {
  final Scan scan;

  ScanCard({this.scan});

  @override
  _ScanCardState createState() => _ScanCardState();
}

class _ScanCardState extends State<ScanCard> {

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(widget.scan.id)
    );
  }
}


