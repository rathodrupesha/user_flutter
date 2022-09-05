import 'package:flutter/material.dart';
import 'package:hamrostay/Controllers/Dashboard.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';
import 'package:hamrostay/localization/localization.dart';

class RequestSucessPopup extends StatefulWidget {
  const RequestSucessPopup({Key? key}) : super(key: key);

  @override
  _RequestSucessPopupState createState() => _RequestSucessPopupState();
}

class _RequestSucessPopupState extends State<RequestSucessPopup> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight * 0.55,
            color: Colors.transparent,
          ),
        ),
        Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight * 0.45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight:
                      Radius.circular((SizeConfig.screenHeight * 0.45 / 10)),
                  topLeft:
                      Radius.circular((SizeConfig.screenHeight * 0.45 / 10))),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                    right: 0,
                    child: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/img_success.png',
                        width: SizeConfig.screenHeight * 0.12,
                        height: SizeConfig.screenHeight * 0.12,
                        fit: BoxFit.fill,
                      ),
                      WidgetUtils().sizeBoxHeight(22),
                      WidgetUtils().simpleTextViewWithGivenFontSize(
                          Translations.of(context).strYourRequestHasBeenSent,
                          getProportionalScreenWidth(18),
                          Constants.appDarkBlueTextColor,
                          "Inter",
                          FontWeight.w700,
                          txtAlign: TextAlign.center),
                      WidgetUtils().sizeBoxHeight(10),
                      WidgetUtils().simpleTextViewWithGivenFontSize(
                          Translations.of(context).strYouWillHearFromOurRepresentativeShortly,
                          getProportionalScreenWidth(14),
                          Constants.appDarkBlueTextColor,
                          "Inter",
                          FontWeight.w400,
                          txtAlign: TextAlign.center)
                    ],
                  ),
                )),
                Positioned(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
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
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => Dashboard()),
                                  (Route<dynamic> route) => false);
                            },
                            btnAttributedText: Translations.of(context).strGoToHome,
                            strSubTextFontFamily: "Inter",
                          ),
                        ),
                      )),
                )
              ],
            ))
      ],
    );
  }
}
