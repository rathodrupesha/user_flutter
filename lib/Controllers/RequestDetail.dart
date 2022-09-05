import 'package:flutter/material.dart';
import 'package:hamrostay/Controllers/NeedHelp.dart';
import 'package:hamrostay/Controllers/Rating.dart';
import 'package:hamrostay/Models/BaseResponseModel.dart';
import 'package:hamrostay/Models/MyRequestListModel.dart';
import 'package:hamrostay/Utils/API.dart';
import 'package:hamrostay/Utils/APICall.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';

import '../localization/localization.dart';

class RequestDetail extends StatefulWidget {
  RequestDetail(this.objMyRequestData, {Key? key}) : super(key: key);

  @override
  _RequestDetailState createState() => _RequestDetailState();
  MyRequestData objMyRequestData;
}

class _RequestDetailState extends State<RequestDetail>
    implements OnResponseCallback {
  var rating = 1.0;
  var _commentController = TextEditingController();
  var _reasonController = TextEditingController();
  var _isShowLoader = false;
  var _reasonText = "";

  @override
  void initState() {
    super.initState();

    if (widget.objMyRequestData.orderComplaints != null) {
      _commentController.text =
          widget.objMyRequestData.orderComplaints?.comment ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: Constants.appLightBackgroundColor,
        appBar: WidgetUtils().customAppBarWithSkipButton(
            context,
            "#" + widget.objMyRequestData.orderId.toString(),
            Translations.of(context).strNeedHelp,
            'assets/images/btn_back.png',
            Colors.white,
            () {
              Navigator.of(context).pop();
            },
            imgColor: Colors.white,
            onRightBtnPress: () {
              WidgetUtils().push(context, () => NeedHelp());
            }),
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
            child: Container(
              padding: EdgeInsets.only(top: 8.0),
              child: _getChildView(),
            ),
          ),
        ),
        Visibility(
          visible:  widget.objMyRequestData.status == Constants.serviceStatusPending,
          child: Positioned(
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
                      Constants.appRedColor,
                      "Inter",
                      getProportionalScreenWidth(16),
                      Colors.white,
                      () {
                        _displayTextInputDialog(context);
                      },
                      btnAttributedText: Translations.of(context).strCancelRequest,
                      strSubTextFontFamily: "Inter",
                    ),
                  ),
                )),
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

  Widget _getMealDetailView() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: SizeConfig.screenWidth,
            color: Colors.white,
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: (widget.objMyRequestData.orderItems != null)
                    ? widget.objMyRequestData.orderItems!.length
                    : 0,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: WidgetUtils().simpleTextViewWithGivenFontSize(
                          widget.objMyRequestData.orderItems![index].name
                              .toString(),
                          getProportionalScreenWidth(14),
                          Constants.appDarkBlueTextColor,
                          "Inter",
                          FontWeight.w500));
                }),
          ),
        ],
      ),
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
                  Translations.of(context).strOrderIdHash + widget.objMyRequestData.orderId.toString(),
                  getProportionalScreenWidth(12),
                  Constants.appDarkBlueTextColor,
                  "Inter",
                  FontWeight.w400,
                  txtAlign: TextAlign.left),
              WidgetUtils().sizeBoxHeight(10.0),

              Visibility(
                visible: widget.objMyRequestData.type == Constants.typeBooking,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  WidgetUtils().simpleTextViewWithGivenFontSize(
                      "${widget.objMyRequestData.premiumServices?.name.toString()} / ${widget.objMyRequestData.premiumPackageServices?.name.toString()}",
                      getProportionalScreenWidth(20),
                      Constants.appDarkBlueTextColor,
                      "Inter",
                      FontWeight.w700,
                      txtAlign: TextAlign.left),
                  WidgetUtils().sizeBoxHeight(5.0),

                  WidgetUtils().simpleTextViewWithGivenFontSize(
                      "${widget.objMyRequestData.noOfPerson.toString()} ${Translations.of(context).strPerson}",
                      getProportionalScreenWidth(14),
                      Constants.appDarkBlueTextColor,
                      "Inter",
                      FontWeight.w400,
                      txtAlign: TextAlign.left),

                ],),
              ),

              Visibility(
                  visible: widget.objMyRequestData.type != Constants.typeBooking ,
                  child: WidgetUtils().simpleTextViewWithGivenFontSize(
                  widget.objMyRequestData.name.toString(),
                  getProportionalScreenWidth(20),
                  Constants.appDarkBlueTextColor,
                  "Inter",
                  FontWeight.w700,
                  txtAlign: TextAlign.left)),

              WidgetUtils().sizeBoxHeight(5.0),

              WidgetUtils().simpleTextViewWithGivenFontSize(
                  (widget.objMyRequestData.totalAmount != null)
                      ? (widget.objMyRequestData.amountUnit ?? widget.objMyRequestData.orderItems![0].unit!) +
                          widget.objMyRequestData.totalAmount.toString()
                      : "",
                  getProportionalScreenWidth(16),
                  Constants.appDarkBlueTextColor,
                  "Inter",
                  FontWeight.w400,
                  txtAlign: TextAlign.left),

              Visibility(
                child: WidgetUtils().sizeBoxHeight(15.0),
                visible: widget.objMyRequestData.orderItems != null,
              ),

              Visibility(
                  child: WidgetUtils().simpleTextViewWithGivenFontSize(
                      Translations.of(context).strItems,
                      getProportionalScreenWidth(12),
                      Constants.appLightBlueTextColor,
                      "Inter",
                      FontWeight.w400,
                      txtAlign: TextAlign.left),
                  visible: widget.objMyRequestData.orderItems != null),
              Visibility(
                  child: WidgetUtils().sizeBoxHeight(5),
                  visible: widget.objMyRequestData.orderItems != null),
              Visibility(
                  child: WidgetUtils().simpleTextViewWithGivenFontSize(
                      widget.objMyRequestData.orderItemString,
                      getProportionalScreenWidth(13),
                      Constants.appDarkBlueTextColor,
                      "Inter",
                      FontWeight.w600,
                      txtAlign: TextAlign.left),
                  visible: widget.objMyRequestData.orderItems != null),

              //Visibility(child: _getMealDetailView(),visible: widget.objMyRequestData.orderItems != null,),
              WidgetUtils().sizeBoxHeight(15.0),
              _complaintView(),
              WidgetUtils().sizeBoxHeight(15.0),
            ],
          ),
        ),
        Visibility(
          visible: widget.objMyRequestData.orderComplaints != null &&  widget.objMyRequestData.orderComplaints?.comment!= null && widget.objMyRequestData.orderComplaints!.comment!.isNotEmpty,
          child: Container(
            height: 8.0,
            color: Constants.appBackgroundColor,
          ),
        ),
        Visibility(
          visible: widget.objMyRequestData.orderComplaints != null &&  widget.objMyRequestData.orderComplaints?.comment!= null && widget.objMyRequestData.orderComplaints!.comment!.isNotEmpty,
          child: Container(
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

                WidgetUtils().simpleTextViewWithGivenFontSize(
                    widget.objMyRequestData.orderComplaints?.comment ?? "",
                    getProportionalScreenWidth(15),
                    Constants.appDarkBlueTextColor,
                    "Inter",
                    FontWeight.w500,
                    txtAlign: TextAlign.left),

                WidgetUtils().sizeBoxHeight(15)
              ],
            ),
          ),
        ),

        (widget.objMyRequestData.cancelOrders == null && widget.objMyRequestData.cancelBookings ==null && widget.objMyRequestData.cancelRequests ==null) ?Container() :Container(
          height: 8.0,
          color: Constants.appBackgroundColor,
        ),

        (widget.objMyRequestData.cancelOrders == null && widget.objMyRequestData.cancelBookings ==null && widget.objMyRequestData.cancelRequests ==null) ?
            Container() :_viewCancellationDetails() ,

        Container(
          height: 8.0,
          color: Constants.appBackgroundColor,
        ),
        Visibility(
          visible: widget.objMyRequestData.status == Constants.serviceStatusCompleted || widget.objMyRequestData.status == Constants.serviceStatusRejected,
          child: GestureDetector(
            onTap: () {
              WidgetUtils().push(
                  context,
                  () => Rating(widget.objMyRequestData.id.toString(),
                      widget.objMyRequestData.type.toString()));
            },
            child: Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 25.0),
              width: SizeConfig.screenWidth,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 1,
                          child: WidgetUtils().simpleTextViewWithGivenFontSize(
                              Translations.of(context).strTellUsAboutYourExperience,
                              getProportionalScreenWidth(17),
                              Constants.appDarkBlueTextColor,
                              "Inter",
                              FontWeight.w600,
                              txtAlign: TextAlign.left)),
                      Expanded(
                          flex: 0,
                          child: Image.asset(
                            'assets/images/btn_right_arrow.png',
                            height: 18,
                            width: 18,
                          ))
                    ],
                  ),
                  WidgetUtils().sizeBoxHeight(25)
                ],
              ),
            ),
          ),
        ),
        //WidgetUtils().sizeBoxHeight(SizeConfig.screenHeight * 0.135),
      ],
    );
  }

  Widget _complaintView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
              color: widget.objMyRequestData.currentStatusColor,
              borderRadius: BorderRadius.all(Radius.circular(4))),
        ),
        WidgetUtils().sizeBoxWidth(5),
        WidgetUtils().simpleTextViewWithGivenFontSize(
            widget.objMyRequestData.currentStatus.toString(),
            getProportionalScreenWidth(12),
            widget.objMyRequestData.currentStatusColor,
            "Inter",
            FontWeight.w600,
            txtAlign: TextAlign.left),
        WidgetUtils().sizeBoxWidth(15),
        Visibility(
            visible: widget.objMyRequestData.orderComplaints != null,
            child: Container(
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                  color: widget.objMyRequestData.orderComplaints?.getComplaintColor,
                  borderRadius: BorderRadius.all(Radius.circular(4))),
            )),
        WidgetUtils().sizeBoxWidth(5),
        Visibility(
            visible: widget.objMyRequestData.orderComplaints != null,
            child: WidgetUtils().simpleTextViewWithGivenFontSize(
                (widget.objMyRequestData.orderComplaints != null)
                    ? widget
                        .objMyRequestData.orderComplaints!.getComplaintStatus
                        .toString()
                    : "",
                getProportionalScreenWidth(12),
                widget.objMyRequestData.orderComplaints?.getComplaintColor ?? Constants.appStatusPurpleColor,
                "Inter",
                FontWeight.w600,
                txtAlign: TextAlign.left))
      ],
    );
  }

  Widget _viewCancellationDetails() {
    return Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        width: SizeConfig.screenWidth,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              WidgetUtils().simpleTextViewWithGivenFontSize(
                  Translations.of(context).strCancellation,
                  getProportionalScreenWidth(18),
                  Constants.appDarkBlueTextColor,
                  "Inter",
                  FontWeight.w700),
              WidgetUtils().sizeBoxHeight(15),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 1,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      var id = (widget.objMyRequestData.type == Constants.typeOrder)
                          ? widget.objMyRequestData.cancelOrders!.id
                          : (widget.objMyRequestData.type == Constants.typeRequest)
                          ? widget.objMyRequestData.cancelRequests!.id
                          : widget.objMyRequestData.cancelBookings!.id;
                      var comment = (widget.objMyRequestData.type == Constants.typeOrder)
                          ? widget.objMyRequestData.cancelOrders!.reason
                          : (widget.objMyRequestData.type == Constants.typeRequest)
                          ? widget.objMyRequestData.cancelRequests!.reason
                          : widget.objMyRequestData.cancelBookings!.reason;
                      var orderId = (widget.objMyRequestData.type == Constants.typeOrder)
                          ? widget.objMyRequestData.orderId
                          : (widget.objMyRequestData.type == Constants.typeRequest)
                          ? widget.objMyRequestData.orderId
                          : widget.objMyRequestData.orderId;
                      var status = (widget.objMyRequestData.type == Constants.typeOrder)
                          ? widget.objMyRequestData.cancelOrders!.status
                          : (widget.objMyRequestData.type == Constants.typeRequest)
                          ? widget.objMyRequestData.cancelRequests!.status
                          : widget.objMyRequestData.cancelBookings!.status;

                      /*var result = await Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return CancellationDetail(
                                Rows(
                                    id: id,
                                    comment: comment,
                                    orderId: orderId,
                                    status: status),
                                widget.type);
                          }));*/
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 8,
                                    width: 8,
                                    decoration: BoxDecoration(
                                        color:
                                        (widget.objMyRequestData.type == Constants.typeOrder)
                                            ? widget.objMyRequestData.cancelOrders!
                                            .currentStatusColor
                                            : (widget.objMyRequestData.type ==
                                            Constants.typeRequest)
                                            ? widget.objMyRequestData
                                            .cancelRequests!
                                            .currentStatusColor
                                            : widget.objMyRequestData
                                            .cancelBookings!
                                            .currentStatusColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                  ),
                                  WidgetUtils().sizeBoxWidth(5),
                                  WidgetUtils().simpleTextViewWithGivenFontSize(
                                      (widget.objMyRequestData.type == Constants.typeOrder)
                                          ? widget.objMyRequestData
                                          .cancelOrders!.currentStatus
                                          : (widget.objMyRequestData.type ==
                                          Constants.typeRequest)
                                          ? widget.objMyRequestData
                                          .cancelRequests!.currentStatus
                                          : widget.objMyRequestData
                                          .cancelBookings!
                                          .currentStatus,
                                      getProportionalScreenWidth(12),
                                      (widget.objMyRequestData.type == Constants.typeOrder)
                                          ? widget.objMyRequestData
                                          .cancelOrders!.currentStatusColor
                                          : (widget.objMyRequestData.type ==
                                          Constants.typeRequest)
                                          ? widget.objMyRequestData
                                          .cancelRequests!
                                          .currentStatusColor
                                          : widget.objMyRequestData
                                          .cancelBookings!
                                          .currentStatusColor,
                                      "Inter",
                                      FontWeight.w600,
                                      txtAlign: TextAlign.left)
                                ],
                              ),
                              WidgetUtils().sizeBoxHeight(5),
                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  (widget.objMyRequestData.type == Constants.typeOrder)
                                      ? widget.objMyRequestData.cancelOrders!.reason ??
                                      ""
                                      : (widget.objMyRequestData.type == Constants.typeRequest)
                                      ? widget.objMyRequestData
                                      .cancelRequests!.reason ??
                                      ""
                                      : widget.objMyRequestData
                                      .cancelBookings!.reason ??
                                      "",
                                  getProportionalScreenWidth(16),
                                  Constants.appDarkBlueTextColor,
                                  "Inter",
                                  FontWeight.w700,
                                  txtAlign: TextAlign.left)
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 15,
                  );
                },
              )
            ]));
  }

  Future<void> wsCancelBooking() async {
    setState(() {
      _isShowLoader = true;
    });

    var map = Map();
    map["booking_id"] = widget.objMyRequestData.id.toString();
    map["reason"] = _reasonController.text.toString();

    APICall(context).bookingCancelApi(map, this);
  }

  Future<void> wsCancelRequest() async {
    setState(() {
      _isShowLoader = true;
    });

    var map = Map();
    map["request_id"] = widget.objMyRequestData.id.toString();
    map["reason"] = _reasonController.text.toString();

    APICall(context).requestCancelApi(map, this);
  }

  Future<void> wsCancelOrder() async {
    setState(() {
      _isShowLoader = true;
    });

    var map = Map();
    map["order_id"] = widget.objMyRequestData.id.toString();
    map["reason"] = _reasonController.text.toString();

    APICall(context).orderCancelApi(map, this);
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
    if (requestCode == API.requestBookingCancel && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var bookingReviewResponse = BaseResponseModel.fromJson(response);

      if (bookingReviewResponse.code! == 200) {
        WidgetUtils().customToastMsg(bookingReviewResponse.msg!);
        Navigator.of(context).pop();
      } else {
        WidgetUtils().customToastMsg(bookingReviewResponse.msg!);
      }
    } else if (requestCode == API.requestOrderCancel && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var bookingReviewResponse = BaseResponseModel.fromJson(response);

      if (bookingReviewResponse.code! == 200) {
        WidgetUtils().customToastMsg(bookingReviewResponse.msg!);
        Navigator.of(context).pop();
      } else {
        WidgetUtils().customToastMsg(bookingReviewResponse.msg!);
      }
    } else if (requestCode == API.requestRequestCancel && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var bookingReviewResponse = BaseResponseModel.fromJson(response);

      if (bookingReviewResponse.code! == 200) {
        WidgetUtils().customToastMsg(bookingReviewResponse.msg!);
        Navigator.of(context).pop();
      } else {
        WidgetUtils().customToastMsg(bookingReviewResponse.msg!);
      }
    }
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(Translations.of(context).strCancelRequest),
            content: TextField(
              maxLines: 4,
              onChanged: (value) {
                setState(() {
                  _reasonText = value;
                });
              },
              controller: _reasonController,
              decoration: InputDecoration(hintText: Translations.of(context).strEnterReason),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.grey,
                textColor: Colors.white,
                child: Text(Translations.of(context).btnCancel),
                onPressed: () {
                  setState(() {
                    _reasonController.text = "";
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text(Translations.of(context).btnSubmitSmall),
                onPressed: () {
                  setState(() {
                    if (_reasonController.text.isEmpty) {
                      WidgetUtils()
                          .customToastMsg(Translations.of(context).strPleaseEnterCancellationReason);
                      return;
                    }

                    if (widget.objMyRequestData.type == Constants.typeBooking) {
                      wsCancelBooking();
                    } else if (widget.objMyRequestData.type ==
                        Constants.typeOrder) {
                      wsCancelOrder();
                    } else {
                      wsCancelRequest();
                    }
                  });
                },
              ),
            ],
          );
        });
  }
}
