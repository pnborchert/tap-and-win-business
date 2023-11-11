import 'package:flutter/material.dart';

const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.black);

// setup class
class TWPage {
  Widget title;
  Widget content;
  Widget bottom;
  int tabs;
  TWPage({this.title, this.content, this.bottom, this.tabs});
}
