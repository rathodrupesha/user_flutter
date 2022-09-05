import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hamrostay/Controllers/ChangePassword.dart';
import 'package:hamrostay/Controllers/BillInformation.dart';
import 'package:hamrostay/Controllers/FAQs.dart';
import 'package:hamrostay/Controllers/Login.dart';
import 'package:hamrostay/Controllers/MyRequests.dart';
import 'package:hamrostay/Controllers/Profile.dart';
import 'package:hamrostay/Controllers/TermsOfUse.dart';
import 'package:hamrostay/Models/UserModel.dart';
import 'package:hamrostay/Utils/API.dart';
import 'package:hamrostay/Utils/APICall.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/MyPrefs.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';
import 'package:provider/provider.dart';

import '../localization/app_model.dart';
import '../localization/localization.dart';
import 'RateHotel.dart';

class Settings extends StatefulWidget {
  Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> implements OnResponseCallback {
  var isShowLoader = false;
  var userData = UserData();
  String dropdownValue = Constants.isEnglishLanguage ? 'English' : 'Chinese';
  @override
  void initState() {
    super.initState();

    wsGetUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var appLanguage = Provider.of<AppModel>(context);

    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                  Constants.gradient1,
                  Constants.gradient2,
                  Constants.gradient3,
                  Constants.gradient4,
                ])),
          ),
          toolbarHeight: AppBar().preferredSize.height + (15),
          textTheme: TextTheme(
              headline6: TextStyle(
                  color: Colors.white,
                  fontSize: getProportionalScreenWidth(16),
                  fontWeight: FontWeight.w600,
                  fontFamily: "Inter-SemiBold")),
          title: Text(Translations.of(context).strMenu),
          titleSpacing: 0.0,
          elevation: 0,
          centerTitle: false,
          leading: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Image.asset(
              "assets/images/img_close.png",
              height: 25,
              width: 25,
              color: Colors.white,
              alignment: Alignment.centerLeft,
            ),
          ),
          actions: [
            Container(
              padding: EdgeInsets.only(right: 15),
              alignment: Alignment.center,
              child: DropdownButton<String>(
                value: dropdownValue,
                dropdownColor: Constants.appBlueColor,
                icon: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: Colors.white,
                ),
                iconSize: 24,
                elevation: 16,
                underline: Container(),
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: getProportionalScreenWidth(16),
                    color: Colors.white),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                  if (dropdownValue == 'English') {
                    appLanguage.changeLanguage(languageCode: "en");
                    Constants.isEnglishLanguage = true;
                  } else {
                    appLanguage.changeLanguage(languageCode: "zh");
                    Constants.isEnglishLanguage = false;
                  }
                  MyPrefs.putBoolean(
                      Keys.IS_ENGLISH, Constants.isEnglishLanguage);
                },
                items: <String>['English', 'Chinese']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style:
                          TextStyle(color: Colors.white, fontFamily: "Inter"),
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
        body: Material(
          child: SafeArea(
            top: false,
            bottom: false,
            left: false,
            child: _getHeaderView(),
          ),
        ));
  }

  Widget _getBodyView() {
    return Flexible(
      flex: 7,
      fit: FlexFit.loose,
      child: Container(
        padding: const EdgeInsets.only(left: 22, right: 22, top: 22),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                WidgetUtils().buttonSettingsWidget(
                    context, Translations.of(context).strChangePassword, () {
                  WidgetUtils().push(context, () => ChangePasswordScreen());
                }, 'assets/images/ic_lock.png'),
                WidgetUtils().sizeBoxHeight(10),
                Visibility(
                    visible: userData.checkInDatetime != null,
                    child: WidgetUtils().buttonSettingsWidget(
                        context, Translations.of(context).strBillInformation,
                        () {
                      WidgetUtils().push(context, () => BillInformation());
                    }, 'assets/images/img_terms_of_use.png')),
                Visibility(
                    visible: userData.checkInDatetime != null,
                    child: WidgetUtils().sizeBoxHeight(10)),
                WidgetUtils().buttonSettingsWidget(
                    context, Translations.of(context).strPrivacyPolicy, () {
                  WidgetUtils().push(
                      context,
                      () => TermsOfUse(
                          strTitle: Translations.of(context).strPrivacyPolicy,
                          strType: "privacy"));
                }, 'assets/images/img_privacy_policy.png'),
                WidgetUtils().sizeBoxHeight(10),
                WidgetUtils().buttonSettingsWidget(
                    context, Translations.of(context).strTermsOfUse, () {
                  WidgetUtils().push(
                      context,
                      () => TermsOfUse(
                            strTitle: Translations.of(context).strTermsOfUse,
                            strType: "terms",
                          ));
                }, 'assets/images/ic_terms_of_use.png'),
                WidgetUtils().sizeBoxHeight(10),
                WidgetUtils().buttonSettingsWidget(
                    context, Translations.of(context).strAboutUs, () {
                  WidgetUtils().push(
                      context,
                      () => TermsOfUse(
                            strTitle: Translations.of(context).strAboutUs,
                            strType: "aboutAs",
                          ));
                }, 'assets/images/ic_about_us.png'),
                WidgetUtils().sizeBoxHeight(10),
                WidgetUtils().buttonSettingsWidget(
                    context, Translations.of(context).strFAQs, () {
                  WidgetUtils().push(
                      context,
                      () => FAQs(
                            strTitle: Translations.of(context).strFAQs,
                          ));
                }, 'assets/images/img_faq.png'),
                WidgetUtils().sizeBoxHeight(10),
                WidgetUtils().buttonSettingsWidget(
                    context, Translations.of(context).strSignOut, () {
                  wsLogout();
                }, 'assets/images/img_sign_out.png'),
                WidgetUtils().sizeBoxHeight(10)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getHeaderView() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: getProportionalScreenWidth(104),
                  height: getProportionalScreenWidth(104),
                  child: InkWell(
                    onTap: () {
                      WidgetUtils().push(
                          context,
                          () => Profile(
                              strTitle:
                                  Translations.of(context).strEditProfile));
                    },
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            (SizeConfig.screenHeight * 0.28) / 2),
                        color: Constants.appBlueColor,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            (SizeConfig.screenHeight * 0.28) / 2),
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: userData.profileImage ?? "",
                          placeholder: (context, url) => CircleAvatar(
                              backgroundColor: Colors.white,
                              child: WidgetUtils()
                                  .simpleTextViewWithGivenFontSize(
                                      '${Constants.userInitials ?? ""}',
                                      getProportionalScreenWidth(15),
                                      Constants.appDarkBlueTextColor,
                                      "Inter",
                                      FontWeight.w700)),
                          errorWidget: (context, url, error) => CircleAvatar(
                              backgroundColor: Colors.white,
                              child: WidgetUtils()
                                  .simpleTextViewWithGivenFontSize(
                                      '${Constants.userInitials ?? ""}',
                                      getProportionalScreenWidth(15),
                                      Constants.appDarkBlueTextColor,
                                      "Inter",
                                      FontWeight.w700)),
                        ),
                      ),
                    ),
                  )),
              WidgetUtils().sizeBoxHeight(15),
              WidgetUtils().simpleTextViewWithGivenFontSize(
                  '${userData.email ?? ""}',
                  getProportionalScreenWidth(16),
                  Constants.blueColor,
                  "Inter",
                  FontWeight.w700),
              WidgetUtils().sizeBoxHeight(8),
              WidgetUtils().simpleTextViewWithGivenFontSize(
                  '${userData.roomNo ?? ""}',
                  getProportionalScreenWidth(16),
                  Constants.blueColor,
                  "Inter",
                  FontWeight.w400),
              _getBodyView()
            ],
          ),
        ),
        Visibility(
            child: Center(
                child: CircularProgressIndicator(
              strokeWidth: 5.0,
              backgroundColor: Constants.appSepratorColor,
              color: Constants.appAquaTextColor,
            )),
            visible: isShowLoader)
      ],
    );
  }

  void wsGetUserDetails() {
    setState(() {
      isShowLoader = true;
    });

    APICall(context).fetchUser(Map(), this);
  }

  void wsLogout() async {
    APICall(context).logout(Map(), this);
  }

  @override
  void onResponseError(String message, int requestCode) {
    setState(() {
      isShowLoader = false;
    });
    WidgetUtils().customToastMsg(message);
  }

  @override
  Future<void> onResponseReceived(response, int requestCode) async {
    if (requestCode == API.requestFetchUser && this.mounted) {
      setState(() {
        isShowLoader = false;
      });
      var userModel = UserModel.fromJson(response);

      if (userModel.code! == 200) {
        setState(() {
          userData = userModel.data!;
        });
        MyPrefs.saveObject(Keys.LOGIN_DATA, userModel.data);
      } else {
        WidgetUtils().customToastMsg(userModel.msg!);
      }
    } else if (requestCode == API.requestLogout && this.mounted) {
      var isRememberMe = await MyPrefs.getBoolean(Keys.IS_REMEMBER_ME);
      var email = await MyPrefs.getString(Keys.EMAIL);
      var pass = await MyPrefs.getString(Keys.PASSWORD);
      MyPrefs.clearPref();
      MyPrefs.putString(Keys.EMAIL, email);
      MyPrefs.putString(Keys.PASSWORD, pass);
      MyPrefs.putBoolean(Keys.IS_REMEMBER_ME, isRememberMe);
      Constants.token = null;

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()),
          (Route<dynamic> route) => false);
    }
  }
}
