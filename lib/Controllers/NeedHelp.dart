import 'package:flutter/material.dart';
import 'package:hamrostay/Models/BaseResponseModel.dart';
import 'package:hamrostay/Models/MyRequestListModel.dart';
import 'package:hamrostay/Models/UserModel.dart';
import 'package:hamrostay/Utils/API.dart';
import 'package:hamrostay/Utils/APICall.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';

import '../localization/localization.dart';

class NeedHelp extends StatefulWidget {
  NeedHelp({Key? key}) : super(key: key);

  @override
  _NeedHelpState createState() => _NeedHelpState();
}

class _NeedHelpState extends State<NeedHelp> implements OnResponseCallback{

  var userModel = UserData();
  var _isShowLoader = false;
  var _isSubmitShowLoader = false;
  List<MyRequestData> _objMyRequestData =[];
  MyRequestData? dropdownValue;
  List<String> noServiceAvailable = [Translations.current!.strPleaseSelectService];
  var _commentController = TextEditingController();

  int? complaintId;
  String? type;
  @override
  void initState() {
    super.initState();
    wsGetAllRequestList();
  }

  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        backgroundColor: Constants.appLightBackgroundColor,
        appBar: WidgetUtils().customAppBar(
          context,
          Translations.of(context).strNeedHelp,
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
        Positioned(
          child: SingleChildScrollView(
            child: (_objMyRequestData.isEmpty)
                ? Container(
                height: SizeConfig.screenHeight * 0.75,
                child: WidgetUtils().noDataFoundText(
                    _isShowLoader, Translations.of(context).strNoDataFound, 150, 150))
                :_getChildView(),
          ),
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
                      if(complaintId == null){
                        WidgetUtils().customToastMsg(Translations.of(context).strPleaseSelectServiceSmall);
                        return;
                      }else if(_commentController.text.isEmpty){
                        WidgetUtils().customToastMsg(Translations.of(context).strPleaseEnterComplaintDetail);
                      }else{
                        if(type == Constants.typeBooking) {
                          wsBookingComplaint();
                        }else if(type == Constants.typeOrder){
                          wsOrderComplaint();
                        }else{
                          wsServiceComplaint();
                        }
                      }

                    },
                    btnAttributedText: Translations.of(context).btnSubmit,
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
            visible: _isSubmitShowLoader)
      ],
    );
  }

  Widget _getChildView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
          width: SizeConfig.screenWidth,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              WidgetUtils().simpleTextViewWithGivenFontSize(
                  Translations.of(context).strSelectOngoingService,
                  getProportionalScreenWidth(15),
                  Constants.appDarkBlueTextColor,
                  "Inter",
                  FontWeight.w600,
                  txtAlign: TextAlign.left),
              WidgetUtils().sizeBoxHeight(20.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.all(Radius.circular(
                      SizeConfig.screenHeight * 0.05 / 4)),
                  color: Color.fromRGBO(244, 245, 247, 1.0),
                ),
                height: getProportionalScreenHeight(60) ,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: DropdownButton<MyRequestData?>(
                    isExpanded: true,
                    value: dropdownValue,
                    hint: Text(Translations.of(context).strPleaseSelectService),
                    iconSize: 30,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_outlined,
                    ),
                    elevation: 16,
                    style: const TextStyle(
                        fontFamily: "Inter",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Constants.appDarkBlueTextColor),
                    underline: Container(
                      height: 0,
                      color: Colors.transparent,
                    ),
                    onChanged: (MyRequestData? newValue) {
                      setState(() {
                        dropdownValue = newValue;
                        complaintId = newValue!.id;
                        type = newValue.type;
                      });
                    },
                      onTap: (){

                      },
                    items:  _objMyRequestData.map<DropdownMenuItem<MyRequestData?>>((MyRequestData value) {

                      return DropdownMenuItem<MyRequestData?>(value: value,
                        child: Text("#"+value.orderId! + " - "+value.name!),
                      );
                    }).toList()
                  ),
                ),
              ),

              WidgetUtils().sizeBoxHeight(20.0),
            ],
          ),
        ),
        Container(
          height: 8.0,
          color: Constants.appBackgroundColor,
        ),
        Container(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 25.0),
          width: SizeConfig.screenWidth,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              WidgetUtils().simpleTextViewWithGivenFontSize(
                  Translations.of(context).strComplaintDetails,
                  getProportionalScreenWidth(14),
                  Constants.appLightBlueTextColor,
                  "Inter",
                  FontWeight.w500,
                  txtAlign: TextAlign.left),
              WidgetUtils().sizeBoxHeight(8.0),
              TextField(
                    minLines: 4,
                    maxLines: 12,
                    controller: _commentController,
                    decoration: InputDecoration(
                        hintText: Translations.of(context).strTypeYourMessage,
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
              WidgetUtils().sizeBoxHeight(25)
            ],
          ),
        ),
        WidgetUtils().sizeBoxHeight(SizeConfig.screenHeight * 0.135),
      ],
    );
  }

  Future<void> wsGetAllRequestList() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    setState(() {
      _isShowLoader = true;
    });

    var map = Map();
    map["hotel_id"] = userModel.hotelId;

    APICall(context).getAllRequestApi(map, this);
  }

  Future<void> wsServiceComplaint() async {
    setState(() {
      _isSubmitShowLoader = true;
    });

    var map = Map();
    map["request_id"] = complaintId.toString();
    map["comment"] = _commentController.text.toString();

    APICall(context).serviceComplaintApi(map, this);
  }

  Future<void> wsBookingComplaint() async {
    setState(() {
      _isSubmitShowLoader = true;
    });

    var map = Map();
    map["booking_id"] = complaintId.toString();
    map["comment"] = _commentController.text.toString();

    APICall(context).bookingComplaintApi(map, this);
  }

  Future<void> wsOrderComplaint() async {
    setState(() {
      _isSubmitShowLoader = true;
    });

    var map = Map();
    map["order_id"] = complaintId.toString();
    map["comment"] = _commentController.text.toString();

    APICall(context).orderComplaintApi(map, this);
  }

  @override
  void onResponseError(String message, int requestCode) {
    setState(() {
      _isShowLoader = false;
      _isSubmitShowLoader = false;
    });
    WidgetUtils().customToastMsg(message);
  }

  @override
  void onResponseReceived(response, int requestCode) {
    if (requestCode == API.requestGetAllRequestList && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var myRequestListResponse = MyRequestListModel.fromJson(response);

      if (myRequestListResponse.code! == 200) {
        setState(() {
          _objMyRequestData = myRequestListResponse.data!;
        });
      } else {
        WidgetUtils().customToastMsg(myRequestListResponse.msg!);
      }
    }else if (requestCode == API.requestServiceComplaint && this.mounted) {
      setState(() {
        _isSubmitShowLoader = false;
      });

      var myRequestListResponse = BaseResponseModel.fromJson(response);

      if (myRequestListResponse.code! == 200) {
        setState(() {
          WidgetUtils().customToastMsg(myRequestListResponse.msg!);
          Navigator.of(context).pop();
        });
      } else {
        WidgetUtils().customToastMsg(myRequestListResponse.msg!);
      }
    }else if (requestCode == API.requestBookingComplaint && this.mounted) {
      setState(() {
        _isSubmitShowLoader = false;
      });

      var myRequestListResponse = BaseResponseModel.fromJson(response);

      if (myRequestListResponse.code! == 200) {
        setState(() {
          WidgetUtils().customToastMsg(myRequestListResponse.msg!);
          Navigator.of(context).pop();
        });
      } else {
        WidgetUtils().customToastMsg(myRequestListResponse.msg!);
      }
    }else if (requestCode == API.requestOrderComplaint && this.mounted) {
      setState(() {
        _isSubmitShowLoader = false;
      });

      var myRequestListResponse = BaseResponseModel.fromJson(response);

      if (myRequestListResponse.code! == 200) {
        setState(() {
          WidgetUtils().customToastMsg(myRequestListResponse.msg!);
          Navigator.of(context).pop();
        });
      } else {
        WidgetUtils().customToastMsg(myRequestListResponse.msg!);
      }
    }
  }
}
