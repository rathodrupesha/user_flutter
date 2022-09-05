import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hamrostay/Models/BaseResponseModel.dart';
import 'package:hamrostay/Utils/API.dart';
import 'package:hamrostay/Utils/APICall.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';

import '../localization/localization.dart';

class Rating extends StatefulWidget {
  Rating(this.bookingId, this.type,{Key? key}) : super(key: key);

  @override
  _RatingState createState() => _RatingState();
  String bookingId;
  String type;
}

class _RatingState extends State<Rating>  implements OnResponseCallback{
  var rating = 1.0;
  var _commentController = TextEditingController();
  var _isShowLoader = false;
  var commentCount = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        appBar: WidgetUtils().customAppBarWithSkipButton(
            context,
            Translations.of(context).strShareYourExperience, Translations.of(context).btnSkip,
            'assets/images/btn_back.png',
            Colors.white,
            () {
              Navigator.of(context).pop();
            },
            imgColor: Colors.white,
            onRightBtnPress: () {
              Navigator.of(context).pop();
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
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 25.0, left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  WidgetUtils().simpleTextViewWithGivenFontSize(
                      Translations.of(context).strTellUsAboutYourExperience,
                      getProportionalScreenWidth(17),
                      Constants.appDarkBlueTextColor,
                      "Inter",
                      FontWeight.w600,
                      txtAlign: TextAlign.left),
                  WidgetUtils().sizeBoxHeight(18),
                  RatingBar(
                    initialRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    ratingWidget: RatingWidget(
                      full: Image.asset(
                        'assets/images/img_rating_fill.png',
                      ),
                      half: Image.asset(
                        'assets/images/img_rating_unfill.png',
                      ),
                      empty: Image.asset(
                        'assets/images/img_rating_unfill.png',
                      ),
                    ),
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    onRatingUpdate: (rating) {
                      print(rating);
                      this.rating = rating;
                    },
                  ),
                  WidgetUtils().sizeBoxHeight(30),
                  WidgetUtils().simpleTextViewWithGivenFontSize(
                      Translations.of(context).strComments,
                      getProportionalScreenWidth(16),
                      Constants.appDarkBlueTextColor,
                      "Inter",
                      FontWeight.w600,
                      txtAlign: TextAlign.left),
                  WidgetUtils().sizeBoxHeight(15),
                  TextField(
                      minLines: 4,
                      maxLines: 4,
                      maxLength: 150,
                      controller: _commentController,
                      style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: getProportionalScreenWidth(16),
                          color: Constants.appDarkBlueTextColor,
                          fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Constants.appTagBackgroundColor,
                          hintText: Translations.of(context).strStartWritingHere,
                          hintStyle:
                              TextStyle(color: Constants.appDarkBlueTextColor),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                                color: Constants.appGrayBottomLineColor
                                    .withOpacity(0.08)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                                color: Constants.appGrayBottomLineColor
                                    .withOpacity(0.08)),
                          ))),

                 /* WidgetUtils().sizeBoxHeight(5),
                  WidgetUtils().simpleTextViewWithGivenFontSize(
                      _commentController.text.length.toString() + "/" + "150" + " " + "Characters",
                      getProportionalScreenWidth(16),
                      Constants.appDarkBlueTextColor,
                      "Inter",
                      FontWeight.w600,
                      txtAlign: TextAlign.left),*/


                ],
              ),
            ),
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
                      if(widget.type == Constants.typeBooking) {
                        wsBookingReview();
                      }else if(widget.type == Constants.typeOrder){
                        wsOrderReview();
                      }else{
                        wsServiceReview();
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
            visible: _isShowLoader)
      ],
    );
  }

  Future<void> wsBookingReview() async {

    if(_commentController.text.toString().isEmpty){
      WidgetUtils().customToastMsg(Translations.of(context).strPleaseWriteYourReview);
      return;
    }
    setState(() {
      _isShowLoader = true;
    });

    var map = Map();
    map["booking_id"] = widget.bookingId;
    map["star"] = rating;
    map["comment"] = _commentController.text.toString();

    APICall(context).bookingReviewApi(map, this);
  }

  Future<void> wsServiceReview() async {

    if(_commentController.text.toString().isEmpty){
      WidgetUtils().customToastMsg(Translations.of(context).strPleaseWriteYourReview);
      return;
    }
    setState(() {
      _isShowLoader = true;
    });

    var map = Map();
    map["request_id"] = widget.bookingId;
    map["star"] = rating;
    map["comment"] = _commentController.text.toString();

    APICall(context).serviceReviewApi(map, this);
  }

  Future<void> wsOrderReview() async {

    if(_commentController.text.toString().isEmpty){
      WidgetUtils().customToastMsg(Translations.of(context).strPleaseWriteYourReview);
      return;
    }
    setState(() {
      _isShowLoader = true;
    });

    var map = Map();
    map["order_id"] = widget.bookingId;
    map["star"] = rating;
    map["comment"] = _commentController.text.toString();

    APICall(context).orderReviewApi(map, this);
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
    if (requestCode == API.requestBookingReview && this.mounted) {
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
    }else if (requestCode == API.requestOrderReview && this.mounted) {
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
    }else if (requestCode == API.requestServiceReview && this.mounted) {
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
}
