import 'package:flutter/material.dart';
import 'package:hamrostay/Controllers/Dashboard.dart';
import 'package:hamrostay/Models/PlaceOrderResponseModel.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';

import '../localization/localization.dart';

class OrderSummaryPopup extends StatefulWidget {
  OrderSummaryPopup(this.placeOrderData, {Key? key}) : super(key: key);

  PlaceOrderData placeOrderData;
  @override
  _OrderSummaryPopupState createState() => _OrderSummaryPopupState();
}

class _OrderSummaryPopupState extends State<OrderSummaryPopup> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight * 0.4,
            color: Colors.transparent,
          ),
        ),
        Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight * 0.6,
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
                      Center(
                        child: WidgetUtils().simpleTextViewWithGivenFontSize(
                            Translations.of(context).strYourOrderHasBeenSentToOurChef,
                            getProportionalScreenWidth(14),
                            Constants.appDarkBlueTextColor,
                            "Inter",
                            FontWeight.w400,
                            txtAlign: TextAlign.center),
                      ),
                      WidgetUtils().sizeBoxHeight(20),
                      Container(
                          padding: EdgeInsets.only(
                              top: 22.0, bottom: 22.0, left: 10.0, right: 10.0),
                          width: SizeConfig.screenWidth * 0.7,
                          decoration: BoxDecoration(
                            borderRadius:
                                new BorderRadius.all(Radius.circular(8.0)),
                            color: Constants.appLightGreenColor,
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: Translations.of(context).strOrderIDSpace,
                                          style: TextStyle(
                                            fontFamily: "Inter",
                                            fontWeight: FontWeight.w400,
                                            fontSize:
                                                getProportionalScreenWidth(16),
                                            color:
                                                Constants.appDarkBlueTextColor,
                                          )),
                                      TextSpan(
                                          text: '#'+widget.placeOrderData.orderId.toString(),
                                          style: TextStyle(
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w700,
                                              color: Constants
                                                  .appDarkBlueTextColor,
                                              fontSize:
                                                  getProportionalScreenWidth(
                                                      16))),
                                    ],
                                  ),
                                ),
                                WidgetUtils().sizeBoxHeight(8),
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: Translations.of(context).strExpectedTime,
                                          style: TextStyle(
                                            fontFamily: "Inter",
                                            fontWeight: FontWeight.w400,
                                            fontSize:
                                                getProportionalScreenWidth(16),
                                            color:
                                                Constants.appDarkBlueTextColor,
                                          )),
                                      TextSpan(
                                          text: widget.placeOrderData.expectedTime.toString() + " " + widget.placeOrderData.expectedUnit.toString(),
                                          style: TextStyle(
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w700,
                                              color: Constants
                                                  .appDarkBlueTextColor,
                                              fontSize:
                                                  getProportionalScreenWidth(
                                                      16))),
                                    ],
                                  ),
                                ),
                                WidgetUtils().sizeBoxHeight(8),
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: Translations.of(context).strRoomNo,
                                          style: TextStyle(
                                            fontFamily: "Inter",
                                            fontWeight: FontWeight.w400,
                                            fontSize:
                                                getProportionalScreenWidth(16),
                                            color:
                                                Constants.appDarkBlueTextColor,
                                          )),
                                      TextSpan(
                                          text: widget.placeOrderData.roomNumber.toString(),
                                          style: TextStyle(
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w700,
                                              color: Constants
                                                  .appDarkBlueTextColor,
                                              fontSize:
                                                  getProportionalScreenWidth(
                                                      16))),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )),
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
