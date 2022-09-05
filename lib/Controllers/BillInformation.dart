import 'package:flutter/material.dart';
import 'package:hamrostay/Controllers/OrderSummaryPopup.dart';
import 'package:hamrostay/Models/AddToCartRequestModel.dart';
import 'package:hamrostay/Models/AddToCartResponseModel.dart';
import 'package:hamrostay/Models/BillDetailsModel.dart';
import 'package:hamrostay/Models/GetCartDetailResponseModel.dart';
import 'package:hamrostay/Models/PlaceOrderResponseModel.dart';
import 'package:hamrostay/Models/UserModel.dart';
import 'package:hamrostay/Utils/API.dart';
import 'package:hamrostay/Utils/APICall.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';
import 'package:hamrostay/localization/localization.dart';

class BillInformation extends StatefulWidget {
  BillInformation({Key? key}) : super(key: key);

  @override
  _BillInformationState createState() => _BillInformationState();
}

class _BillInformationState extends State<BillInformation>
    implements OnResponseCallback {
  var userModel = UserData();
  var _isShowLoader = false;
  List<Item> items = [];
  BillData _billData = BillData();

  int cartIndex = 0;
  bool isMinusQuantity = false;

  @override
  void initState() {
    super.initState();
    wsBillDetails();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        backgroundColor: Constants.appLightBackgroundColor,
        appBar: WidgetUtils().customAppBar(
          context,
          Translations.of(context).strBillInformation,
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
    return (items.length == 0)
        ? WidgetUtils()
            .noDataFoundText(_isShowLoader, Translations.of(context).strNoDataFound, 150, 150)
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
                              itemCount: items.length,
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
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  WidgetUtils()
                                                      .simpleTextViewWithGivenFontSize(
                                                          items[index]
                                                              .name
                                                              .toString(),
                                                          getProportionalScreenWidth(
                                                              16),
                                                          Constants
                                                              .appDarkBlueTextColor,
                                                          "Inter",
                                                          FontWeight.w700),
                                                  WidgetUtils().simpleTextViewWithGivenFontSize(
                                                      'x ${items[index].units}',
                                                      getProportionalScreenWidth(
                                                          14),
                                                      Constants
                                                          .appDarkBlueTextColor,
                                                      "Inter",
                                                      FontWeight.w400,
                                                      txtAlign: TextAlign.left),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                                flex: 0,
                                                child: WidgetUtils()
                                                    .simpleTextViewWithGivenFontSize(
                                                        "${_billData.totalDetails?.currencySymbol}${items[index].totalPrice.toString()}",
                                                        getProportionalScreenWidth(
                                                            18),
                                                        Constants
                                                            .appCobaltBlueTextColor,
                                                        "Inter",
                                                        FontWeight.w700,
                                                        txtAlign:
                                                            TextAlign.left)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
                        _getTotalAmountView()
                      ],
                    ),
                  ),
                ),
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
              padding: EdgeInsets.only(left: 20.0, right: 20.0, /*top: 25.0*/),
              width: SizeConfig.screenWidth,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /*Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: WidgetUtils().simpleTextViewWithGivenFontSize(
                              'Subtotal',
                              getProportionalScreenWidth(16),
                              Constants.appDarkBlueTextColor,
                              "Inter",
                              FontWeight.w500,
                              txtAlign: TextAlign.left)),
                      Expanded(
                          child: WidgetUtils().simpleTextViewWithGivenFontSize(
                              "${_billData.totalDetails?.totalAmount}",
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
                              'Tax (%${_billData.totalDetails?.tax})',
                              getProportionalScreenWidth(16),
                              Constants.appLightBlueTextColor,
                              "Inter",
                              FontWeight.w500,
                              txtAlign: TextAlign.left)),
                      Expanded(
                          child: WidgetUtils().simpleTextViewWithGivenFontSize(
                              "${_billData.totalDetails?.tax}",
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
                              'Discount',
                              getProportionalScreenWidth(16),
                              Constants.appLightBlueTextColor,
                              "Inter",
                              FontWeight.w500,
                              txtAlign: TextAlign.left)),
                      Expanded(
                          child: WidgetUtils().simpleTextViewWithGivenFontSize(
                              "${_billData.totalDetails?.discount}",
                              getProportionalScreenWidth(16),
                              Constants.appLightBlueTextColor,
                              "Inter",
                              FontWeight.w500,
                              txtAlign: TextAlign.right)),
                    ],
                  ),
                  WidgetUtils().sizeBoxHeight(20.0),*/
                ],
              ),
            ),
            Container(
              height: 1.0,
              color: Constants.appSepratorColor,
            ),
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
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
                              "${_billData.totalDetails?.currencySymbol}${_billData.totalDetails?.totalBillAmount}",
                              getProportionalScreenWidth(16),
                              Constants.appDarkBlueTextColor,
                              "Inter",
                              FontWeight.w700,
                              txtAlign: TextAlign.right)),
                    ],
                  ),
                  WidgetUtils().sizeBoxHeight(20)
                ],
              ),
            ),
          ],
        ));
  }

  Future<void> wsBillDetails() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    setState(() {
      _isShowLoader = true;
    });

    var map = Map();
    map["hotel_id"] = userModel.hotelId;
    map["user_id"] = userModel.id;
    map["check_in_datetime"] = userModel.checkInDatetime;
    map["check_out_datetime"] = userModel.checkOutDatetime;

    APICall(context).getBillDetails(map, this);
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
    if (requestCode == API.requestGetBillDetail && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var billDetails = BillDetailsModel.fromJson(response);

      if (billDetails.code! == 200) {
        setState(() {
          _billData = billDetails.data!;
          _billData.result?.forEach((element) {
            if (element.items != null) items.addAll(element.items!);
          });
        });
      } else {
        WidgetUtils().customToastMsg(billDetails.msg!);
      }
    }
  }
}
