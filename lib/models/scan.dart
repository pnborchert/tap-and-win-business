
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Scan {
  String id;
  String tapId; //id
  int code;
  String description;
  Timestamp timestamp;


  Scan({this.id,  this.tapId, this.code, this.description,
    this.timestamp,});

  factory Scan.fromJSON(Map<String, dynamic> json) {


    return new Scan(
      id: json["id"].toString(),
      tapId: json["tap_id"],
      code: json["code"],
      description: json["description"],
      timestamp: Timestamp.fromDate(DateTime.parse(json["timestamp"])),
    );
  }

}
