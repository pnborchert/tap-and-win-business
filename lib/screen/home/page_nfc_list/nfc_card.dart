import 'package:flutter/material.dart';
import 'package:tw_business_app/models/nfc.dart';
import 'package:tw_business_app/screen/home/nfc/nfc_details.dart';

class NfcCard extends StatefulWidget {
  final Nfc nfc;

  NfcCard({this.nfc});

  @override
  _NfcCardState createState() => _NfcCardState();
}

class _NfcCardState extends State<NfcCard> {
  Widget statusBubble(Color color, double opacity) {
    return new Container(
      alignment: Alignment.centerLeft,
      width: 10,
      height: 10,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: color.withOpacity(opacity)),
    );
  }

  List<Widget> displayStatus(bool is_active, bool is_valid, double perc) {
    double opacityRed = 0.1;
    double opacityOrange = 0.1;
    double opacityGreen = 0.1;

    if ((is_active == false) & (is_valid == false)) {
      opacityRed = 1;
    } else if (perc < 0.3) {
      opacityOrange = 1;
    } else if ((is_active == false) | (is_valid == false)) {
      opacityOrange = 1;
    } else {
      opacityGreen = 1;
    }

    return [
      statusBubble(Colors.red, opacityRed),
      SizedBox(width: 5),
      statusBubble(Colors.orange, opacityOrange),
      SizedBox(width: 5),
      statusBubble(Colors.green, opacityGreen),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NfcDetails(
                        nfc: widget.nfc,
                      )));
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(width: 2, color: Colors.white70),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(5, 2),
                ),
              ]),
          child: Stack(
            // mainAxisSize: MainAxisSize.min,
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              ListTile(
                tileColor: Colors.white,
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      Image.asset('assets/images/sticker.png').image,
                ),
                title: Text(
                  "Sticker n° " + widget.nfc.number.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(vertical: 35, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: displayStatus(widget.nfc.isActive,
                      widget.nfc.isValid, widget.nfc.percentage),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
