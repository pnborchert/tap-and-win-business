import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Coupon {
  final String id;
  final String title;
  final DocumentReference store_id;
  final Timestamp creation_date;
  final Timestamp expiry_date;
  final bool is_active;
  final bool is_valid;
  final double old_price;
  final double new_price;
  final String image;
  final String description;
  Coupon(
      {this.id,
      this.title,
      this.store_id,
      this.creation_date,
      this.expiry_date,
      this.is_active,
      this.is_valid,
      this.old_price,
      this.new_price,
      this.image,
      this.description});

  bool isNull() {
    return [title, old_price, new_price, image].contains(null);
  }

  factory Coupon.fromJSON(Map<String, dynamic> json) {
    return new Coupon(
      id: json["id"],
      store_id: json["store_id"],
      title: json["title"],
      creation_date: Timestamp.fromDate(DateTime.parse(json["creation_date"])),
      expiry_date: Timestamp.fromDate(DateTime.parse(json["expiry_date"])),
      is_active: json["is_active"],
      is_valid: json["is_valid"],
      old_price: json["old_price"].toDouble(),
      new_price: json["new_price"].toDouble(),
      image: json["image_file"],
      description: json["description"],
    );
  }
}
