import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_plugin/models/nfc_event.dart';
import 'package:flutter_nfc_plugin/models/nfc_message.dart';
import 'package:flutter_nfc_plugin/nfc_plugin.dart';
import 'package:tw_business_app/generated/codegen_loader.g.dart';
import 'package:tw_business_app/models/user.dart';
import 'package:tw_business_app/screen/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:tw_business_app/services/auth.dart';
import 'package:tw_business_app/shared/api.dart';
import 'package:tw_business_app/shared/loading.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  await Firebase.initializeApp();
  //print('Handling a background message ${message.messageId}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('it'),
        /*
        Locale('de'),
        Locale('nl'),
        Locale('fr')

         */
      ],
      path:
          'assets/translations', // <-- change the path of the translation files
      fallbackLocale: Locale('en'),
      startLocale: Locale("en"),
      assetLoader: CodegenLoader(),
      child: TWApp()));
}

class TWApp extends StatefulWidget {
  const TWApp({Key key}) : super(key: key);

  @override
  _TWAppState createState() => _TWAppState();
}

class _TWAppState extends State<TWApp> {
  NfcMessage nfcMessageStartedWith;
  NfcPlugin nfcPlugin = NfcPlugin();

  Future<void> initPlatformState() async {
    try {
      final NfcEvent _nfcEventStartedWith = await nfcPlugin.nfcStartedWith;
      //print('NFC event started with is ${_nfcEventStartedWith.toString()}');
      if (_nfcEventStartedWith != null) {
        setState(() {
          nfcMessageStartedWith = _nfcEventStartedWith.message;
          //print(nfcMessageStartedWith.payload.first);

          // parse nfc link to var
          parseNfcUrl(nfcMessageStartedWith.payload.first);
        });
      }
    } on PlatformException {
      // print('Method "NFC event started with" exception was thrown');
    }
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    // FirebaseMessaging.instance.getToken().then((value) => print(value));
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        Navigator.pushNamed(
          context,
          '/message',
        );
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android
                icon: 'launch_background',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Navigator.pushNamed(
        context, '/message',
        // arguments: MessageArguments(message, true)
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          // print("FireBase Error ...");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return StreamProvider<AppUser>.value(
            initialData: null,
            value: AuthService().user,
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              home: Wrapper(),
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
