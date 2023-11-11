import 'package:flutter/material.dart';
import 'package:firebase_image/firebase_image.dart';

class StoreCard extends StatefulWidget {
  final double distance;
  StoreCard({this.distance});
  @override
  _StoreCardState createState() => _StoreCardState();
}

class _StoreCardState extends State<StoreCard> {
  @override
  Widget build(BuildContext context) {
    return Text("");
    /*
      Card(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: FirebaseImage(
                    'ANONYMOUS' + widget.store.image),
              ),
              title: Text(
                widget.store.displayTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              subtitle: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        widget.store.category,
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                  Row(children: [
                    Padding(padding: EdgeInsets.only(top: 15)),
                    Text(
                      "Distance: " + widget.distance.toStringAsFixed(0) + "m",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.blue[600],
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );*/
  }
}
