import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tw_business_app/models/user.dart';
import 'package:tw_business_app/screen/home/profile/dashboard.dart';
import 'package:tw_business_app/screen/home/profile/update_profile.dart';
import 'package:tw_business_app/services/auth.dart';
import 'package:tw_business_app/services/auth_api.dart';
import 'package:tw_business_app/shared/api.dart';
import 'package:tw_business_app/shared/constants.dart';
import 'package:tw_business_app/shared/loading.dart';

///// for image picker
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

class AppUserWithImage {
  AppUser user;
  String imageLink;

  AppUserWithImage(this.user, this.imageLink);
}

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

List<String> _languageList = ["Italiano", "English"];

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    AppUser _authUser = Provider.of<AppUser>(context);
    //final CollectionReference customerCollection =
    //   FirebaseFirestore.instance.collection("Customer");

    XFile _imageFile;
    final _picker = ImagePicker();

    Future<AppUserWithImage> _getUserData(uid) async {
      AppUser user = await storeInfoAPI(uid);
      String imageLink = await getImageAPI(uid);
      return AppUserWithImage(user, imageLink);
    }

    Future<void> uploadFile(String uid, String token) async {
      Uri url = Uri.parse("ANONYMIZED");
      try {
        var request = new MultipartRequest("POST", url);
        request.fields['store_id'] = uid;
        request.fields['token'] = token;
        MultipartFile file = new MultipartFile.fromBytes(
            'image', await _imageFile.readAsBytes(),
            filename: _imageFile.name); // MediaType class is not defined
        request.files.add(file);
        final response = await request.send();

        if (response.statusCode == 200) {
          final respStr = await response.stream.bytesToString();

          setState(() {});
        } else {
          final respStr = await response.stream.bytesToString();
          //print(respStr);
          Alert(
              context: context,
              title: "Oops!",
              desc: 'error'.tr())
              .show();
        }
      } catch (e) {
        print(e);
        Alert(
            context: context,
            title: "Oops!",
            desc: 'error'.tr())
            .show();
      }
    }

    Future<void> getImage(String uid, String token) async {
      await _picker
          .pickImage(
        source: ImageSource.gallery,
        imageQuality: 25,
      )
          .then((value) => {
        setState(() {
          _imageFile = value;
        })
      });
      if (_imageFile != null) {
        await uploadFile(uid, token);
      }
    }

    return FutureBuilder<AppUserWithImage>(
        future: _getUserData(_authUser.uid),
        builder: (context, appUserWithImage) {
          return appUserWithImage.hasData
              ? SingleChildScrollView(
            child: Column(children: <Widget>[
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    width: double.infinity,
                    height: 100,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.topRight,
                            colors: [
                              Color(0xFF43bffb),
                              Color(0xFF0078ff),
                            ]),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(top: 20),
                    child: CircleAvatar(
                      radius: 90,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(appUserWithImage
                          .data.imageLink !=
                          null
                          ? appUserWithImage.data.imageLink
                          : "ANONYMIZED"),
                      child: Stack(children: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white70,
                              child: IconButton(
                                  icon: Icon(Icons.camera_alt),
                                  onPressed: () async {
                                    await getImage(
                                        appUserWithImage.data.user.uid,
                                        await AuthService()
                                            .currentUser()
                                            .getIdToken());
                                  })),
                        ),
                      ]),
                    ),
                  )
                ],
              ),
              /*  Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          user.data.nameStore,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),*/
              Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orange[800],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashboardPage()));
                          },
                          icon: Icon(
                            Icons.trending_up,
                            color: Colors.white,
                          ),
                          label: Text(
                            appUserWithImage.data.user.nameStore.toString(),
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  )),
              ListTile(
                leading: Icon(Icons.email),
                title: Text("Email"),
                subtitle: Text(appUserWithImage.data.user.email),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('phone'.tr()),
                subtitle: Text(appUserWithImage
                    .data.user.internationalPhone
                    .toString()),
              ),
              ListTile(
                leading: Icon(Icons.place),
                title: Text('address'.tr()),
                subtitle: Text(appUserWithImage.data.user.address),
              ),
              ListTile(
                leading: Icon(Icons.category_rounded),
                title: Text('category'.tr()),
                subtitle: Text(appUserWithImage.data.user.types.join(", ")),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: ButtonTheme(
                  minWidth: 150,
                  child: ElevatedButton(
                    child: Text('updateProfile'.tr()),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateProfile(
                                user: appUserWithImage.data.user,
                              ))).then((value) {
                        setState(() {});
                      });
                    },
                  ),
                ),
              ),
            ]),
          )
              : Loading();
        });
  }
}
