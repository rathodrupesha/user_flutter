import 'package:flutter/material.dart';
import 'package:hamrostay/Controllers/OrderSummaryPopup.dart';
import 'package:hamrostay/Models/AddToCartRequestModel.dart';
import 'package:hamrostay/Models/AddToCartResponseModel.dart';
import 'package:hamrostay/Models/GetCartDetailResponseModel.dart';
import 'package:hamrostay/Models/PlaceOrderResponseModel.dart';
import 'package:hamrostay/Models/UserModel.dart';
import 'package:hamrostay/Utils/API.dart';
import 'package:hamrostay/Utils/APICall.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';

import '../localization/localization.dart';

class OrderSummary extends StatefulWidget {
  OrderSummary({Key? key}) : super(key: key);

  @override
  _OrderSummaryState createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> implements OnResponseCallback {

  var userModel = UserData();
  var _isShowLoader = false;
  CartDetail _objCartDetailModel = CartDetail();
  PlaceOrderData _objPlaceOrderDataModel = PlaceOrderData();
  var _commentsController = TextEditingController();

  int cartIndex = 0;
  bool isMinusQuantity = false;

  @override
  void initState() {
    super.initState();
    wsGetCartDetailApi();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        backgroundColor: Constants.appLightBackgroundColor,
        appBar: WidgetUtils().customAppBar(
          context,
          Translations.of(context).strOrderSummary,
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
    return (_objCartDetailModel.cartItems == null ||
        _objCartDetailModel.cartItems!.length == 0)
        ? WidgetUtils().noDataFoundText(
        _isShowLoader, Translations.of(context).strNoDataFound, 150, 150)
        : Stack(
      children: [
        Positioned(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: 8.0),
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
                        itemCount: _objCartDetailModel.cartItems!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0, bottom: 5.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      WidgetUtils()
                                          .simpleTextViewWithGivenFontSize(
                                          _objCartDetailModel.cartItems![index].name.toString(),
                                              getProportionalScreenWidth(16),
                                              Constants.appDarkBlueTextColor,
                                              "Inter",
                                              FontWeight.w700),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: WidgetUtils()
                                                  .simpleTextViewWithGivenFontSize(
                                                  _objCartDetailModel.cartItems![index].unit! + _objCartDetailModel.cartItems![index].price.toString(),
                                                      getProportionalScreenWidth(
                                                          18),
                                                      Constants
                                                          .appCobaltBlueTextColor,
                                                      "Inter",
                                                      FontWeight.w700,
                                                      txtAlign:
                                                          TextAlign.left)),
                                          Expanded(
                                            flex: 0,
                                            child: _getQuantityView(index),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  ),

                  Container(height: 7.0,color: Constants.appLightBackgroundColor,),

                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 15, top: 25,bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          WidgetUtils().simpleTextViewWithGivenFontSize(
                              Translations.of(context).strAdditionalDetails,
                              getProportionalScreenWidth(14),
                              Constants.appLightBlueTextColor,
                              "Inter",
                              FontWeight.w500),
                          TextField(
                              minLines: 2,
                              maxLines: 4,
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
                    ),
                  ),

                  _getTotalAmountView()
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
                      wsPlaceOrderApi();

                    },
                    btnAttributedText: Translations.of(context).strPlaceOrder,
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
            visible: _isShowLoader),

      ],
    );
  }

  Widget _getQuantityView(int index) {
    return Container(
      height: SizeConfig.screenWidth * 0.085,
      width: SizeConfig.screenWidth * 0.22,
      padding: EdgeInsets.only(left: 5.0, right: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
            new Radius.circular(SizeConfig.screenWidth * 0.1 / 5.8)),
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
            visible: (_objCartDetailModel.cartItems![index].units != 0),
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
                    cartIndex =index;
                    wsAddToCart(-1);
                    //_objCartDetailModel.cartItems![index].units = (_objCartDetailModel.cartItems![index].units! - 1);
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: (_objCartDetailModel.cartItems![index].units == 0)
                  ? Colors.white
                  : Constants.appAquaTextColor.withOpacity(0.3),
              height: SizeConfig.screenWidth * 0.1,
              child: Center(
                child: WidgetUtils().simpleTextViewWithGivenFontSize(
                    (_objCartDetailModel.cartItems![index].units == 0) ? Translations.of(context).btnAdd
                        : _objCartDetailModel.cartItems![index].units.toString(),
                    getProportionalScreenWidth(13),
                    (_objCartDetailModel.cartItems![index].units == 0)
                        ? Constants.appAquaTextColor
                        : Constants.appDarkBlueTextColor,
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
                  cartIndex =index;

                  wsAddToCart(1);
                  //_objCartDetailModel.cartItems![index].units = (_objCartDetailModel.cartItems![index].units! + 1);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getTotalAmountView() {
    return Container(
        padding: EdgeInsets.only(top: 8.0),
        color: Constants.appLightBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 25.0),
              width: SizeConfig.screenWidth,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: WidgetUtils().simpleTextViewWithGivenFontSize(
                              Translations.of(context).strSubtotal,
                              getProportionalScreenWidth(16),
                              Constants.appDarkBlueTextColor,
                              "Inter",
                              FontWeight.w500,
                              txtAlign: TextAlign.left)),
                      Expanded(
                          child: WidgetUtils().simpleTextViewWithGivenFontSize(
                              _objCartDetailModel.cartItems![0].unit! +_objCartDetailModel.subTotal.toString(),
                              getProportionalScreenWidth(16),
                              Constants.appLightBlueTextColor,
                              "Inter",
                              FontWeight.w700,
                              txtAlign: TextAlign.right)),
                    ],
                  ),
                  WidgetUtils().sizeBoxHeight(20.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: WidgetUtils().simpleTextViewWithGivenFontSize(
                              Translations.of(context).strTax + '(%${_objCartDetailModel.tax})',
                              getProportionalScreenWidth(16),
                              Constants.appLightBlueTextColor,
                              "Inter",
                              FontWeight.w500,
                              txtAlign: TextAlign.left)),
                      Expanded(
                          child: WidgetUtils().simpleTextViewWithGivenFontSize(
                              '+ '+_objCartDetailModel.cartItems![0].unit!+ _objCartDetailModel.taxAmount.toString(),
                              getProportionalScreenWidth(16),
                              Constants.appLightBlueTextColor,
                              "Inter",
                              FontWeight.w500,
                              txtAlign: TextAlign.right)),
                    ],
                  ),
                  WidgetUtils().sizeBoxHeight(20.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: WidgetUtils().simpleTextViewWithGivenFontSize(
                              Translations.of(context).strDiscount,
                              getProportionalScreenWidth(16),
                              Constants.appLightBlueTextColor,
                              "Inter",
                              FontWeight.w500,
                              txtAlign: TextAlign.left)),
                      Expanded(
                          child: WidgetUtils().simpleTextViewWithGivenFontSize(
                              '- '+_objCartDetailModel.cartItems![0].unit! +_objCartDetailModel.discountAmount.toString(),
                              getProportionalScreenWidth(16),
                              Constants.appLightBlueTextColor,
                              "Inter",
                              FontWeight.w500,
                              txtAlign: TextAlign.right)),
                    ],
                  ),
                  WidgetUtils().sizeBoxHeight(20.0),
                ],
              ),
            ),
            Container(
              height: 1.0,
              color: Constants.appSepratorColor,
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: WidgetUtils().simpleTextViewWithGivenFontSize(
                              Translations.of(context).strTotalAmount,
                              getProportionalScreenWidth(16),
                              Constants.appDarkBlueTextColor,
                              "Inter",
                              FontWeight.w700,
                              txtAlign: TextAlign.left)),
                      Expanded(
                          child: WidgetUtils().simpleTextViewWithGivenFontSize(
                            _objCartDetailModel.cartItems![0].unit! +_objCartDetailModel.totalAmount.toString(),
                              getProportionalScreenWidth(16),
                              Constants.appDarkBlueTextColor,
                              "Inter",
                              FontWeight.w700,
                              txtAlign: TextAlign.right)),
                    ],
                  ),
                  WidgetUtils().sizeBoxHeight(35)
                ],
              ),
            ),
            WidgetUtils().sizeBoxHeight(SizeConfig.screenHeight * 0.135),
          ],
        ));
  }

  Future<void> wsGetCartDetailApi() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    setState(() {
      _isShowLoader = true;
    });

    var map = Map();
    map["hotel_id"] = userModel.hotelId;

    APICall(context).getCartDetailApi(map, this);
  }

  Future<void> wsPlaceOrderApi() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    setState(() {
      _isShowLoader = true;
    });

    var map = Map();
    map["cart_id"] = _objCartDetailModel.id;
    map["room_number"] = userModel.roomNo;
    map["comment"] = _commentsController.text.toString();

    APICall(context).placeOrderApi(map, this);
  }

  Future<void> wsAddToCart(int count) async {
    List<Carts> carts = [];

    carts.add(Carts(mealId: _objCartDetailModel.cartItems![cartIndex].mealId,units: count));

    if(carts.isEmpty){
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
    if (requestCode == API.requestGetCartDetail && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var getCartDetailResponse = GetCartDetailResponseModel.fromJson(response);

      // inRoomSpecialsModel.data![0].meals
      if (getCartDetailResponse.code! == 200) {
        setState(() {
          if(getCartDetailResponse.data == null) {
            _objCartDetailModel = CartDetail();
          }else{
            //_objCartDetailModel = getCartDetailResponse.data!;
            _objCartDetailModel.cartItems = [];
            var tempModel = getCartDetailResponse.data!;
            _objCartDetailModel.id = tempModel.id;
            _objCartDetailModel.subTotal = tempModel.subTotal;
            _objCartDetailModel.totalAmount = tempModel.totalAmount;
            _objCartDetailModel.discount = tempModel.discount;
            _objCartDetailModel.discountType = tempModel.discountType;
            _objCartDetailModel.discountAmount = tempModel.discountAmount;
            _objCartDetailModel.tax = tempModel.tax;
            _objCartDetailModel.taxAmount = tempModel.taxAmount;
            _objCartDetailModel.taxType = tempModel.taxType;

            for(var model in tempModel.cartItems!){
              if(model.units! > 0){
                _objCartDetailModel.cartItems!.add(model);
              }
            }
          }
        });
      } else {
        WidgetUtils().customToastMsg(getCartDetailResponse.msg!);
      }
    } else if (requestCode == API.requestPlaceOrder && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var placeOrderResponse = PlaceOrderResponseModel.fromJson(response);

      if (placeOrderResponse.code! == 200) {
        setState(() {
          _objPlaceOrderDataModel = placeOrderResponse.data!;
          showDialog(
              context: context,
              builder: (context) => OrderSummaryPopup(_objPlaceOrderDataModel),
              useSafeArea: false);
        });
      } else {
        WidgetUtils().customToastMsg(placeOrderResponse.msg!);
      }
    } else if (requestCode == API.requestAddToCart && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var addToCartResponseModel = AddToCartResponseModel.fromJson(response);

      // inRoomSpecialsModel.data![0].meals
      if (addToCartResponseModel.code! == 200) {
        setState(() {
          wsGetCartDetailApi();
        });
      } else {
        WidgetUtils().customToastMsg(addToCartResponseModel.msg!);
      }
    }
  }


}
