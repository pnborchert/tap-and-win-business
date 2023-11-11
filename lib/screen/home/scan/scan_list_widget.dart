// stores ExpansionPanel state information
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tw_business_app/models/scan.dart';
import 'package:tw_business_app/shared/api.dart';
import 'package:tw_business_app/shared/loading.dart';

import 'error_noscan.dart';

class Item {
  Item({
    this.scan,
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  Scan scan;
  String expandedValue;
  String headerValue;
  bool isExpanded;
}

class ScanList extends StatefulWidget {
  const ScanList({Key key}) : super(key: key);

  @override
  _ScanListState createState() => _ScanListState();
}

class _ScanListState extends State<ScanList> {
  //List<Scan> _slist;
  List<Item> _data;

  @override
  void initState() {
    super.initState();
    _getStickerList();
  }

  void _getStickerList() async {
    List<Scan> _slist = await getScanList();
    _data = _slist
        .map((e) => Item(
              scan: e,
              headerValue: e.code == 200 ? "Success" : "Failed",
              expandedValue: e.description,
            ))
        .toList();
    _data.sort((a,b) => b.scan.timestamp.compareTo(a.scan.timestamp));
    setState(() {});
  }

  Widget showList() {
    if ((_data != null)) {
      if (_data.isNotEmpty) {
        return SingleChildScrollView(
            child: Container(
          child: _buildPanel(),
        ));
      } else {
        // return Loading();
        return noScan();
      }
    } else {
      return Loading();
    }
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
                title: RichText(
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: DateFormat('dd/MM/yyyy, HH:mm')
                        .format(DateTime.fromMillisecondsSinceEpoch(
                            item.scan.timestamp.millisecondsSinceEpoch))
                        .toString(),
                    style: TextStyle(color: Colors.black)),
                TextSpan(
                  text: "      " + item.headerValue,
                  style: TextStyle(
                      color: item.scan.code == 200 ? Colors.green : Colors.red),
                )
              ]),
            ));
          },
          body: ListTile(
              title: Text(item.expandedValue),
              /*
              subtitle:
                  const Text('To delete this panel, tap the trash can icon'),
              trailing: const Icon(Icons.delete),
              onTap: () {
                setState(() {
                  _data.removeWhere((Item currentItem) => item == currentItem);
                });
              }*/
              ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          title: Text("Scan"),
          elevation: 0.0,
        ),
        backgroundColor: Colors.white,
        body: showList());
  }
}
