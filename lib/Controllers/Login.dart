import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hamrostay/Controllers/Dashboard.dart';
import 'package:hamrostay/Controllers/StoryView.dart';
import 'package:hamrostay/Models/GetAnnounceCategoryModel.dart';
import 'package:hamrostay/Models/UserModel.dart';
import 'package:hamrostay/Utils/API.dart';
import 'package:hamrostay/Utils/APICall.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/MyPrefs.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/Validations.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';
import 'package:hamrostay/localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/device_utils.dart';
import '../Utils/firebase_cloud_messaging.dart';
import 'ForgotPassword.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> implements OnResponseCallback {
  var _isShowLoader = false;
  var _emailController = TextEditingController();
  var _passwdController = TextEditingController();
  var _isChecked = false;

  List<AnnouncementCategoryRows> objAnnouncementCategory = [];

  @override
  void initState() {
    super.initState();
    _loadUserNameAndPassword();
    wsGetAnnouncementCategory();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        body: Material(
      child: SafeArea(
        top: false,
        bottom: false,
        child: _getBodyView(),
      ),
    ));
  }

  Widget _getBodyView() {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Container(
            height: SizeConfig.screenHeight,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                  Constants.gradient1,
                  Constants.gradient2,
                  Constants.gradient3,
                  Constants.gradient4,
                ])),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: SizeConfig.screenHeight * 0.40,
                  child: GridView.builder(
                    itemCount: objAnnouncementCategory.length,
                    scrollDirection: Axis.vertical,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio:
                            (((SizeConfig.screenWidth - 120) * 0.4) /
                                ((SizeConfig.screenWidth - 20) * 0.4))),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                              margin: EdgeInsets.all(8),
                              width: getProportionalScreenWidth(70),
                              height: getProportionalScreenWidth(70),
                              child: InkWell(
                                onTap: () {
                                  WidgetUtils().push(
                                      context,
                                      () => MoreStories(
                                            categoryId:
                                                objAnnouncementCategory[index]
                                                    .id
                                                    .toString(),
                                            categoryName:
                                                objAnnouncementCategory[index]
                                                    .categoryName
                                                    .toString(),
                                          ));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        (SizeConfig.screenHeight * 0.28) / 2),
                                    color: Colors.white,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        (SizeConfig.screenHeight * 0.28) / 2),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      imageUrl: objAnnouncementCategory[index]
                                              .ancCatImage ??
                                          "",
                                      placeholder: (context, url) => Container(
                                        color:
                                            Constants.appAquaPlaceholderColor,
                                        child: Image.asset(
                                          'assets/images/img_placeholder_logo.png',
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        color:
                                            Constants.appAquaPlaceholderColor,
                                        child: Image.asset(
                                          'assets/images/img_placeholder_logo.png',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          Container(
                              alignment: Alignment.center,
                              width: getProportionalScreenWidth(100),
                              child: WidgetUtils()
                                  .simpleTextViewWithGivenFontSize(
                                      objAnnouncementCategory[index]
                                              .categoryName ??
                                          "",
                                      getProportionalScreenWidth(13),
                                      Colors.white,
                                      "Inter",
                                      FontWeight.w700,
                                      maxLine: 3,
                                      txtAlign: TextAlign.center,
                                      txtOverflow: TextOverflow.ellipsis))
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(
                      left: getProportionalScreenWidth(12),
                      right: getProportionalScreenWidth(12),),
                  height: SizeConfig.screenHeight * 0.55,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: SizeConfig.screenWidth,
                        child: Align(
                            child: Image.asset(
                          'assets/images/logo.png',
                          width: SizeConfig.screenWidth * 0.5,
                        )),
                      ),
                      SizedBox(
                        height: getProportionalScreenHeight(30),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.only(
                              topRight: Radius.circular(20.0),
                              topLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0)),
                          color: Colors.white,
                        ),
                        width: SizeConfig.screenWidth,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, left: 20, right: 20,bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                WidgetUtils().customTextField(
                                    "Inter",
                                    getProportionalScreenWidth(16),
                                    Translations.of(context).strUserName,
                                    FontWeight.normal,
                                    Constants.appGrayBottomLineColor,
                                    Constants.appDarkBlueTextColor,
                                    false,
                                    myController: _emailController,
                                    isHintText: true),
                                WidgetUtils().sizeBoxHeight(15),
                                WidgetUtils().customTextField(
                                    "Inter",
                                    getProportionalScreenWidth(16),
                                    Translations.of(context).strPassword,
                                    FontWeight.normal,
                                    Constants.appGrayBottomLineColor,
                                    Constants.appDarkBlueTextColor,
                                    true,
                                    myController: _passwdController,
                                    isHintText: true),
                                WidgetUtils().sizeBoxHeight(10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _isChecked,
                                          onChanged: _handleRemeberme,
                                          activeColor: Constants.appBlueColor,
                                        ),
                                        WidgetUtils()
                                            .simpleTextViewWithGivenFontSize(
                                                Translations.of(context)
                                                    .strRememberMe,
                                                getProportionalScreenWidth(12),
                                                Constants.appDarkBlueTextColor,
                                                "Inter",
                                                FontWeight.w400),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () => {
                                        WidgetUtils().push(
                                            context, () => ForgotPassword())
                                      },
                                      child: WidgetUtils()
                                          .simpleTextViewWithGivenFontSize(
                                              Translations.of(context)
                                                  .strForgotPasswordWithQuestion,
                                              getProportionalScreenWidth(12),
                                              Constants.appDarkBlueTextColor,
                                              "Inter",
                                              FontWeight.w400,
                                              isUnderlinedText: true),
                                    )
                                  ],
                                ),
                                WidgetUtils().sizeBoxHeight(10),
                                WidgetUtils().customButton(
                                  context,
                                  '',
                                  Constants.appBlueColor,
                                  "Inter",
                                  getProportionalScreenWidth(16),
                                  Colors.white,
                                  () {
                                    wsLogin();
                                  },
                                  btnAttributedText:
                                      Translations.of(context).strLogin,
                                  strSubTextFontFamily: "Inter",
                                ),
                                WidgetUtils().sizeBoxHeight(20),
                                Align(
                                  alignment: Alignment.center,
                                  child: WidgetUtils()
                                      .simpleTextViewWithGivenFontSize(
                                          Translations.of(context)
                                              .strOrYouCanVisitTheFrontDesk,
                                          getProportionalScreenWidth(12),
                                          Constants.appDarkBlueTextColor,
                                          "Inter",
                                          FontWeight.w400),
                                ),
                                //WidgetUtils().sizeBoxHeight(20),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 30,)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
            child: Center(
                child: CircularProgressIndicator(
              strokeWidth: 5.0,
              backgroundColor: Constants.appSepratorColor,
              color: Constants.appAquaTextColor,
            )),
            visible: _isShowLoader)
      ],
    );
  }

  void wsLogin() {
    FocusScope.of(context).requestFocus(FocusNode());
    var map = Map();
    _handleRemeberme(_isChecked);
    if (Validations(context)
        .loginValidations(_emailController.text, _passwdController.text)) {
      setState(() {
        _isShowLoader = true;
      });

      map["password"] = _passwdController.text;
      map["user_name"] = _emailController.text;
      map["role_id"] = 3;

      APICall(context).login(map, this);
    }
  }

  void wsDeviceInfo(int id) {
    FocusScope.of(context).requestFocus(FocusNode());

    var map = Map();

    map["device_id"] = DeviceUtil().deviceId;
    map["device_type"] = DeviceUtil().deviceType;
    map["device_token"] = FireBaseCloudMessagingWrapper().fcmToken;
    map["id"] = id.toString();

    APICall(context).deviceInfo(map, this);
  }

  Future<void> wsGetAnnouncementCategory() async {
    setState(() {
      _isShowLoader = true;
    });

    APICall(context).getAnnouncementCategory(Map(), this);
  }

  @override
  void onResponseError(String message, int requestCode) {
    setState(() {
      _isShowLoader = false;
    });

    WidgetUtils().customToastMsg(message);
  }

  @override
  void onResponseReceived(response, int requestCode) {
    if (requestCode == API.requestLogin && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });
      var userModel = UserModel.fromJson(response);

      if (userModel.code! == 200) {
        WidgetUtils().customToastMsg(userModel.msg!);

        MyPrefs.saveObject(Keys.LOGIN_DATA, userModel.data);
        MyPrefs.saveObject(Keys.TOKEN, userModel.data!.accessToken);
        MyPrefs.putString(Keys.EMAIL, _emailController.text.toString());
        MyPrefs.putString(Keys.PASSWORD, _passwdController.text.toString());
        MyPrefs.putBoolean(Keys.IS_REMEMBER_ME, _isChecked);

        MyPrefs.readObject(Keys.LOGIN_DATA);

        Constants.token = userModel.data!.accessToken;

        String strFullname =
            '${userModel.data!.firstName!.replaceAll(" ", "")} ${userModel.data!.lastName ?? ""}';
        List<String> nameparts = strFullname.split(" ");

        String initials = nameparts[0].characters.first.toUpperCase() +
            nameparts[1].characters.first.toUpperCase();

        Constants.userInitials = initials;

        wsDeviceInfo(userModel.data!.id!);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Dashboard()),
            (Route<dynamic> route) => false);
      } else {
        WidgetUtils().customToastMsg(userModel.msg!);
      }
    } else if (requestCode == API.requestAnnouncementCategory && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });
      var announcementCategory =
          GetAnnouncementCategoryModel.fromJson(response);

      if (announcementCategory.code! == 200 &&
          announcementCategory.data != null) {
        objAnnouncementCategory = announcementCategory.data!.rows!;
      } else {
        WidgetUtils().customToastMsg(announcementCategory.msg!);
      }
    }
  }

  //handle remember me function
  void _handleRemeberme(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });
    print("Saving Preference");
    print(_isChecked);
    print(_emailController.text);
    print(_passwdController.text);
  }

//load username and password
  void _loadUserNameAndPassword() async {
    try {
      var isRememberMe = await MyPrefs.getBoolean(Keys.IS_REMEMBER_ME);
      var email = await MyPrefs.getString(Keys.EMAIL);
      var pass = await MyPrefs.getString(Keys.PASSWORD);
      print(isRememberMe);
      print(email);
      print(pass);
      if (isRememberMe) {
        setState(() {
          _isChecked = true;
        });
        _emailController.text = email;
        _passwdController.text = pass;
      }
    } catch (e) {
      print(e);
    }
  }
}
