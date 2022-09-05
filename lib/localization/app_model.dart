import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Constants.dart';
import '../utils/device_utils.dart';
import '../utils/firebase_cloud_messaging.dart';


class AppModel with ChangeNotifier {

  bool isLoading = true;
  bool isUserLogin = false;

  static const Locale enLocale = Locale('en');
  static const Locale zhLocale = Locale('zh');

  Locale? _appLocale;
  Locale get appLocal => _appLocale ?? AppModel.enLocale;

  AppModel() {
    print("App Model instance created");
  }

  Future setupInitial() async {
    print(" ------ Perform Initial Setup ------ ");

    String deviceLocaleCode = Platform.localeName.split('_').first;
    print("myLocale Cdde : $deviceLocaleCode");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cLanguage = prefs.getString("CurrentDeviceLanguage") ?? ((deviceLocaleCode.toLowerCase() != 'zh') ? 'en' : deviceLocaleCode);
    print("cLanguage Cdde : $cLanguage");

    if (cLanguage == 'zh') {
      _appLocale = AppModel.zhLocale;
      Constants.isEnglishLanguage = false;
    } else {
      _appLocale = AppModel.enLocale;
      Constants.isEnglishLanguage = true;
    }

    // Update Device info
    await DeviceUtil().updateDeviceInfo();

    /// Update FCM Token
    FireBaseCloudMessagingWrapper messagingWrapper = FireBaseCloudMessagingWrapper();
    Future.delayed(const Duration(seconds: 3), () async {
      await messagingWrapper.getFCMToken();
    });

    isLoading = false;
    notifyListeners();
  }

  List<Locale> get supportedLocales => [enLocale, zhLocale];

  Future changeLanguage({String? languageCode}) async {
    if ((languageCode ?? '').isEmpty) return;
    print("Current Local changed with language code $languageCode");

    if (languageCode?.toLowerCase() == 'en') { _appLocale = enLocale; }
    if (languageCode?.toLowerCase() == 'zh') { _appLocale = zhLocale; }
    else { _appLocale = enLocale; }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('CurrentDeviceLanguage', (_appLocale?.languageCode ?? '').toLowerCase());
    notifyListeners();
  }
}