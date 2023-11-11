import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
double maxTaps = 200000.0;

class Nfc {
  String id; //id
  int counter;
  bool isValid;
  int number;
  Timestamp timestamp;
  int groupId;
  int nTaps;
  double percentage;
  bool isActive;
  String message;

  Nfc({this.id,  this.counter, this.isValid, this.number,
      this.timestamp, this.groupId, this.nTaps, this.percentage,this.isActive, this.message});

  factory Nfc.fromJSON(Map<String, dynamic> json) {


    return new Nfc(
      id: json["id"].toString(),
      counter: json["counter"],
      isValid: json["is_valid"],
      number: json["number"],
      timestamp: Timestamp.fromDate(DateTime.parse(json["timestamp"])),
      groupId: json["group_id"],
      nTaps: json["n_taps"],
      percentage: 1.0 - min(double.parse(json["counter"].toString()), maxTaps)/maxTaps,
      isActive: json["is_active"]
    );
  }

}
