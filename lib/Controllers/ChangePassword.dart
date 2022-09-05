import 'package:flutter/material.dart';

import '../../Models/BaseResponseModel.dart';
import '../../Models/UserModel.dart';
import '../../Utils/API.dart';
import '../../Utils/APICall.dart';
import '../../Utils/Constants.dart';
import '../../Utils/WidgetUtils.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';

import '../localization/localization.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>  implements OnResponseCallback {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final FocusNode currentPassFocusNode = FocusNode();
  final FocusNode passFocusNode = FocusNode();
  final FocusNode confirmPassFocusNode = FocusNode();

  var _isShowLoader = false;
  var userModel = UserData();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.appLightBackgroundColor,
      key: scaffoldKey,
      appBar: WidgetUtils().customAppBar(
        context,
        Translations.of(context).strChangePassword,
        'assets/images/btn_back.png',
        Colors.white,
        () {
          Navigator.of(context).pop();
        },
        imgColor: Colors.white,
      ),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  width: double.infinity,
                  color: Constants.appLightBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12),
                      WidgetUtils().simpleTextViewWithGivenFontSize(
                          Translations.of(context).strOldPassword,
                          getProportionalScreenWidth(14),
                          Constants.appLightBlueTextColor,
                          "Inter",
                          FontWeight.normal),
                      WidgetUtils().customTextField(
                          "Inter",
                          getProportionalScreenWidth(16),
                          '',
                          FontWeight.normal,
                          Constants.appGrayBottomLineColor,
                          Constants.appDarkBlueTextColor,
                          true,
                          myController: oldPasswordController),
                      WidgetUtils().sizeBoxHeight(30),

                      WidgetUtils().simpleTextViewWithGivenFontSize(
                          Translations.of(context).strNewPassword,
                          getProportionalScreenWidth(14),
                          Constants.appLightBlueTextColor,
                          "Inter",
                          FontWeight.normal),
                      WidgetUtils().customTextField(
                          "Inter",
                          getProportionalScreenWidth(16),
                          '',
                          FontWeight.normal,
                          Constants.appGrayBottomLineColor,
                          Constants.appDarkBlueTextColor,
                          true,
                          myController: passwordController),
                      WidgetUtils().sizeBoxHeight(30),

                      //confirm new password
                      WidgetUtils().simpleTextViewWithGivenFontSize(
                          Translations.of(context).strConfirmNewPassword,
                          getProportionalScreenWidth(14),
                          Constants.appLightBlueTextColor,
                          "Inter",
                          FontWeight.normal),
                      WidgetUtils().customTextField(
                          "Inter",
                          getProportionalScreenWidth(16),
                          '',
                          FontWeight.normal,
                          Constants.appGrayBottomLineColor,
                          Constants.appDarkBlueTextColor,
                          true,
                          myController: confirmPasswordController),
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, top: 25, bottom: 35),
                        child: WidgetUtils().customButton(
                          context,
                          '',
                          Constants.appBlueColor,
                          "Inter",
                          getProportionalScreenWidth(16),
                          Colors.white,
                          () {
                            wsChangePassword();
                          },
                          btnAttributedText: Translations.of(context).btnSubmitSmall,
                          strSubTextFontFamily: "Inter",
                        )),
                  ))),

          Visibility(
              child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 5.0,
                    backgroundColor: Constants.appSepratorColor,
                    color: Constants.appAquaTextColor,
                  )),
              visible: _isShowLoader)
        ],
      ),
    );
  }

  Future<void> wsChangePassword() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    if(oldPasswordController.text.toString().isEmpty){
      WidgetUtils().customToastMsg(Translations.of(context).strPleaseEnterYourOldPassword);
      return;
    }else if(passwordController.text.toString().isEmpty){
      WidgetUtils().customToastMsg(Translations.of(context).strPleaseEnterNewPassword);
      return;
    }else if(confirmPasswordController.text.toString().isEmpty){
      WidgetUtils().customToastMsg(Translations.of(context).strPleaseEnterConfirmPassword);
      return;
    }

    setState(() {
      _isShowLoader = true;
    });

    var map = Map();

    map["old_password"] =  oldPasswordController.text.toString();
    map["new_password"] = passwordController.text.toString();
    map["confirm_password"] = confirmPasswordController.text.toString();

    APICall(context).changePasswordApi(map, this);
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
    if (requestCode == API.requestChangePassword && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var baseResponseModel = BaseResponseModel.fromJson(response);

      if (baseResponseModel.code! == 200) {
        WidgetUtils().customToastMsg(baseResponseModel.msg!);
        Navigator.pop(context);
      } else {
        WidgetUtils().customToastMsg(baseResponseModel.msg!);
      }
    }
  }
}
