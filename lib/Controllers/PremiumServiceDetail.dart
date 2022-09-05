import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hamrostay/Controllers/ServiceOrderSummary.dart';
import 'package:hamrostay/Models/SubServicesModel.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';

import '../Utils/app_date_format.dart';
import '../Utils/date_utils.dart';
import '../localization/localization.dart';

class PremiumServiceDetail extends StatefulWidget {
  PremiumServiceDetail({Key? key, required this.objPremiumServices})
      : super(key: key);

  @override
  _PremiumServiceDetailState createState() => _PremiumServiceDetailState();
  final SubServicesRows objPremiumServices;
}

class _PremiumServiceDetailState extends State<PremiumServiceDetail> {
  final CarouselController _carouselController = CarouselController();
  var imgCurrentIndex = 0;
  var _isShowLoader = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        backgroundColor: Constants.appLightBackgroundColor,
        appBar: WidgetUtils().customAppBar(
          context,
          // 'vena',
          '${widget.objPremiumServices.name ?? ""}',
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
        SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          widget.objPremiumServices.images != null
                              ? CarouselSlider(
                                  options: CarouselOptions(
                                      viewportFraction: 1,
                                      height: SizeConfig.screenHeight * 0.28,
                                      enableInfiniteScroll: false,
                                      autoPlay: false,
                                      scrollDirection: Axis.horizontal,
                                      initialPage: 0,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          imgCurrentIndex = index;
                                        });
                                      }),
                                  carouselController: _carouselController,
                                  items: widget.objPremiumServices.images!
                                      .map((item) => Container(
                                            child: Center(
                                                child: CachedNetworkImage(
                                              width: SizeConfig.screenWidth,
                                              height: SizeConfig.screenHeight *
                                                  0.28,
                                              fit: BoxFit.cover,
                                              imageUrl: widget
                                                          .objPremiumServices
                                                          .images!
                                                          .length >
                                                      0
                                                  ? item.trim()
                                                  : "",
                                              placeholder: (context, url) =>
                                                  Container(
                                                color: Constants
                                                    .appAquaPlaceholderColor,
                                                child: Image.asset(
                                                  'assets/images/img_placeholder_logo.png',
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                color: Constants
                                                    .appAquaPlaceholderColor,
                                                child: Image.asset(
                                                  'assets/images/img_placeholder_logo.png',
                                                ),
                                              ),
                                            )),
                                          ))
                                      .toList(),
                                )
                              : Container(
                                  width: SizeConfig.screenWidth,
                                  height: SizeConfig.screenHeight * 0.28,
                                ),
                          Positioned(
                            top: SizeConfig.screenHeight * 0.2,
                            right: SizeConfig.screenWidth * 0.025,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: new BorderRadius.all(
                                      Radius.circular(6.0)),
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                alignment: Alignment.center,
                                height: SizeConfig.screenHeight * 0.045,
                                width: SizeConfig.screenWidth * 0.16,
                                child: widget.objPremiumServices.images != null
                                    ? WidgetUtils().simpleTextViewWithGivenFontSize(
                                        '${imgCurrentIndex + 1}/${widget.objPremiumServices.images!.length}',
                                        getProportionalScreenWidth(14),
                                        Colors.white,
                                        "Inter",
                                        FontWeight.w600,
                                        txtAlign: TextAlign.center)
                                    : Container(),
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20, top: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                WidgetUtils().sizeBoxHeight(10),
                                // Container(
                                //   padding: EdgeInsets.all(5.0),
                                //   decoration: BoxDecoration(
                                //     borderRadius:
                                //         new BorderRadius.all(Radius.circular(8.0)),
                                //     color: Constants.appCobaltBlueTextColor,
                                //   ),
                                //   child: WidgetUtils()
                                //       .simpleTextViewWithGivenFontSize(
                                //           '40% Exclusive discount ',
                                //           getProportionalScreenWidth(12),
                                //           Colors.white,
                                //           "Inter",
                                //           FontWeight.w400),
                                // ),
                                // WidgetUtils().sizeBoxHeight(16),
                                WidgetUtils().simpleTextViewWithGivenFontSize(
                                    '${widget.objPremiumServices.name ?? ""}',
                                    getProportionalScreenWidth(20),
                                    Constants.appDarkBlueTextColor,
                                    "Inter",
                                    FontWeight.w600),
                                WidgetUtils().sizeBoxHeight(10),
                                WidgetUtils().simpleTextViewWithGivenFontSize(
                                    '${widget.objPremiumServices.description ?? ""}',
                                    getProportionalScreenWidth(14),
                                    Constants.appDarkBlueTextColor,
                                    "Inter",
                                    FontWeight.w400),
                               // WidgetUtils().sizeBoxHeight(30),
                              ]))
                    ],
                  ),
                ),
                Container(
                  color: Constants.appLightBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, right: 18.0, top: 24.0, bottom: 14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        widget.objPremiumServices.packages!.isNotEmpty
                            ? WidgetUtils().simpleTextViewWithGivenFontSize(
                                Translations.of(context).strPackageAvailable,
                                getProportionalScreenWidth(18),
                                Constants.blueColor,
                                "Inter",
                                FontWeight.w700,
                                txtAlign: TextAlign.start)
                            : Container(),
                        _availablePackageView(),
                        _allTimeAvailablePackageView(),
                      ],
                    ),
                  ),
                )
              ],
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
            visible: _isShowLoader)
      ],
    );
  }

  Widget _availablePackageView() {
    return Container(
      color: Constants.appLightBackgroundColor,
      child: widget.objPremiumServices.packages!.isNotEmpty
          ? ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              itemCount: widget.objPremiumServices.packages!.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: ListTile(
                    onTap: () {
                      WidgetUtils().push(context, () => ServiceOrderSummary(widget.objPremiumServices,widget.objPremiumServices.id.toString(),widget.objPremiumServices.packages![index].id.toString()));

                      // showDialog(
                      //     context: context,
                      //     builder: (context) => PremiumRequestSucessPopup(),
                      //     useSafeArea: false);
                    },
                    title: Padding(
                      padding: const EdgeInsets.only(top: 15.0,bottom: 15.0,left: 10.0,right: 10.0),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            WidgetUtils().simpleTextViewWithGivenFontSize(
                                '${widget.objPremiumServices.packages![index].name}',
                                getProportionalScreenWidth(16),
                                Constants.appDarkBlueTextColor,
                                "Inter",
                                FontWeight.w700,
                                txtAlign: TextAlign.left),
                            WidgetUtils().sizeBoxHeight(10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/img_clock.png',
                                  width: 18,
                                  height: 18,
                                ),
                                WidgetUtils().sizeBoxWidth(6),
                                WidgetUtils().simpleTextViewWithGivenFontSize(
                                    '${widget.objPremiumServices.packages![index].duration}  ${widget.objPremiumServices.packages![index].durationUnit}',
                                    getProportionalScreenWidth(12),
                                    Constants.appDarkBlueTextColor,
                                    "Inter",
                                    FontWeight.w400,
                                    txtAlign: TextAlign.left),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        WidgetUtils().simpleTextViewWithGivenFontSize(
                            '${widget.objPremiumServices.packages![index].amountUnit}${widget.objPremiumServices.packages![index].amount}',
                            getProportionalScreenWidth(16),
                            Constants.appCobaltBlueTextColor,
                            "Inter",
                            FontWeight.bold,
                            txtAlign: TextAlign.left),
                        WidgetUtils().sizeBoxHeight(5),
                        WidgetUtils().simpleTextViewWithGivenFontSize(
                            '/person',
                            getProportionalScreenWidth(12),
                            Constants.appDarkBlueTextColor,
                            "Inter",
                            FontWeight.w400,
                            txtAlign: TextAlign.left),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 12,
                );
              },
            )
          : Container(
              /*padding: EdgeInsets.only(top: 50),
              child: Center(
                child: WidgetUtils().simpleTextViewWithGivenFontSize(
                  'No packages available',
                  getProportionalScreenWidth(16),
                  Constants.appDarkBlueTextColor,
                  "Inter",
                  FontWeight.w400,
                ),
              ),*/
            ),
    );
  }

  Widget _allTimeAvailablePackageView() {
    return Container(
      color: Constants.appLightBackgroundColor,
      child: widget.objPremiumServices.openingHours!.isNotEmpty
          ? ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        itemCount: widget.objPremiumServices.openingHours!.length,
        itemBuilder: (context, index) {
          return (widget.objPremiumServices.openingHours![index].openingStatus == true) ? Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.only(top: 5.0,bottom: 5.0,left: 5.0,right: 5.0),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      WidgetUtils().simpleTextViewWithGivenFontSize(
                          '${widget.objPremiumServices.openingHours![index].days}',
                          getProportionalScreenWidth(16),
                          Constants.appDarkBlueTextColor,
                          "Inter",
                          FontWeight.w700,
                          txtAlign: TextAlign.left),

                    ],
                  ),
                ),
              ),
              trailing : Container(
                width: SizeConfig.screenWidth * 0.45,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/images/img_clock.png',
                      width: 18,
                      height: 18,
                    ),
                    WidgetUtils().sizeBoxWidth(6),
                    WidgetUtils().simpleTextViewWithGivenFontSize(
                        DateUtilss.dateToString(DateUtilss.stringToDate(widget.objPremiumServices.openingHours![index].openTime!,format: AppDateFormat.hoursFormat,isUTCTime: false)!,format: AppDateFormat.hoursAMPMFormat)+ " - " + DateUtilss.dateToString(DateUtilss.stringToDate(widget.objPremiumServices.openingHours![index].closeTime!,format: AppDateFormat.hoursFormat,isUTCTime: false)!,format: AppDateFormat.hoursAMPMFormat),
                        getProportionalScreenWidth(12),
                        Constants.appDarkBlueTextColor,
                        "Inter",
                        FontWeight.w400,
                        txtAlign: TextAlign.left),
                  ],
                ),
              )
            ),
          ) : Container();
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: (widget.objPremiumServices.openingHours![index].openingStatus == true) ? 5 : 0,
          );
        },
      )
          : Container(
        /*padding: EdgeInsets.only(top: 50),
              child: Center(
                child: WidgetUtils().simpleTextViewWithGivenFontSize(
                  'No packages available',
                  getProportionalScreenWidth(16),
                  Constants.appDarkBlueTextColor,
                  "Inter",
                  FontWeight.w400,
                ),
              ),*/
      ),
    );
  }
}
