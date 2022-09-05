import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hamrostay/Models/UserModel.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/MyPrefs.dart';
import 'SizeConfig.dart';

class WidgetUtils {
  static Future<UserData?> fetchUserDetailsFromPreference() async {
    var json = await MyPrefs.readObject(Keys.LOGIN_DATA);
    if (json == null) {
      return null;
    } else {
      var userModel = UserData.fromJson(json);
      return userModel;
    }
  }

  customAppBar(BuildContext context, String strTitle, String imgName,
      Color txtColor, Function onBtnPress,
      {Color imgColor = Colors.transparent,
      bool isRightControl = false,
      String rightImgName = "",
      Function? onRightBtnPress,
      double barHeight = 15}) {
    return AppBar(
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
      toolbarHeight: AppBar().preferredSize.height + (barHeight),
      centerTitle: false,
      titleSpacing: 0.0,
      brightness: Brightness.light,
      elevation: 0,
      leading: TextButton(
        onPressed: () {
          onBtnPress();
        },
        child: imgName != ""
            ? Image.asset(
                imgName,
                height: 25,
                width: 25,
                color: imgColor,
                alignment: Alignment.centerLeft,
              )
            : Container(),
      ),
      textTheme: TextTheme(
          headline6: TextStyle(
              color: Colors.white,
              fontSize: getProportionalScreenWidth(16),
              fontWeight: FontWeight.w600,
              fontFamily: "Inter-SemiBold")),
      title: Text(strTitle),
      actions: isRightControl
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: TextButton(
                  onPressed: () {
                    onRightBtnPress!();
                  },
                  child: CachedNetworkImage(
                    imageUrl: rightImgName,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1.0),
                        shape: BoxShape.circle,
                        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => CircleAvatar(
                        backgroundColor: Colors.white,
                        child: WidgetUtils().simpleTextViewWithGivenFontSize(
                            '${Constants.userInitials ?? ""}',
                            getProportionalScreenWidth(15),
                            Constants.appDarkBlueTextColor,
                            "Inter",
                            FontWeight.w700)),
                    errorWidget: (context, url, error) => CircleAvatar(
                        backgroundColor: Colors.white,
                        child: WidgetUtils().simpleTextViewWithGivenFontSize(
                            '${Constants.userInitials ?? ""}',
                            getProportionalScreenWidth(15),
                            Constants.appDarkBlueTextColor,
                            "Inter",
                            FontWeight.w700)),
                  ),
                ),
              )
            ]
          : null,
    );
  }

  customAppBarWithSkipButton(
      BuildContext context,
      String strTitle,
      String rightButtonTitle,
      String imgName,
      Color txtColor,
      Function onBtnPress,
      {Color imgColor = Colors.transparent,
      Function? onRightBtnPress,
      double barHeight = 15}) {
    return AppBar(
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
      toolbarHeight: AppBar().preferredSize.height + (barHeight),
      centerTitle: false,
      titleSpacing: 0.0,
      brightness: Brightness.light,
      elevation: 0,
      leading: TextButton(
        onPressed: () {
          onBtnPress();
        },
        child: imgName != ""
            ? Image.asset(
                imgName,
                height: 25,
                width: 25,
                color: imgColor,
                alignment: Alignment.centerLeft,
              )
            : Container(),
      ),
      textTheme: TextTheme(
          headline6: TextStyle(
              color: Colors.white,
              fontSize: getProportionalScreenWidth(16),
              fontWeight: FontWeight.w600,
              fontFamily: "Inter-SemiBold")),
      title: Text(strTitle),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: TextButton(
            onPressed: () {
              onRightBtnPress!();
            },
            style: TextButton.styleFrom(
                // primary: Colors.pink,
                ),
            child: Text(
              rightButtonTitle,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: getProportionalScreenWidth(14),
                  fontWeight: FontWeight.w500,
                  fontFamily: "Inter-SemiBold"),
            ),
          ),
        )
      ],
    );
  }

  simpleTextViewWithGivenFontSize(String str, double size, Color colors,
      String strFontFamily, FontWeight strFontWeight,
      {TextAlign txtAlign = TextAlign.left,
      Color mybackgroundColor = Colors.transparent,
      bool isUnderlinedText = false,
      int maxLine = 100,
      TextOverflow txtOverflow = TextOverflow.visible}) {
    return Text(
      str,
      textAlign: txtAlign,
      overflow: txtOverflow,
      maxLines: maxLine,
      style: TextStyle(
          decoration:
              isUnderlinedText ? TextDecoration.underline : TextDecoration.none,
          decorationStyle: isUnderlinedText ? TextDecorationStyle.solid : null,
          fontSize: getProportionalScreenWidth(size),
          fontFamily: strFontFamily,
          fontWeight: strFontWeight,
          backgroundColor: mybackgroundColor,
          color: colors == Colors.black ? Colors.white : colors),
    );
  }

  sizeBoxHeight(double customHeight) {
    return SizedBox(
      height: customHeight,
    );
  }

  sizeBoxWidth(double customWidth) {
    return SizedBox(
      width: customWidth,
    );
  }

  customTextField(
      String strFontFamily,
      double fontsize,
      String text,
      FontWeight strFontWeight,
      Color underlineColor,
      Color textColor,
      bool isSecureText,
      {TextInputType typeOfKeyboard = TextInputType.text,
      Color hintTextColor = Constants.appLightBlueTextColor,
      bool isHintText = false,
      required TextEditingController myController,
      bool disableTextField = false,
      isTextLimitForMobile = false}) {
    return TextField(
      autocorrect: false,
      maxLength: isTextLimitForMobile == true ? 11 : null,
      autofocus: false,
      readOnly: disableTextField,
      controller: myController,
      obscureText: isSecureText,
      keyboardType: typeOfKeyboard,
      style: TextStyle(
          fontFamily: strFontFamily,
          fontSize: fontsize,
          color: textColor,
          fontWeight: strFontWeight),
      decoration: InputDecoration(
          counterText: "",
          hintText: isHintText ? text : "",
          hintStyle: TextStyle(color: hintTextColor),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: underlineColor),
          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: underlineColor))),
    );
  }

  customButton(
      BuildContext context,
      String btnText,
      Color backgroundColor,
      String strMainTextFontFamily,
      double fontsize,
      Color textColor,
      Function onBtnPress,
      {String imgName = "",
      String btnAttributedText = "",
      String strSubTextFontFamily = "Inter",
      bool isOuterBorder = false}) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    SizeConfig().init(context);

    return Container(
        height: deviceHeight * 0.06,
        width: deviceWidth * 0.9,
        decoration: BoxDecoration(
          borderRadius:
              new BorderRadius.all(new Radius.circular(deviceWidth * 0.04)),
          border: isOuterBorder ? Border.all(color: textColor) : null,
          color: backgroundColor,
        ),
        child: TextButton(
          onPressed: () {
            onBtnPress();
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              imgName != ""
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.asset(
                        imgName,
                        alignment: Alignment.centerLeft,
                        height: deviceWidth * 0.09,
                        width: imgName == '' ? 0 : deviceWidth * 0.09,
                      ),
                    )
                  : Container(),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: btnText,
                        style: TextStyle(
                            fontFamily: strMainTextFontFamily,
                            fontSize: getProportionalScreenWidth(fontsize),
                            color: textColor)),
                    TextSpan(
                        text: btnAttributedText,
                        style: TextStyle(
                            fontFamily: strSubTextFontFamily,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                            fontSize: getProportionalScreenWidth(fontsize))),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  buttonSimpleText(
      String btnText,
      String strMainTextFontFamily,
      double fontsize,
      Color textColor,
      Function onBtnPress,
      FontWeight strFontWeight,
      {Color bgColor = Colors.transparent,
      bool isRoundedCorners = false,
      double cornerRadius = 0.0,
      bool isShowBorder = false,
      borderColor = Constants.appRedColor}) {
    return TextButton(
      onPressed: () {
        onBtnPress();
      },
      style: !isRoundedCorners
          ? TextButton.styleFrom(primary: textColor, backgroundColor: bgColor)
          : ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(bgColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                side: isShowBorder
                    ? BorderSide(
                        color: borderColor, width: 1, style: BorderStyle.solid)
                    : BorderSide(width: 0.0, color: Colors.transparent),
                borderRadius: BorderRadius.circular(cornerRadius),
              ))),
      child: Text(
        btnText,
        style: TextStyle(
            fontFamily: strMainTextFontFamily,
            fontWeight: strFontWeight,
            color: textColor,
            fontSize: getProportionalScreenWidth(fontsize)),
      ),
    );
  }

  buttonSettingsWidget(BuildContext context, String btnText,
      Function onBtnPress, String imgName) {
    return Container(
      margin: EdgeInsets.all(2),
      child: ElevatedButton(
        onPressed: () {
          onBtnPress();
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: Size(88, 45),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            imgName != ""
                ? Padding(
                    padding: const EdgeInsetsDirectional.only(
                        end: 20.0, top: 12.0, bottom: 12.0),
                    child: Image.asset(
                      imgName,
                      height: 30,
                      width: 30,
                    ),
                  )
                : Container(),
            Expanded(
                flex: 1,
                child: WidgetUtils().simpleTextViewWithGivenFontSize(
                    btnText,
                    getProportionalScreenWidth(16),
                    Constants.blueColor,
                    "Inter-SemiBold",
                    FontWeight.w500)),
            Expanded(
                flex: 0,
                child: Image.asset(
                  'assets/images/btn_right_arrow.png',
                  color: Constants.appBlueColor,
                  height: 12,
                  width: 12,
                )),
          ],
        ),
      ),
    );
  }

  push(BuildContext context, Widget Function() newScreen) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return newScreen();
    }));
  }

  presentView(BuildContext context, Widget Function() newScreen) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => newScreen(),
      ),
    );
  }

  customToastMsg(String customMsg) {
    return Fluttertoast.showToast(
        msg: customMsg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  noDataFoundText(
      bool isShowLoader, String text, double imgHeight, double imgWidth) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        child: isShowLoader
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                    strokeWidth: 5.0, backgroundColor: Colors.white,color: Constants.appAquaTextColor,),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/img_no_data.png',
                    height: imgHeight,
                    width: imgWidth,
                    color: Constants.appBlueColor,
                  ),
                  SizedBox(height: 15),
                  Text(text,
                      style: TextStyle(
                        color: Constants.appDarkBlueTextColor,
                        fontFamily: "Inter-Bold",
                        fontWeight: FontWeight.w700,
                        fontSize: getProportionalScreenWidth(18),
                      )),
                  SizedBox(height: 15),
                ],
              ),
      ),
    );
  }
}

/*customCheckBoxWithLabel(String label, bool isChecked) {
  var _isChecked = false;
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Checkbox(
          activeColor: Constants.appBlueColor,
          value: _isChecked,
          onChanged: _handleRemeberme),
      AppWidgets.textRegular(
        'Remember Me',
        color: Constants.appBlueColor,
        size: 14,
      ),
      Spacer(),
      GestureDetector(
        child: Align(
          alignment: Alignment.topRight,
          child: AppWidgets.textRegular(AppString.forgotPasswordWithMark,
              color: AppColor.darkSage, size: 14),
        ),
        onTap: () => MyNavigator(context).forgotPassword(),
      )
    ],
  );
}*/

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.capitalize())
      .join(' ');
}
