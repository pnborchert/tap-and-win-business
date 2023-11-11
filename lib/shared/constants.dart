import 'package:flutter/material.dart';

const colGrey = Color(0xFFF5F5F5);
const colBlue = Color(0xFF1E88E5);

const storage_path = "ANONYMIZED";
const default_image = "ANONYMIZED";
const loading_gif = "ANONYMIZED";

const textInputDecoration = InputDecoration(
    fillColor: colGrey,
    filled: true,
    enabledBorder:
        OutlineInputBorder(borderSide: BorderSide(color: colGrey, width: 2.0)),
    focusedBorder:
        OutlineInputBorder(borderSide: BorderSide(color: colBlue, width: 2.0)));



const List<Color> orangeGradients = [
  Color(0xFFFF9844),
  Color(0xFFFE8853),
  Color(0xFFFD7267),
];

const List<Color> blueGradients = [
  Color(0xFF20cbfd),
  Color(0xFF009fff),
  Color(0xFF0460fd),
];


Future<void> showAlert(context, String title, String message) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, 
    builder: (BuildContext context) {
      return AlertDialog(
        title:  Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}