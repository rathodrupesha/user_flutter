import 'package:flutter/material.dart';
import 'package:hamrostay/Controllers/OrderSummary.dart';
import 'package:hamrostay/Models/AddToCartRequestModel.dart';
import 'package:hamrostay/Models/AddToCartResponseModel.dart';
import 'package:hamrostay/Models/HotelMealByCategoryModel.dart';
import 'package:hamrostay/Models/HotelMealCategoriesModel.dart';
import 'package:hamrostay/Models/InRoomSpecialsModel.dart';
import 'package:hamrostay/Models/UserModel.dart';
import 'package:hamrostay/Utils/API.dart';
import 'package:hamrostay/Utils/APICall.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';
import 'package:hamrostay/localization/localization.dart';

import 'MealDetails.dart';

class ViewAllMeal extends StatefulWidget {
  const ViewAllMeal(
      {Key? key,
      required this.mealType,
      required this.isAllCategory,
      this.categoryId})
      : super(key: key);

  @override
  _ViewAllMealState createState() => _ViewAllMealState();
  final String mealType;
  final bool isAllCategory;
  final String? categoryId;
}

class _ViewAllMealState extends State<ViewAllMeal>
    implements OnResponseCallback {
  var _isShowLoader = false;
  int cartIndex = 0;
  bool isMinusQuantity = false;
  var userModel = UserData();
  List<Meals> _objMealsModel = [];
  InRoomSpecialsData _objInRoomSpecialsDataModel = InRoomSpecialsData();

  bool isFromHotelMenu = false;
  int indexOfMeal = 0;

  @override
  void initState() {
    super.initState();
    if (widget.isAllCategory) {
      wsGetHotelMealByCategory(widget.categoryId ?? "");
    } else {
      wsDefaultInRoomMealCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return SafeArea(
      top: false,
      bottom: false,
      child: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: Constants.appLightBackgroundColor,
            appBar: WidgetUtils().customAppBar(
              context,
              widget.mealType,
              'assets/images/btn_back.png',
              Colors.white,
              () {
                Navigator.of(context).pop();
              },
              imgColor: Colors.white,
            ),
            body: _getBodyView(context),
          ),
          // _searchBarView()
        ],
      ),
    );
  }

  Widget _getBodyView(BuildContext context) {
    return Stack(
      children: [
        Padding(
            padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: getProportionalScreenHeight(120)),
            child: (widget.isAllCategory)
                ? _allItemsView()
                : (_objInRoomSpecialsDataModel.meals == null ||
                        _objInRoomSpecialsDataModel.meals!.length == 0)
                    ? WidgetUtils().noDataFoundText(
                        _isShowLoader, Translations.of(context).strNoDataFound, 150, 150)
                    : _breakfastServicesView()),
        WidgetUtils().sizeBoxHeight(SizeConfig.screenHeight * 0.15),
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
                      left: 25, right: 25, top: 25, bottom: 25),
                  child: WidgetUtils().customButton(
                    context,
                    '',
                    Constants.appBlueColor,
                    "Inter",
                    getProportionalScreenWidth(16),
                    Colors.white,
                    () {
                      //wsAddToCart();
                      WidgetUtils().push(context, () => OrderSummary());
                    },
                    btnAttributedText: Translations.of(context).strViewCheckout,
                    strSubTextFontFamily: "Inter",
                  ),
                ),
              )),
        ),
      ],
    );
  }

  Widget _breakfastServicesView() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _objInRoomSpecialsDataModel.meals!.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            WidgetUtils().push(
                context,
                () => MealDetails(
                    mealId: _objInRoomSpecialsDataModel.meals![index].id ?? 0));
          },
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              height: getProportionalScreenHeight(120),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  (_objInRoomSpecialsDataModel.meals![index].image == null)
                      ? Image.asset(
                          "assets/images/img_placeholder_logo.png",
                          width: SizeConfig.screenWidth * 0.25,
                          fit: BoxFit.cover,
                          height: double.infinity,
                        )
                      : FadeInImage.assetNetwork(
                          placeholder: "assets/images/img_placeholder_logo.png",
                          image: _objInRoomSpecialsDataModel.meals![index].image
                              .toString(),
                          width: SizeConfig.screenWidth * 0.25,
                          fit: BoxFit.fill,
                          height: double.infinity,
                        ),

                  // WidgetUtils().sizeBoxHeight(18),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, left: 15.0, right: 5.0),
                    child: Container(
                        width: SizeConfig.screenWidth * 0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            WidgetUtils().simpleTextViewWithGivenFontSize(
                                '${_objInRoomSpecialsDataModel.meals![index].name}',
                                getProportionalScreenWidth(16),
                                Constants.appDarkBlueTextColor,
                                "Inter",
                                FontWeight.w700,
                                maxLine: 1,
                                txtOverflow: TextOverflow.ellipsis,
                                txtAlign: TextAlign.left),
                            WidgetUtils().sizeBoxHeight(8),
                            /*WidgetUtils().simpleTextViewWithGivenFontSize(
                                '${_objInRoomSpecialsDataModel.meals![index].description}',
                                getProportionalScreenWidth(14),
                                Constants.appDarkBlueTextColor,
                                "Inter",
                                FontWeight.w400,
                                txtAlign: TextAlign.left,
                                maxLine: 1,
                                txtOverflow: TextOverflow.ellipsis),
                            WidgetUtils().sizeBoxHeight(12),*/
                           // Spacer(),

                            WidgetUtils()
                                .simpleTextViewWithGivenFontSize(
                                _objInRoomSpecialsDataModel
                                    .meals![index].unit! +
                                    _objInRoomSpecialsDataModel
                                        .meals![index].price!,
                                getProportionalScreenWidth(18),
                                Constants.appCobaltBlueTextColor,
                                "Inter",
                                FontWeight.w700,
                                txtAlign: TextAlign.left),
                            WidgetUtils().sizeBoxHeight(8),
                            Container(
                              height: getProportionalScreenHeight(34),
                              width: getProportionalScreenWidth(84),
                              padding:
                                  EdgeInsets.only(left: 3.0, right: 3.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    new Radius.circular(
                                        SizeConfig.screenWidth *
                                            0.1 /
                                            5.8)),
                                border: Border.all(
                                  color: Constants.appAquaTextColor,
                                  width: 2.0,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.start,
                                children: [
                                  Visibility(
                                    visible: (_objInRoomSpecialsDataModel
                                            .meals![index].count !=
                                        0),
                                    child: Expanded(
                                      child: IconButton(
                                        iconSize: 22,
                                        highlightColor:
                                            Colors.transparent,
                                        splashColor: Colors.transparent,
                                        color: Constants.appAquaTextColor,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.all(0),
                                        icon: Icon(Icons.remove),
                                        onPressed: () {
                                          setState(() {
                                            cartIndex = index;
                                            isMinusQuantity = true;

                                            wsAddToCart(-1);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  WidgetUtils().sizeBoxWidth(5),
                                  Expanded(
                                    child: Container(
                                      color: (_objInRoomSpecialsDataModel
                                                  .meals![index].count ==
                                              0)
                                          ? Colors.white
                                          : Constants.appAquaTextColor
                                              .withOpacity(0.3),
                                      height:
                                          SizeConfig.screenWidth * 0.1,
                                      child: Center(
                                        child: WidgetUtils()
                                            .simpleTextViewWithGivenFontSize(
                                                (_objInRoomSpecialsDataModel
                                                            .meals![index]
                                                            .count ==
                                                        0)
                                                    ? Translations.of(context).btnAdd
                                                    : _objInRoomSpecialsDataModel
                                                        .meals![index]
                                                        .count
                                                        .toString(),
                                                getProportionalScreenWidth(
                                                    13),
                                                (_objInRoomSpecialsDataModel
                                                            .meals![index]
                                                            .count ==
                                                        0)
                                                    ? Constants
                                                        .appAquaTextColor
                                                    : Constants
                                                        .appDarkBlueTextColor,
                                                "Inter",
                                                FontWeight.w500,
                                                txtAlign:
                                                    TextAlign.center),
                                      ),
                                    ),
                                  ),
                                  WidgetUtils().sizeBoxWidth(5),
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
                                          cartIndex = index;
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
                        )),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _allItemsView() {
    return Container(
      color: Constants.appLightBackgroundColor,
      child: (_objMealsModel.length == 0)
          ? WidgetUtils()
              .noDataFoundText(_isShowLoader, Translations.of(context).strNoDataFound, 150, 150)
          : ListView.builder(
              itemCount: _objMealsModel.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {},
                  child: InkWell(
                    onTap: () {
                      WidgetUtils().push(
                          context,
                          () => MealDetails(
                              mealId: _objMealsModel[index].id ?? 0));
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        color: Colors.white,
                        height: getProportionalScreenHeight(120),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            (_objMealsModel[index].image == null)
                                ? Image.asset(
                                    "assets/images/img_placeholder_logo.png",
                                    width: SizeConfig.screenWidth * 0.25,
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                  )
                                : FadeInImage.assetNetwork(
                                    placeholder:
                                        "assets/images/img_placeholder_logo.png",
                                    image:
                                        _objMealsModel[index].image.toString(),
                                    width: SizeConfig.screenWidth * 0.25,
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 15.0, right: 5.0),
                              child: Container(
                                width: SizeConfig.screenWidth * 0.6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    WidgetUtils().simpleTextViewWithGivenFontSize(
                                        _objMealsModel[index].name ?? "",
                                        getProportionalScreenWidth(16),
                                        Constants.appDarkBlueTextColor,
                                        "Inter",
                                        FontWeight.w700,
                                        maxLine: 1,
                                        txtOverflow: TextOverflow.ellipsis,
                                        txtAlign: TextAlign.left),
                                    WidgetUtils().sizeBoxHeight(8),
                                    WidgetUtils().simpleTextViewWithGivenFontSize(
                                        _objMealsModel[index].unit.toString() +
                                            _objMealsModel[index]
                                                .price
                                                .toString(),
                                        18,
                                        Constants.appCobaltBlueTextColor,
                                        "Inter",
                                        FontWeight.w700,
                                        txtAlign: TextAlign.left),
                                    WidgetUtils().sizeBoxHeight(8),
                                    Container(
                                      height: getProportionalScreenHeight(34),
                                      width: getProportionalScreenWidth(84),
                                      padding:
                                          EdgeInsets.only(left: 5.0, right: 5.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            new Radius.circular(
                                                SizeConfig.screenWidth *
                                                    0.1 /
                                                    5.8)),
                                        border: Border.all(
                                          color: Constants.appAquaTextColor,
                                          width: 2.0,
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Visibility(
                                              visible:
                                                  (_objMealsModel[index].count !=
                                                      0),
                                              child: Expanded(
                                                child: IconButton(
                                                  iconSize: 22,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  splashColor: Colors.transparent,
                                                  color:
                                                      Constants.appAquaTextColor,
                                                  alignment: Alignment.centerLeft,
                                                  padding: EdgeInsets.all(0),
                                                  icon: Icon(Icons.remove),
                                                  onPressed: () {
                                                    setState(() {
                                                      isMinusQuantity = true;
                                                      indexOfMeal = index;
                                                      isFromHotelMenu = true;
                                                      wsAddToCart(-1);
                                                    });
                                                  },
                                                ),
                                              )),
                                          Expanded(
                                            child: Container(
                                              color:
                                                  (_objMealsModel[index].count ==
                                                          0)
                                                      ? Colors.white
                                                      : Constants.appAquaTextColor
                                                          .withOpacity(0.3),
                                              height:
                                                  SizeConfig.screenWidth * 0.1,
                                              child: Center(
                                                child: WidgetUtils()
                                                    .simpleTextViewWithGivenFontSize(
                                                        (_objMealsModel[index]
                                                                    .count ==
                                                                0)
                                                            ? Translations.of(context).btnAdd
                                                            : _objMealsModel[
                                                                    index]
                                                                .count
                                                                .toString(),
                                                        getProportionalScreenWidth(
                                                            13),
                                                        (_objMealsModel[
                                                                        index]
                                                                    .count ==
                                                                0)
                                                            ? Constants
                                                                .appAquaTextColor
                                                            : Constants
                                                                .appDarkBlueTextColor,
                                                        "Inter",
                                                        FontWeight.w500,
                                                        txtAlign:
                                                            TextAlign.center),
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
                                                  indexOfMeal = index;
                                                  isFromHotelMenu = true;
                                                  wsAddToCart(1);
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> wsDefaultInRoomMealCategories() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    setState(() {
      _isShowLoader = true;
    });

    var map = Map();
    map["hotel_id"] = userModel.hotelId;

    APICall(context).getDefaultCategoryMeals(map, this);
  }

  Future<void> wsGetHotelMealByCategory(String categoryId) async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    setState(() {
      _isShowLoader = true;
    });

    var map = Map();
    map["hotel_id"] = userModel.hotelId;
    map["category_id"] = categoryId;

    var queryParameters = {
      'page': '',
      'limits': '',
    };

    APICall(context).getHotelMealByCategory(map, queryParameters, this);
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
    if (requestCode == API.requestDefaultCategoryMeals && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var inRoomSpecialsModel = InRoomSpecialsModel.fromJson(response);

      // inRoomSpecialsModel.data![0].meals
      if (inRoomSpecialsModel.code! == 200) {
        setState(() {
          var _objInRoomSpecialsModel = inRoomSpecialsModel.data!;

          for (var model in _objInRoomSpecialsModel) {
            if (model.category == widget.mealType) {
              _objInRoomSpecialsDataModel = model;
            }
          }
        });
      } else {
        WidgetUtils().customToastMsg(inRoomSpecialsModel.msg!);
      }
    } else if (requestCode == API.requestAddToCart && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var addToCartResponseModel = AddToCartResponseModel.fromJson(response);

      // inRoomSpecialsModel.data![0].meals
      if (addToCartResponseModel.code! == 200) {
        setState(() {
          if (isFromHotelMenu) {
            if (isMinusQuantity) {
              _objMealsModel[indexOfMeal].count =
                  (_objMealsModel[indexOfMeal].count - 1);
            } else {
              _objMealsModel[indexOfMeal].count =
                  (_objMealsModel[indexOfMeal].count + 1);
            }
          } else {
            if (isMinusQuantity) {
              _objInRoomSpecialsDataModel.meals![cartIndex].count =
                  (_objInRoomSpecialsDataModel.meals![cartIndex].count - 1);
            } else {
              _objInRoomSpecialsDataModel.meals![cartIndex].count =
                  (_objInRoomSpecialsDataModel.meals![cartIndex].count + 1);
            }
          }
        });
      } else {
        WidgetUtils().customToastMsg(addToCartResponseModel.msg!);
      }
    } else if (requestCode == API.requestHotelMealByCategory && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var hotelMealByCategoryModel =
          HotelMealByCategoryModel.fromJson(response);

      // inRoomSpecialsModel.data![0].meals

      if (hotelMealByCategoryModel.code! == 200) {
        setState(() {
          _objMealsModel = hotelMealByCategoryModel.data!.rows!;
        });
      } else {
        // WidgetUtils().customToastMsg(hotelModel.msg!);
      }
    }
  }

  Future<void> wsAddToCart(int count) async {
    List<Carts> carts = [];

   if (isFromHotelMenu) {
      carts.add(Carts(mealId: _objMealsModel[indexOfMeal].id, units: count));
    }else{
     carts.add(Carts(mealId: _objInRoomSpecialsDataModel.meals![cartIndex].id, units: count));
   }

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
}
