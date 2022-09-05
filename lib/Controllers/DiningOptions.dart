import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hamrostay/Controllers/MealDetails.dart';
import 'package:hamrostay/Controllers/OrderSummary.dart';
import 'package:hamrostay/Controllers/ViewAllMeal.dart';
import 'package:hamrostay/Models/AddToCartRequestModel.dart';
import 'package:hamrostay/Models/AddToCartResponseModel.dart';
import 'package:hamrostay/Models/HotelMealByCategoryModel.dart';
import 'package:hamrostay/Models/HotelMealCategoriesModel.dart';
import 'package:hamrostay/Models/InRoomSpecialsModel.dart';
import 'package:hamrostay/Models/SearchMealResponseModel.dart';
import 'package:hamrostay/Models/UserModel.dart';
import 'package:hamrostay/Utils/API.dart';
import 'package:hamrostay/Utils/APICall.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';

import '../localization/localization.dart';
import 'Settings.dart';

class DiningOptions extends StatefulWidget {
  const DiningOptions({Key? key, this.isFromDashboard}) : super(key: key);

  @override
  _DiningOptionsState createState() => _DiningOptionsState();
  final isFromDashboard;
}

class _DiningOptionsState extends State<DiningOptions>
    implements OnResponseCallback {
  var _isShowLoader = false;
  var userModel = UserData();
  List<InRoomSpecialsData> _objInRoomSpecialsModel = [];
  List<CategoryData> _objHotelMealCategoriesModel = [];
  List<SearchMealDetail> _objSearchMealsModel = [];

  var _searchController = TextEditingController();

  int indexOfMeal = 0;
  int indexOfSpecialMeal = 0;

  bool isMinusQuantity = false;
  bool isFromHotelMenu = false;

  @override
  void initState() {
    super.initState();
    wsDefaultInRoomMealCategories();
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
            appBar:  WidgetUtils().customAppBar(
                    context,
                    Translations.of(context).strDiningOption,
                    (widget.isFromDashboard) ? 'assets/images/btn_back.png' : 'assets/images/img_menu.png',
                    Colors.white,
                    () {
                      (widget.isFromDashboard)  ? Navigator.of(context).pop() : WidgetUtils().presentView(context, () => Settings());
                    },
                    barHeight: _objInRoomSpecialsModel.isNotEmpty ? 30 : 15,
                    imgColor: Colors.white,
            ),
            body: (_searchController.text.length > 0)
                ? _getBodyViewWithSearch(context)
                : _getBodyView(context),
          ),
           _searchBarView()
        ],
      ),
    );
  }

  Widget _searchBarView() {
    return _objInRoomSpecialsModel.isNotEmpty
        ? Positioned(
            child: Container(
              height: 50,
              child: Material(
                elevation: 5,
                borderRadius: new BorderRadius.all(new Radius.circular(10)),
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onEditingComplete: (){
                    searchMeal(_searchController.text.toString());
                    },
                  //onChanged: searchMeal,
                  autofocus: false,
                  onSubmitted: (value) {},
                  cursorColor: Constants.appDarkBlueTextColor,
                  decoration: InputDecoration(
                      hintText: Translations.of(context).strSearchHere,
                      contentPadding: EdgeInsets.only(left: 20,right: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      suffixIcon: IconButton(
                        iconSize: 25,
                        icon: Icon(
                          Icons.search,
                        ),
                        color: Constants.appDarkGreenColor,
                        onPressed: () {
                          searchMeal(_searchController.text.toString());
                        },
                      )),
                  style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.normal,
                      color: Constants.appDarkBlueTextColor,
                      fontSize: getProportionalScreenWidth(16)),
                ),
              ),
            ),
            left: 10,
            top: SizeConfig.topHeight + kToolbarHeight + 15,
            right: 10,
          )
        : Container();
  }

  void searchMeal(String value) {
    if(value.isNotEmpty) {
      wsSearchMealAPi(value);
    }else{
      setState(() {

      });
    }
  }

  Widget _getBodyView(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
           WidgetUtils().sizeBoxHeight(20),
          Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0,top: 40),
              child: (_objInRoomSpecialsModel.length == 0)
                  ? WidgetUtils().noDataFoundText(
                      _isShowLoader, Translations.of(context).strNoDataFound, 150, 150)
                  : _mainCategoryView()),
          //(_objHotelMealCategoriesModel.isNotEmpty) ? WidgetUtils().sizeBoxHeight(getProportionalScreenHeight(15)) : Container(),

          Visibility(
            visible: _objHotelMealCategoriesModel.isNotEmpty,
            child: Container(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0,top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WidgetUtils().simpleTextViewWithGivenFontSize(
                      Translations.of(context).strAllItems,
                      getProportionalScreenWidth(18),
                      Constants.blueColor,
                      "Inter",
                      FontWeight.w700,
                      txtAlign: TextAlign.left),
                  WidgetUtils().sizeBoxHeight(2),
                  WidgetUtils().simpleTextViewWithGivenFontSize(
                      Translations.of(context).strOurSpecialMenuFromEntireWorld,
                      getProportionalScreenWidth(14),
                      Constants.blueColor,
                      "Inter",
                      FontWeight.w400,
                      txtAlign: TextAlign.left),
                ],
              ),
            ),
          ),

          (_objHotelMealCategoriesModel.isNotEmpty) ? Padding(padding: const EdgeInsets.only(left: 20.0, right: 20.0,top: 20),child: _allItemsView()) : Container(),
          WidgetUtils().sizeBoxHeight(SizeConfig.screenHeight * 0.15),
        ],
      ),
    );
  }

  Widget _getBodyViewWithSearch(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 14.0, right: 14.0,top: 50),
                  child: (_objSearchMealsModel.length == 0)
                      ? WidgetUtils().noDataFoundText(
                          _isShowLoader, Translations.of(context).strNoDataFound, 150, 150)
                      : _searchMealView()),
              WidgetUtils().sizeBoxHeight(SizeConfig.screenHeight * 0.15),
            ],
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
                      left: 25, right: 25, top: 25, bottom: 25),
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
      ],
    );
  }

  Widget _searchMealView() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _objSearchMealsModel.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: (){
            WidgetUtils().push(context, () => MealDetails(mealId:_objSearchMealsModel[index].id ?? 0));
          },
          child: Container(
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
                    (_objSearchMealsModel[index].image == null)
                        ? Image.asset(
                            "assets/images/img_placeholder_logo.png",
                            width: SizeConfig.screenWidth * 0.25,
                            fit: BoxFit.cover,
                      height: double.infinity,
                          )
                        : FadeInImage.assetNetwork(
                            placeholder: "assets/images/img_placeholder_logo.png",
                            image: _objSearchMealsModel[index].image ?? "",
                            width: SizeConfig.screenWidth * 0.25,
                            fit: BoxFit.fill,
                      height: double.infinity,
                          ),

                    // WidgetUtils().sizeBoxHeight(18),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10.0, left: 15.0, right: 5.0),
                      child: Container(
                          width: SizeConfig.screenWidth * 0.6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  '${_objSearchMealsModel[index].name}',
                                  getProportionalScreenWidth(16),
                                  Constants.appDarkBlueTextColor,
                                  "Inter",
                                  FontWeight.w700,
                                  maxLine: 1,
                                  txtOverflow: TextOverflow.ellipsis,
                                  txtAlign: TextAlign.left),

                              WidgetUtils().sizeBoxHeight(8),

                              WidgetUtils().simpleTextViewWithGivenFontSize(
                                  _objSearchMealsModel[index].unit! + _objSearchMealsModel[index].price!,
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Visibility(
                                      visible: (_objSearchMealsModel[index]
                                              .count !=
                                          0),
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
                                              indexOfMeal = index;

                                              wsAddToCart(-1);
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    WidgetUtils().sizeBoxWidth(5),
                                    Expanded(
                                      child: InkWell(
                                        onTap: (){
                                          if(_objSearchMealsModel[index].count <= 0) {
                                            indexOfMeal = index;
                                            isMinusQuantity = false;

                                            wsAddToCart(1);
                                          }
                                        },
                                        child: Container(
                                          color: (_objSearchMealsModel[index]
                                                      .count ==
                                                  0)
                                              ? Colors.white
                                              : Constants.appAquaTextColor
                                                  .withOpacity(0.3),
                                          height: SizeConfig.screenWidth * 0.1,
                                          child: Center(
                                            child: WidgetUtils()
                                                .simpleTextViewWithGivenFontSize(
                                                    (_objSearchMealsModel[index].count <= 0)
                                                        ? Translations.of(context).btnAdd
                                                        : _objSearchMealsModel[index].count.toString(), getProportionalScreenWidth(13),
                                                    (_objSearchMealsModel[index].count == 0)
                                                        ? Constants.appAquaTextColor
                                                        : Constants.appDarkBlueTextColor,
                                                    "Inter",
                                                    FontWeight.w500,
                                                    txtAlign: TextAlign.center),
                                          ),
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
                                            indexOfMeal = index;
                                            isMinusQuantity = false;

                                            wsAddToCart(1);
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
          ),
        );
      },
    );
  }

  Widget _allItemsView() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _objHotelMealCategoriesModel.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 10,
          childAspectRatio: (((SizeConfig.screenWidth - 60) * 0.5) /
              ((SizeConfig.screenWidth - 60) * 0.5))),
      itemBuilder: (BuildContext context, int index) {
        return new GestureDetector(
            child: new Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CachedNetworkImage(
                    width: ((SizeConfig.screenWidth - 60) * 0.5),
                    height: ((SizeConfig.screenWidth - 60) * 0.32),
                    fit: BoxFit.fill,
                    imageUrl: _objHotelMealCategoriesModel[index].image ?? "",
                    placeholder: (context, url) => Container(
                      color: Constants.appAquaPlaceholderColor,
                      child: Image.asset(
                        'assets/images/img_placeholder_logo.png',
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Constants.appAquaPlaceholderColor,
                      child: Image.asset(
                        'assets/images/img_placeholder_logo.png',
                      ),
                    ),
                  ),
                  Container(
                      width: ((SizeConfig.screenWidth - 60) * 0.5),
                      height: ((SizeConfig.screenWidth - 60) * 0.16),
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      alignment: Alignment.center,
                      child: WidgetUtils().simpleTextViewWithGivenFontSize(
                          '${_objHotelMealCategoriesModel[index].name ?? ""}',
                          getProportionalScreenWidth(14),
                          Constants.appDarkBlueTextColor,
                          "Inter",
                          FontWeight.w500,
                          maxLine: 2,
                          txtOverflow: TextOverflow.ellipsis,
                          txtAlign: TextAlign.center)),
                ],
              ),
            ),
            onTap: () {
              WidgetUtils().push(
                  context,
                      () => ViewAllMeal(mealType: _objHotelMealCategoriesModel[index].name ?? "",isAllCategory: true,categoryId: _objHotelMealCategoriesModel[index].id.toString(),
                  ));
            });
      },
    );
  }

  Widget _mainCategoryView() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _objInRoomSpecialsModel.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 10,
          childAspectRatio: (((SizeConfig.screenWidth - 60) * 0.5) /
              ((SizeConfig.screenWidth - 60) * 0.5))),
      itemBuilder: (BuildContext context, int index) {
        return new GestureDetector(
            child: new Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CachedNetworkImage(
                    width: ((SizeConfig.screenWidth - 60) * 0.5),
                    height: ((SizeConfig.screenWidth - 60) * 0.32),
                    fit: BoxFit.fill,
                    imageUrl: _objInRoomSpecialsModel[index].image ?? "",
                    placeholder: (context, url) => Container(
                      color: Constants.appAquaPlaceholderColor,
                      child: Image.asset(
                        'assets/images/img_placeholder_logo.png',
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Constants.appAquaPlaceholderColor,
                      child: Image.asset(
                        'assets/images/img_placeholder_logo.png',
                      ),
                    ),
                  ),
                  Container(
                      width: ((SizeConfig.screenWidth - 60) * 0.5),
                      height: ((SizeConfig.screenWidth - 60) * 0.16),
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      alignment: Alignment.center,
                      child: WidgetUtils().simpleTextViewWithGivenFontSize(
                          '${_objInRoomSpecialsModel[index].category ?? ""}',
                          getProportionalScreenWidth(14),
                          Constants.appDarkBlueTextColor,
                          "Inter",
                          FontWeight.w500,
                          maxLine: 2,
                          txtOverflow: TextOverflow.ellipsis,
                          txtAlign: TextAlign.center)),
                ],
              ),
            ),
            onTap: () {
              WidgetUtils().push(
                  context,
                      () => ViewAllMeal(mealType: _objInRoomSpecialsModel[index].category.toString(),isAllCategory: false,
                  ));
            });
      },
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

  Future<void> wsGetHotelMealCategories() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    setState(() {
      _isShowLoader = true;
    });

    var map = Map();
    map["hotel_id"] = userModel.hotelId;

    var queryParameters = {
      'page': '',
      'limits': '',
    };

    APICall(context).getHotelMealCategories(map, queryParameters, this);
  }

  Future<void> wsAddToCart(int count) async {
    List<Carts> carts = [];

    if(_searchController.text.length > 0){
      carts.add(Carts(mealId: _objSearchMealsModel[indexOfMeal].id, units: count));
    } /*else if (isFromHotelMenu) {
      carts.add(Carts(mealId: _objMealsModel[indexOfMeal].id, units: count));
    }*/ else {
      carts.add(Carts(
          mealId: _objInRoomSpecialsModel[indexOfSpecialMeal]
              .meals![indexOfMeal]
              .id,
          units: count));
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

  Future<void> wsSearchMealAPi(String value) async {
    setState(() {
      _isShowLoader = true;
    });
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    var map = Map();
    map["hotel_id"] = userModel.hotelId;
    map["search_string"] = value;

    var queryParameters = {
      'page': '1',
      'limits': '100',
    };

    APICall(context).searchMealListApi(map, queryParameters, this);
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

      wsGetHotelMealCategories();
      if (inRoomSpecialsModel.code! == 200) {
        setState(() {
          _objInRoomSpecialsModel = inRoomSpecialsModel.data!;
        });
      } else {
        // WidgetUtils().customToastMsg(hotelModel.msg!);
      }
    } else if (requestCode == API.requestHotelMealCategories && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var hotelMealCategoryModel = HotelMealCategoriesModel.fromJson(response);

      // inRoomSpecialsModel.data![0].meals

      if (hotelMealCategoryModel.code! == 200) {
        setState(() {
          _objHotelMealCategoriesModel = hotelMealCategoryModel.data!;

          //if (_objHotelMealCategoriesModel.isNotEmpty)
            //wsGetHotelMealByCategory(_objHotelMealCategoriesModel[0].id.toString());
        });
      } else {
        // WidgetUtils().customToastMsg(hotelModel.msg!);
      }
    }  else if (requestCode == API.requestAddToCart && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var addToCartResponseModel = AddToCartResponseModel.fromJson(response);

      // inRoomSpecialsModel.data![0].meals
      if (addToCartResponseModel.code! == 200) {
        setState(() {
          if (_searchController.text.length > 0) {
            if (isMinusQuantity) {
              _objSearchMealsModel[indexOfMeal].count =
                  (_objSearchMealsModel[indexOfMeal].count - 1);
            } else {
              _objSearchMealsModel[indexOfMeal].count =
                  (_objSearchMealsModel[indexOfMeal].count + 1);
            }
          }/* else if (isFromHotelMenu) {
            if (isMinusQuantity) {
              _objMealsModel[indexOfMeal].count =
                  (_objMealsModel[indexOfMeal].count - 1);
            } else {
              _objMealsModel[indexOfMeal].count =
                  (_objMealsModel[indexOfMeal].count + 1);
            }
          }*/ else {
            if (isMinusQuantity) {
              _objInRoomSpecialsModel[indexOfSpecialMeal]
                  .meals![indexOfMeal]
                  .count = (_objInRoomSpecialsModel[indexOfSpecialMeal]
                      .meals![indexOfMeal]
                      .count -
                  1);
            } else {
              _objInRoomSpecialsModel[indexOfSpecialMeal]
                  .meals![indexOfMeal]
                  .count = (_objInRoomSpecialsModel[indexOfSpecialMeal]
                      .meals![indexOfMeal]
                      .count +
                  1);
            }
          }
        });
      } else {
        WidgetUtils().customToastMsg(addToCartResponseModel.msg!);
      }
    } else if (requestCode == API.requestSearchMealList && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var hotelMealByCategoryModel = SearchMealResponseModel.fromJson(response);

      if (hotelMealByCategoryModel.code! == 200) {
        setState(() {
          _objSearchMealsModel = hotelMealByCategoryModel.data!.rows!;
        });
      } else {
        WidgetUtils().customToastMsg(hotelMealByCategoryModel.msg!);
      }
    }
  }
}
