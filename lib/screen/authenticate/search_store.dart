import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:google_place/google_place.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchStoreStateReturn {
  final DetailsResult detailsResult;
  final Uint8List image;
  final String placeId;

  SearchStoreStateReturn(this.detailsResult, this.image, this.placeId);
}



class SearchStore extends StatefulWidget {
  const SearchStore({Key key}) : super(key: key);

  @override
  _SearchStoreState createState() => _SearchStoreState();
}

class _SearchStoreState extends State<SearchStore> {
  GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];

  SearchStoreStateReturn searchStoreStateReturn;

  @override
  void initState() {
    String apiKey = "ANONYMIZED";
    googlePlace = GooglePlace(apiKey);

    super.initState();
  }

  Future<void> getDetails(String placeId) async {

    var result = await this.googlePlace.details.get(placeId);
    if (result != null && result.result != null && mounted) {
      Uint8List image;
      if (result.result.photos != null) {
        if( result.result.photos.first.photoReference != null ){
          image = await googlePlace.photos
              .get(result.result.photos.first.photoReference, 10, 400);
        }

      }

      setState(() {
        searchStoreStateReturn = SearchStoreStateReturn(result.result, image, placeId);
      });
    }
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
        title: Text('searchYourBusiness').tr(),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(right: 20, left: 20, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText:  'searchYourBusiness'.tr(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    autoCompleteSearch(value);
                  } else {
                    if (predictions.length > 3 && mounted) {
                      setState(() {
                        predictions = [];
                      });
                    }
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        child: Icon(
                          Icons.pin_drop,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(predictions[index].description),
                      onTap: () async {
                        await getDetails(predictions[index].placeId);
                        Navigator.pop(context, searchStoreStateReturn);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions;
      });
    }
  }
}