import 'package:flutter/material.dart';
import 'package:hamrostay/Models/ForgotPasswordResponseModel.dart';
import 'package:hamrostay/Utils/API.dart';
import 'package:hamrostay/Utils/APICall.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';

import '../localization/localization.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword>
    implements OnResponseCallback {
  var _isShowLoader = false;
  var _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        backgroundColor: Constants.appLightBackgroundColor,
        appBar: WidgetUtils().customAppBar(
          context,
          Translations.of(context).strForgotPassword,
          'assets/images/btn_back.png',
          Colors.white,
          () {
            Navigator.of(context).pop();
          },
          imgColor: Colors.white,
        ),
        body: Material(
          child: SafeArea(
            top: false,
            bottom: false,
            left: false,
            child: _getBodyView(),
          ),
        ));
  }

  Widget _getBodyView() {
    return Stack(
      children: [
        Padding(
            padding: EdgeInsets.only(top: 40, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                WidgetUtils().sizeBoxHeight(50),
                WidgetUtils().simpleTextViewWithGivenFontSize(
                    Translations.of(context).strUserName,
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
                    false,
                    myController: _usernameController),
                WidgetUtils().sizeBoxHeight(50),
                WidgetUtils().customButton(
                  context,
                  '',
                  Constants.appBlueColor,
                  "Inter",
                  getProportionalScreenWidth(16),
                  Colors.white,
                  () {
                    wsForgotPassword();
                  },
                  btnAttributedText: Translations.of(context).btnSubmit,
                  strSubTextFontFamily: "Inter",
                )
              ],
            )),
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

  Future<void> wsForgotPassword() async {
    setState(() {
      _isShowLoader = true;
    });

    if (_usernameController.text.isEmpty) {
      WidgetUtils().customToastMsg(Translations.of(context).strPleaseEnterUsername);
      return;
    }

    var map = Map();
    map["user_name"] = _usernameController.text;
    map["role_id"] = 3;

    APICall(context).forgotPassword(map, this);
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
    if (requestCode == API.requestForgotPassword && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var data = ForgotPasswordResponseModel.fromJson(response);

      if (data.msg != null) {
        WidgetUtils().customToastMsg(data.msg!);
        if (data.code == 200) {
          Navigator.of(context).pop();
        }
      }
    }
  }
}
