import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tw_business_app/services/database.dart';

class AppUser {
  final String uid;
  final String address;
  final bool confirmed;
  final String email;
  final String imageFile;
  final String internationalPhone;
  final GeoPoint location;
  final String nameStore;
  final List<String> types;

  AppUser(
      {this.uid,
      this.address,
      this.confirmed,
      this.email,
      this.imageFile,
      this.location,
      this.internationalPhone,
      this.nameStore,
      this.types});

  Future updateFCMToken() async {
    await DataBaseService(uid: uid).updateFCMToken();
  }
}

