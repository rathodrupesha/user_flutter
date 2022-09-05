import 'package:flutter/material.dart';
import 'package:hamrostay/Controllers/Dashboard.dart';
import 'package:hamrostay/Controllers/Login.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/MyPrefs.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'Utils/device_utils.dart';
import 'Utils/firebase_cloud_messaging.dart';
import 'bloc/base_bloc.dart';
import 'localization/app_model.dart';
import 'localization/cupertino_localisation_delegate.dart';
import 'localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // Update Device info
  await DeviceUtil().updateDeviceInfo();

  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(!kDebugMode);

  /// Update FCM Token
  FireBaseCloudMessagingWrapper messagingWrapper =
      FireBaseCloudMessagingWrapper();
  Future.delayed(Duration(seconds: 3), () async {
    await messagingWrapper.getFCMToken();
  });

  final AppModel _appModel = AppModel();
  await _appModel.setupInitial();

  runApp(MyApp(
    appModel: _appModel,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final AppModel appModel;

  const MyApp({Key? key, required this.appModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppModel>.value(
      value: appModel,
      child: Consumer<AppModel>(
        builder: (context, value, child) {
          return MultiProvider(
            providers: [
              Provider<BaseBloc>.value(value: BaseBloc()),
            ],
            child: OverlaySupport.global(
                child: MaterialApp(
              localizationsDelegates: const [
                Translations.delegate,
                FallbackCupertinoLocalisationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: value.supportedLocales,
              locale: value.appLocal,
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                // This is the theme of your application.
                //
                // Try running your application with "flutter run". You'll see the
                // application has a blue toolbar. Then, without quitting the app, try
                // changing the primarySwatch below to Colors.green and then invoke
                // "hot reload" (press "r" in the console where you ran "flutter run",
                // or simply save your changes to "hot reload" in a Flutter IDE).
                // Notice that the counter didn't reset back to zero; the application
                // is not restarted.
                primarySwatch: Colors.blue,
              ),
              home: FutureBuilder<bool>(
                future: autoLogin(), // async work
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.data == false || snapshot.data == null) {
                    return Login();
                  } else {
                    return Dashboard();
                  }
                },
              ),
            )),
          );
        },
      ),
    );
  }

  Future<bool> autoLogin() async {
    var userModel = await WidgetUtils.fetchUserDetailsFromPreference();
    var strTokenFromPref = await MyPrefs.readObject(Keys.TOKEN);

    if (userModel != null) {
      Constants.token = strTokenFromPref;
      // Constants.isEnglishLanguage = await MyPrefs.getBoolean(Keys.IS_ENGLISH);
      return true;
    } else {
      // MyPrefs.putBoolean(Keys.IS_ENGLISH, Constants.isEnglishLanguage);
      return false;
    }
  }
}
