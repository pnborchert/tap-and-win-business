

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class NfcRequest {
  final String id;
  final int counter;
  final Timestamp timestamp;
  final String status;
  final int statusCode;
  final String track;
  final String service;

  NfcRequest({this.id, this.counter, this.timestamp, this.status, this.statusCode, this.track, this.service});

  Widget stepper(){
    //print(statusCode);
    return Stepper(
      currentStep: statusCode < 10 ? 0 : 1, // <-- active subscript
      steps: <Step>[
        new Step(
          title: new Text('Shipping'),
          content: new Text('We are working on the delivery'),
          state: StepState.complete,
          isActive: true,
        ),
        new Step(
          title: new Text ('Shipped'),
          content: new Text('The Stickers have been shipped'),
          state: statusCode < 10 ?  StepState.indexed : StepState.complete,
          isActive: true,
        ),
        new Step(
          title: new Text ('Delivered'),
          content: new Text('Delivered'),
          isActive: true,
        ),
      ],
    );
  }

}

