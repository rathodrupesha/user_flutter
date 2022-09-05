import 'package:flutter/material.dart';
import 'package:hamrostay/Controllers/RequestSucessPopup.dart';
import 'package:hamrostay/Models/BaseResponseModel.dart';
import 'package:hamrostay/Models/MainServicesModel.dart';
import 'package:hamrostay/Models/SubServicesModel.dart';
import 'package:hamrostay/Utils/API.dart';
import 'package:hamrostay/Utils/APICall.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/Validations.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';
import 'package:hamrostay/localization/localization.dart';

class ServicesDetail extends StatefulWidget {
  final MainServicesRows objMainServicesRowModel;
  final SubServicesRows objSubServicesRowModel;

  ServicesDetail(
      {Key? key,
      required this.objMainServicesRowModel,
      required this.objSubServicesRowModel})
      : super(key: key);

  @override
  _ServicesDetailState createState() => _ServicesDetailState();
}

class _ServicesDetailState extends State<ServicesDetail>
    implements OnResponseCallback {
  var _isShowLoader = false;
  var _commentsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        appBar: WidgetUtils().customAppBar(
            context, widget.objSubServicesRowModel.name ?? "", 'assets/images/btn_back.png', Colors.white,
            () {
          Navigator.of(context).pop();
        }, imgColor: Colors.white),
        body: Material(
          child: SafeArea(
            top: false,
            bottom: false,
            left: false,
            child: _getBodyView(context),
          ),
        ));
  }

  Widget _getBodyView(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Visibility(child: WidgetUtils().simpleTextViewWithGivenFontSize(
                    Translations.of(context).strDescription,
                    getProportionalScreenWidth(14),
                    Constants.appLightBlueTextColor,
                    "Inter",
                    FontWeight.w700),visible:widget.objSubServicesRowModel.description != null),

                WidgetUtils().sizeBoxHeight(8),

                    Visibility(child:WidgetUtils().simpleTextViewWithGivenFontSize(
                    widget.objSubServicesRowModel.description ?? "",
                    getProportionalScreenWidth(14),
                    Constants.appDarkBlueTextColor,
                    "Inter",
                    FontWeight.w400),visible:widget.objSubServicesRowModel.description != null),

                Visibility(child: WidgetUtils().sizeBoxHeight(30),visible:widget.objSubServicesRowModel.description != null),

                WidgetUtils().simpleTextViewWithGivenFontSize(
                    Translations.of(context).strAdditionalDetails,
                    getProportionalScreenWidth(14),
                    Constants.appLightBlueTextColor,
                    "Inter",
                    FontWeight.w500),
                WidgetUtils().sizeBoxHeight(8),
                TextField(
                    minLines: 4,
                    maxLines: 12,
                    controller: _commentsController,
                    style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: getProportionalScreenWidth(16),
                        color: Constants.appDarkBlueTextColor,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                        // hintText: 'Type your message',
                        hintStyle:
                            TextStyle(color: Constants.appDarkBlueTextColor),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Constants.appGrayBottomLineColor
                                  .withOpacity(0.3)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Constants.appGrayBottomLineColor
                                    .withOpacity(0.3))))),
              ],
            ),
          )),
        ),
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
                      wsSubServiceBooking();
                    },
                    btnAttributedText: Translations.of(context).strSendRequest,
                    strSubTextFontFamily: "Inter",
                  ),
                ),
              )),
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

  Future<void> wsSubServiceBooking() async {

    if (Validations(context)
        .bookingServiceValidations(_commentsController.text)) {
      var userModel = await WidgetUtils.fetchUserDetailsFromPreference();

      setState(() {
        _isShowLoader = true;
      });

      var map = Map();
      map["hotel_id"] = userModel!.hotelId;
      map["main_service_id"] = widget.objMainServicesRowModel.id;
      map["sub_service_id"] = widget.objSubServicesRowModel.id;
      map["requested_text"] = _commentsController.text;

      APICall(context).bookingService(map, this);
    }
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
    if (requestCode == API.requestServiceBooking && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var serviceBookingResponse = BaseResponseModel.fromJson(response);


      if (serviceBookingResponse.code! == 200) {
        showDialog(
            context: context,
            builder: (context) => RequestSucessPopup(),
            useSafeArea: false);
      } else {
        WidgetUtils().customToastMsg(serviceBookingResponse.msg!);
      }

    }
  }
}
