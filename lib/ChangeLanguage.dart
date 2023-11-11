import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tw_business_app/shared/api.dart';


class LanguageChangeProvider with ChangeNotifier {
  Locale _currentLocale = new Locale("it");

  Locale get currentLocale => _currentLocale;

  void changeLocale(Locale _locale) {
    this.._currentLocale = _locale;
    notifyListeners();
  }
}
final List locales = [
  {'name': 'English', 'code': 'en','locale': Locale('en')},
  {'name': 'Italiano','code': 'it', 'locale': Locale('it')},
];

buildLanguageDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (builder) {
        return AlertDialog(
          title: Text('Choose Your Language'),
          content: Container(
            width: double.maxFinite,
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      child: Text(locales[index]['name']),
                      onTap: () async {
                        //print(locales[index]['name']);
                        //updateLanguage(locale[index]['locale']);
                        //await context.setLocale(locale[index]['locale']);
                        await updateLanguage(locales[index]['code']);
                        await context.setLocale(locales[index]['locale']);
                        Get.updateLocale(locales[index]['locale']);

                        Navigator.pop(context);


                      },
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.blue,
                  );
                },
                itemCount: locales.length),
          ),
        );
      });
}