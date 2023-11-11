import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tw_business_app/services/auth.dart';
import 'package:tw_business_app/shared/api.dart';
import 'package:tw_business_app/shared/constants.dart';
import 'package:easy_localization/easy_localization.dart';

List<String> helpCat = [
  "Question",
  "Bug Report",
  "Feature Request",
];

class HelpForm extends StatefulWidget {
  const HelpForm({Key key}) : super(key: key);

  @override
  _HelpFormState createState() => _HelpFormState();
}

class _HelpFormState extends State<HelpForm> {
  final _formKey = GlobalKey<FormState>();
  String category = helpCat.first;
  String message = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
          title: Text("Send Feedback"),
          elevation: 0.0,
        ),
        body: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.help),
                    title: DropdownButtonFormField<String>(
                      decoration: textInputDecoration,
                      value: category,
                      isExpanded: true,
                      items: helpCat.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() => category = val);
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.chat),
                    title: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 8,
                      decoration: textInputDecoration.copyWith(
                          hintText: 'message'.tr()),
                      validator: (val) =>
                          val.isEmpty ? 'enterYourMessage'.tr() : null,
                      onChanged: (val) {
                        setState(() => message = val);
                      },
                    ),
                  ),
                  Center(
                    child: ButtonTheme(
                      minWidth: 150,
                      child: ElevatedButton(
                          child: Text('Submit'),
                          onPressed: () async {
                            String result = await helpAPI(message, category,
                                AuthService().currentUser().uid);
                            if (result != null) {
                              Navigator.pop(context);

                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        title: Text("${category} submitted"),
                                        content:
                                            Text('thanksWeWillAnswer'.tr()),
                                      ));
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        title: Text("Oops!"),
                                        content: Text('error'.tr()),
                                      ));
                            }
                          }),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
