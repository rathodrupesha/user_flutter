import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hamrostay/Models/HotelModel.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';

import '../Models/AddToCartRequestModel.dart';
import '../Models/AddToCartResponseModel.dart';
import '../Models/BaseResponseModel.dart';
import '../Models/MealDetailResponseModel.dart';
import '../Models/UserModel.dart';
import '../Utils/API.dart';
import '../Utils/APICall.dart';
import '../Utils/app_date_format.dart';
import '../Utils/date_utils.dart';
import '../localization/localization.dart';
import 'OrderSummary.dart';

class MealDetails extends StatefulWidget {
  final int mealId;

  MealDetails({Key? key, required this.mealId})
      : super(key: key);

  @override
  _MealDetailsState createState() => _MealDetailsState();
}

class _MealDetailsState extends State<MealDetails> implements OnResponseCallback {

  var _isShowLoader = false;
  var userModel = UserData();
  bool isMinusQuantity = false;

  MealData? objMealData;
  @override
  void initState() {
    super.initState();
    wsGetMealDetailApi();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        appBar: WidgetUtils().customAppBar(
            context,
            Translations.of(context).strMealDetail,
            'assets/images/btn_back.png',
            Colors.white,
            () {
              Navigator.of(context).pop();
            },
            imgColor: Colors.white,
            onRightBtnPress: () {
              print('Notification image clicked');
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
        (objMealData != null) ? SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  (objMealData?.image ==
                      null)
                      ? Image.asset("assets/images/img_placeholder_logo.png",
                      width: ((SizeConfig.screenWidth - 60) / 0.5),
                      height: ((SizeConfig.screenWidth - 60) * 0.4),
                      fit: BoxFit.cover)
                      : FadeInImage.assetNetwork(
                    placeholder: "assets/images/img_placeholder_logo.png",
                    image: objMealData!.image.toString(),
                    fit: BoxFit.contain,
                    width: ((SizeConfig.screenWidth - 60) / 0.5),
                    height: ((SizeConfig.screenWidth - 60) * 0.5),
                  ),
                  WidgetUtils().sizeBoxHeight(18),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            WidgetUtils().simpleTextViewWithGivenFontSize(
                                '${objMealData?.name}',
                                getProportionalScreenWidth(16),
                                Constants.appDarkBlueTextColor,
                                "Inter",
                                FontWeight.w700,
                                maxLine: 1,
                                txtAlign: TextAlign.left),

                            WidgetUtils().sizeBoxHeight(10),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: WidgetUtils().simpleTextViewWithGivenFontSize(
                                      objMealData!.unit! + objMealData!.price!,
                                      getProportionalScreenWidth(18),
                                      Constants.appCobaltBlueTextColor,
                                      "Inter",
                                      FontWeight.w700,
                                      txtAlign: TextAlign.left),
                                ),
                                Container(
                                  height: getProportionalScreenHeight(34),
                                  width: getProportionalScreenWidth(84),
                                  padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        new Radius.circular(
                                            SizeConfig.screenWidth * 0.1 / 5.8)),
                                    border: Border.all(
                                      color: Constants.appAquaTextColor,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Visibility(
                                          visible: (objMealData!.count != 0),
                                          child: Expanded(
                                            child: IconButton(
                                              iconSize: 22,
                                              highlightColor: Colors.transparent,
                                              splashColor: Colors.transparent,
                                              color: Constants.appAquaTextColor,
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.all(0),
                                              icon: Icon(Icons.remove),
                                              onPressed: () {
                                                setState(() {
                                                  isMinusQuantity = true;
                                                  wsAddToCart(-1);
                                                });
                                              },
                                            ),
                                          )),
                                      Expanded(
                                        child: Container(
                                          color: (objMealData!.count ==
                                              0)
                                              ? Colors.white
                                              : Constants.appAquaTextColor
                                              .withOpacity(0.3),
                                          height: SizeConfig.screenWidth * 0.1,
                                          child: Center(
                                            child: WidgetUtils()
                                                .simpleTextViewWithGivenFontSize(
                                                (objMealData!.count ==
                                                    0)
                                                    ? Translations.of(context).btnAdd
                                                    : objMealData!.count
                                                    .toString(),
                                                getProportionalScreenWidth(13),
                                                (objMealData!.count ==
                                                    0)
                                                    ? Constants.appAquaTextColor
                                                    : Constants
                                                    .appDarkBlueTextColor,
                                                "Inter",
                                                FontWeight.w500,
                                                txtAlign: TextAlign.center),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: IconButton(
                                          iconSize: 22,
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          color: Constants.appAquaTextColor,
                                          alignment: Alignment.centerRight,
                                          padding: EdgeInsets.all(0),
                                          icon: Icon(Icons.add),
                                          onPressed: () {
                                            setState(() {
                                              isMinusQuantity = false;
                                              wsAddToCart(1);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            WidgetUtils().sizeBoxHeight(20),

                            WidgetUtils().simpleTextViewWithGivenFontSize(
                                Translations.of(context).strEstimatedTime,
                                getProportionalScreenWidth(12),
                                Constants.appLightBlueTextColor,
                                "Inter",
                                FontWeight.w400,
                                txtAlign: TextAlign.left),
                            WidgetUtils().sizeBoxHeight(5),
                            WidgetUtils().simpleTextViewWithGivenFontSize(
                                objMealData!.preparationTime.toString() +
                                    " " +
                                    objMealData!.preparationUnit.toString(),
                                getProportionalScreenWidth(13),
                                Constants.appDarkBlueTextColor,
                                "Inter",
                                FontWeight.w600,
                                txtAlign: TextAlign.left),

                            WidgetUtils().sizeBoxHeight(20),
                            WidgetUtils().simpleTextViewWithGivenFontSize(
                                '${objMealData?.description}',
                                getProportionalScreenWidth(14),
                                Constants.appDarkBlueTextColor,
                                "Inter",
                                FontWeight.w400,
                                txtAlign: TextAlign.left,
                                txtOverflow: TextOverflow.ellipsis),
                            WidgetUtils().sizeBoxHeight(14),
                            // WidgetUtils().simpleTextViewWithGivenFontSize(
                            //     '\$${_objInRoomSpecialsModel[indexOfSpecialMeal].meals![index].price}',
                            //     getProportionalScreenWidth(18),
                            //     Constants.appCobaltBlueTextColor,
                            //     "Inter",
                            //     FontWeight.w700,
                            //     txtAlign: TextAlign.left)
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ): WidgetUtils().noDataFoundText(
            _isShowLoader, Translations.of(context).strNoDataFound, 150, 150),

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
                      WidgetUtils().push(context, () => OrderSummary());
                    },
                    btnAttributedText: Translations.of(context).strViewCheckout,
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



  Future<void> wsGetMealDetailApi() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    setState(() {
      _isShowLoader = true;
    });

    var map = Map();

    map["meal_id"] =  widget.mealId;
    map["hotel_id"] = userModel.hotelId;

    APICall(context).getMealDetailApi(map, this);
  }

  Future<void> wsAddToCart(int count) async {
    List<Carts> carts = [];


    carts.add(Carts(mealId: widget.mealId, units: count));


    if (carts.isEmpty) {
      return;
    }

    setState(() {
      _isShowLoader = true;
    });
    var userModel = await WidgetUtils.fetchUserDetailsFromPreference();

    AddToCartRequestModel addToCartRequestModel = AddToCartRequestModel();
    addToCartRequestModel.hotelId = userModel!.hotelId;
    addToCartRequestModel.carts = carts;

    APICall(context).addToCartApi(addToCartRequestModel.toJson(), this);
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
    if (requestCode == API.requestGetMealDetail && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var mealDetailResponseModel = MealDetailResponseModel.fromJson(response);

      if (mealDetailResponseModel.code! == 200) {
        objMealData = mealDetailResponseModel.data;
      } else {
        WidgetUtils().customToastMsg(mealDetailResponseModel.msg!);
      }
    }else if (requestCode == API.requestAddToCart && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var addToCartResponseModel = AddToCartResponseModel.fromJson(response);

      // inRoomSpecialsModel.data![0].meals
      if (addToCartResponseModel.code! == 200) {
        setState(() {

            if (isMinusQuantity) {
              objMealData!.count = (objMealData!.count - 1);
            } else {
              objMealData!.count = (objMealData!.count + 1);
            }
        });
      } else {
        WidgetUtils().customToastMsg(addToCartResponseModel.msg!);
      }
    }
  }

}
