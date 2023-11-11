import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tw_business_app/models/nfc_request.dart';
import 'package:tw_business_app/shared/api.dart';
import 'package:tw_business_app/shared/loading.dart';
import 'package:easy_localization/easy_localization.dart';

class RequestNfc extends StatefulWidget {
  const RequestNfc({Key key}) : super(key: key);

  @override
  _RequestNfcState createState() => _RequestNfcState();
}

class _RequestNfcState extends State<RequestNfc> {
  int counter = 1;
  int minValue = 1;
  int maxValue = 6;

  NfcRequest _nfcRequest;

  @override
  void initState() {
    _getNfcRequest();
    super.initState();
  }

  void _getNfcRequest() async {
    _nfcRequest = await getNfcRequest();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _nfcRequest == null
        ? Loading()
        : (_nfcRequest.id != null
            ? Scaffold(
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
                  title: Text('newStickers'.tr()),
                  elevation: 0.0,
                ),
                body: SafeArea(
                  child: Container(
                    margin: EdgeInsets.only(right: 20, left: 20, top: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'lastStickerRequest'.tr(),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'numberOfStickers'.tr() +
                              _nfcRequest.counter.toString(),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'status'.tr() + _nfcRequest.status,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'id request: ' + _nfcRequest.id,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Service : ' +
                              (_nfcRequest.service != null
                                  ? _nfcRequest.service
                                  : "null"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Track Code : ' +
                              (_nfcRequest.track != null
                                  ? _nfcRequest.track
                                  : "null"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: _nfcRequest.stepper(),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Scaffold(
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
                  title: Text('newStickers'.tr()),
                  elevation: 0.0,
                ),
                body: SafeArea(
                  child: Container(
                    margin: EdgeInsets.only(right: 20, left: 20, top: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                        ),
                        Text('manyStickers'.tr(),
                            style: TextStyle(
                                fontSize: 30.0,
                                color: Theme.of(context).accentColor)),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.remove,
                                  color: Theme.of(context).accentColor,
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 18.0),
                                iconSize: 52.0,
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  setState(() {
                                    if (counter > minValue) {
                                      counter--;
                                    }
                                  });
                                },
                              ),
                              Text(
                                '$counter',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 32.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.add,
                                  color: Theme.of(context).accentColor,
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 18.0),
                                iconSize: 52.0,
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  setState(() {
                                    if (counter < maxValue) {
                                      counter++;
                                    }
                                  });
                                },
                              ),
                            ]),
                        SizedBox(
                          height: 40,
                        ),
                        Center(
                            child: ElevatedButton.icon(
                          icon: Icon(
                            Icons.add_circle_rounded,
                            color: Colors.white,
                            size: 24.0,
                          ),
                          label: Text(
                            'Submit',
                          ),
                          // style: TextStyle(fontSize: 26.0, color: Colors.white) ,),
                          onPressed: () async {
                            String res = await postNfcRequest(counter);
                            if (res != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      'Request successfully submitted!'),
                                ),
                              );
                              Navigator.pop(context);
                            } else {
                              Alert(
                                      context: context,
                                      title: "Oops!",
                                      desc:
                                          "Some error occurs. Is the internet connection active?")
                                  .show();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
              ));
  }
}
