import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tw_business_app/models/coupon.dart';
import 'package:tw_business_app/models/user.dart';
import 'package:tw_business_app/screen/home/coupon/customer_coupon_card.dart';
import 'package:tw_business_app/services/auth.dart';
import 'package:tw_business_app/shared/api.dart';
import 'package:tw_business_app/shared/constants.dart';
import 'package:tw_business_app/shared/loading.dart';
import 'package:easy_localization/easy_localization.dart';

class EditCoupon extends StatefulWidget {
  final Coupon coupon;
  final Function refreshCouponList;

  const EditCoupon({Key key, this.coupon, this.refreshCouponList})
      : super(key: key);

  @override
  _EditCouponState createState() => _EditCouponState();
}

class _EditCouponState extends State<EditCoupon> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;
  String item = "";
  double oldPrice = 0;
  double newPrice = 0;
  String error = "";
  String description = "";
  String urlImage;
  AppUser _authUser;
  DateTime currentDate = DateTime.now();
  DateTime expiryDate = DateTime(
      DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    super.initState();
    setCouponValues();
    setState(() {});
  }

  void setCouponValues() {
    item = widget.coupon.title;
    oldPrice = widget.coupon.old_price;
    newPrice = widget.coupon.new_price;
    expiryDate = widget.coupon.expiry_date.toDate();
    description = widget.coupon.description;
  }

  Future<void> _selectDate() async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate:
            DateTime(currentDate.year, currentDate.month + 1, currentDate.day),
        firstDate:
            DateTime(currentDate.year, currentDate.month + 1, currentDate.day),
        lastDate:
            DateTime(currentDate.year + 5, currentDate.month, currentDate.day));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        expiryDate = pickedDate;
      });
  }

  XFile _imageFile;
  String _uploadedFileURL;
  final _picker = ImagePicker();

  Future<void> uploadFile(String couponId, String uid, String token) async {
    try {
      if (_imageFile != null) {
        Uri url = Uri.parse("ANONYMIZED");
        var request = new MultipartRequest("POST", url);
        request.fields['coupon_id'] = couponId;
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
          Alert(context: context, title: "Oops!", desc: 'error'.tr()).show();
        }
      }
    } catch (e) {
      Alert(context: context, title: "Oops!", desc: 'error'.tr()).show();
    }
  }

  Future<void> getImage() async {
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
  }

  Coupon previewCoupon(String imageUrl) {
    return new Coupon(
      id: "Preview",
      creation_date: Timestamp.now(),
      title: item,
      store_id: null,
      expiry_date: Timestamp.fromDate(expiryDate),
      is_active: false,
      is_valid: false,
      old_price: oldPrice,
      new_price: newPrice,
      image: _imageFile != null ? _imageFile.path : imageUrl,
      description: description,
    );
  }

  @override
  Widget build(BuildContext context) {
    AppUser _authUser = Provider.of<AppUser>(context);
    return FutureBuilder<String>(
        future: getImageAPI(_authUser.uid),
        builder: (context, imageUrl) {
          return !imageUrl.hasData
              ? Loading()
              : GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Scaffold(
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
                      title: Text('editCoupon'.tr()),
                    ),
                    body: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.topCenter,
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.white,
                                    backgroundImage: _imageFile != null
                                        ? Image.file(File(_imageFile.path))
                                            .image
                                        : NetworkImage(imageUrl.data),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: IconButton(
                                          alignment: Alignment.bottomRight,
                                          icon: Icon(
                                            Icons.camera_alt,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () async {
                                            await getImage();
                                          }),
                                    )),
                              ),
                              ListTile(
                                leading: Icon(Icons.shopping_basket),
                                title: TextFormField(
                                  initialValue: item,
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'DescribeDiscountedItem'.tr(),
                                      labelText: 'item'.tr()),
                                  validator: (val) => val.isEmpty
                                      ? 'DescribeDiscountedItem'.tr()
                                      : null,
                                  onChanged: (val) {
                                    setState(() => item = val);
                                  },
                                ),
                              ),
                              ListTile(
                                leading: Icon(Icons.euro_rounded),
                                title: TextFormField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+[\.\,]?\d{0,2}'))
                                  ],
                                  initialValue: oldPrice.toString(),
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'priceWithoutDiscount'.tr(),
                                      labelText: 'regulaPrice'.tr()),
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return 'PleaseProvideDiscountedPrice'
                                          .tr();
                                    } else if (double.tryParse(val) == null) {
                                      return 'PleaseProvideNumericValue'.tr();
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (val) {
                                    setState(() => oldPrice = double.tryParse(
                                        val.replaceAll(',', '.')));
                                  },
                                ),
                              ),
                              ListTile(
                                leading: Icon(Icons.euro_rounded),
                                title: TextFormField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+[\.\,]?\d{0,2}'))
                                  ],
                                  initialValue: newPrice.toString(),
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'discountedPrice'.tr(),
                                      labelText: 'discountedPrice'.tr()),
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return 'PleaseProvideDiscountedPrice'
                                          .tr();
                                    } else if (double.tryParse(val) == null) {
                                      return 'PleaseProvideNumericValue'.tr();
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (val) {
                                    setState(() => newPrice = double.tryParse(
                                        val.replaceAll(',', '.')));
                                  },
                                ),
                              ),
                              ListTile(
                                leading: Icon(Icons.date_range),
                                title: Text('expiryDate'.tr()),
                                subtitle: Text(DateFormat("yyyy-MM-dd")
                                    .format(expiryDate)),
                                onTap: () async {
                                  await _selectDate();
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.text_snippet_outlined),
                                title: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 3,
                                  initialValue: description,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(100)
                                  ],
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'DescriptionCoupon'.tr(),
                                      labelText: 'Description'.tr()),
                                  validator: (val) =>
                                      val.isEmpty ? 'Description'.tr() : null,
                                  onChanged: (val) {
                                    setState(() => description = val);
                                  },
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Preview",
                                  style: TextStyle(fontSize: 18),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              CouponCard(
                                  coupon: previewCoupon(imageUrl.data),
                                  localImage: _imageFile != null),
                              Padding(padding: EdgeInsets.only(top: 20)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      Alert(
                                        context: context,
                                        title: 'AreYouSure'.tr(),
                                        desc: 'sureDeleteAccount'.tr(),
                                        buttons: [
                                          DialogButton(
                                              child: Text(
                                                'delete'.tr(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                              onPressed: () async {
                                                bool hasBeenDeleted =
                                                    await deleteCouponAPI(
                                                        _authUser.uid,
                                                        widget.coupon.id);
                                                //print(hasBeenDeleted);
                                                if (hasBeenDeleted) {
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'couponDeleted'.tr()),
                                                    ),
                                                  );
                                                  Navigator.pop(context);
                                                  widget.refreshCouponList();
                                                  Navigator.pop(context);
                                                } else {
                                                  Navigator.pop(context);
                                                  Alert(
                                                          context: context,
                                                          title: "Oops!",
                                                          desc: 'error'.tr())
                                                      .show();
                                                }
                                                widget.refreshCouponList();
                                              },
                                              color: Colors.red),
                                          DialogButton(
                                              child: Text(
                                                'back'.tr(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              color: Colors.blue)
                                        ],
                                      ).show();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.red[600]),
                                    child: Text(
                                      'delete'.tr(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        // call API

                                        //print(DateTime.parse(Timestamp.toDate().toString()))
                                        //print(Timestamp.now().toDate());
                                        String id = await updateCouponApi(
                                            Coupon(
                                              id: widget.coupon.id,
                                              creation_date: Timestamp.now(),
                                              title: item,
                                              store_id: null,
                                              expiry_date: Timestamp.fromDate(
                                                  expiryDate),
                                              is_active: false,
                                              is_valid: false,
                                              old_price: oldPrice,
                                              new_price: newPrice,
                                              image: _imageFile != null
                                                  ? _imageFile.path
                                                  : "default.jpg",
                                            ),
                                            _authUser.uid);
                                        if (id != null) {
                                          uploadFile(
                                              id,
                                              _authUser.uid,
                                              await AuthService()
                                                  .currentUser()
                                                  .getIdToken());
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                                  Text('couponUpdated'.tr()),
                                            ),
                                          );
                                          Navigator.pop(context);
                                        } else {
                                          Alert(
                                                  context: context,
                                                  title: "Oops!",
                                                  desc: 'error'.tr())
                                              .show();
                                        }

                                        Navigator.pop(context);
                                      }
                                      widget.refreshCouponList();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.blue[600]),
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 12.0,
                              ),
                              Text(
                                error,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 14),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
        });
  }
}
