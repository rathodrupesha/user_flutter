import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hamrostay/Controllers/AnnouncementCategoryPage.dart';
import 'package:hamrostay/Controllers/Details.dart';
import 'package:hamrostay/Controllers/Directory.dart';
import 'package:hamrostay/Controllers/InRoomDining.dart';
import 'package:hamrostay/Controllers/MyRequests.dart';
import 'package:hamrostay/Controllers/Notifications.dart';
import 'package:hamrostay/Controllers/PremiumServices.dart';
import 'package:hamrostay/Controllers/RateHotel.dart';
import 'package:hamrostay/Controllers/Services.dart';
import 'package:hamrostay/Controllers/Settings.dart';
import 'package:hamrostay/Models/HotelModel.dart';
import 'package:hamrostay/Models/MainServicesModel.dart';
import 'package:hamrostay/Models/SubServicesModel.dart';
import 'package:hamrostay/Models/UserModel.dart';
import 'package:hamrostay/Utils/API.dart';
import 'package:hamrostay/Utils/APICall.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/MyPrefs.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:hamrostay/localization/localization.dart';
import 'package:readmore/readmore.dart';
import '../Models/GetOwnerMessageResponseModel.dart';
import '../Utils/MarqueeWidget.dart';
import '../Utils/app_date_format.dart';
import '../Utils/date_utils.dart';
import 'AmenitiesScreen.dart';
import 'DiningOptions.dart';
import 'FAQs.dart';
import 'Login.dart';
import 'PremiumServiceDetail.dart';
import 'Profile.dart';
import 'TermsOfUse.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> implements OnResponseCallback {
  int _currentIndex = 0;
  var _isShowLoader = false;
  var _hotelData = HotelData();
  DateTime? currentBackPressTime;

  List<MainServicesRows> _objMainServicesRowModel = [];
  var userModel = UserData();
  List<SubServicesRows> _objPremiumServicesRowModel = [];
  OwnerMessageData? _objOwnerMessageModel;

  @override
  void initState() {
    super.initState();

    getUser();
    wsCurrentStay();
  }

  getUser() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return WillPopScope(
      child: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: <Widget>[
            Scaffold(
              bottomNavigationBar: Visibility(visible:_hotelData.id !=null,child: _bottomBar()),
              backgroundColor: Constants.appLightBackgroundColor,
              appBar: (_currentIndex != 1)
                  ? _customNavigationView(_currentIndex)
                  : PreferredSize(
                      child: WidgetUtils().customAppBar(
                          context, "In Room", "", Colors.white, () {}),
                      preferredSize: Size.fromHeight(0.0)),
              body: _changeTabs(_currentIndex),
            ),
            // _currentIndex == 2 ? _searchBarView() : Container()
          ],
        ),
      ),
      onWillPop: onWillPop,
    );
  }

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: Translations.of(context).strPressBackToExit,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Constants.appBlueColor,
          textColor: Colors.white,
          fontSize: 16.0);
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget _bottomBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      iconSize: 25,
      selectedItemColor: Constants.appBlueColor,
      unselectedItemColor: Colors.white,
      currentIndex: _currentIndex,
      onTap: _onBottomBarItemTapped,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: Constants.blueColor,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/img_bar_home.png'),
            ),
            label: ""),
        BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/img_bar_inroom.png'),
            ),
            label: ""),
        BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/img_bar_order.png'),
            ),
            label: ""),
        BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/img_bar_notification.png'),
            ),
            label: ""),
        BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/img_bar_premium.png'),
            ),
            label: "")
      ],
    );
  }

  void _onBottomBarItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _changeTabs(int index) {
    switch (index) {
      case 0:
        return (_hotelData.id ==null && !_isShowLoader) ? AnnouncementCategoryPage() : _getBodyView();
      case 1:
        return DiningOptions(isFromDashboard: false);
      case 2:
        return MyRequests(isFromDashboard: false);
      case 3:
        return Notifications();
      case 4:
        return PremiumServices(
            isFromDashboard: false,
            objPremiumServices: _objPremiumServicesRowModel,
            objUserModel: userModel);
      default:
        return Container();
    }
  }

  AppBar _customNavigationView(int index) {
    switch (index) {
      case 0:
        return WidgetUtils().customAppBar(
            context,
            (_hotelData.hotelName != null) ? _hotelData.hotelName! : (userModel.user != null) ? userModel.user!.currentHotel!.hotelName! : "",
            'assets/images/img_menu.png',
            Colors.white,
            () {
              WidgetUtils().presentView(context, () => Settings());
            },
            imgColor: Colors.white,
            //isRightControl: true,
            //rightImgName: userModel.profileImage ?? "",
            // barHeight: 50,
            onRightBtnPress: () {
              WidgetUtils()
                  .push(context, () => Profile(strTitle: Translations.of(context).strEditProfile));
            });
      case 1:
        return WidgetUtils().customAppBar(
          context,
          Translations.of(context).strDiningOption,
          'assets/images/img_menu.png',
          Colors.white,
          () {
            WidgetUtils().presentView(context, () => Settings());
          },
          imgColor: Colors.white,
        );

      case 2:
        return WidgetUtils().customAppBar(
            context, Translations.of(context).strMyRequest, 'assets/images/img_menu.png', Colors.white,
            () {
          WidgetUtils().presentView(context, () => Settings());
        },
            //barHeight: 50,
            imgColor: Colors.white);
      case 3:
        return WidgetUtils().customAppBar(
            context,
            Translations.of(context).strNotification,
            'assets/images/img_menu.png',
            Colors.white,
            () {
              WidgetUtils().presentView(context, () => Settings());
            },
            imgColor: Colors.white,
            //isRightControl: true,
            //rightImgName: userModel.profileImage ?? "",
            onRightBtnPress: () {
              print('Notification image clicked');
            });
      case 4:
        return WidgetUtils().customAppBar(
            context,
            Translations.of(context).strPremiumServices,
            'assets/images/img_menu.png',
            Colors.white,
            () {
              WidgetUtils().presentView(context, () => Settings());
            },
            imgColor: Colors.white,
            //isRightControl: true,
            //rightImgName: userModel.profileImage ?? "",
            onRightBtnPress: () {
              print('Notification image clicked');
            });
      default:
        return WidgetUtils().customAppBar(
          context,
          '',
          'assets/images/img_menu.png',
          Colors.white,
          () {
            WidgetUtils().presentView(context, () => Settings());
          },
          imgColor: Colors.white,
        );
    }
  }

  Widget _getBodyView() {
    return (_hotelData.id == null)
        ? Container(
            height: SizeConfig.screenHeight * 0.75,
            child: WidgetUtils()
                .noDataFoundText(_isShowLoader, Translations.of(context).strNoDataFound, 150, 150))
        : RefreshIndicator(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 2, right: 2, bottom: 16,top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _currentStayView(),
                        WidgetUtils().sizeBoxHeight(22),
                        Container(
                            padding: EdgeInsets.only(
                                left: getProportionalScreenWidth(16),
                                right: getProportionalScreenWidth(16)),
                            child: WidgetUtils()
                                .simpleTextViewWithGivenFontSize(
                                Translations.of(context).strOurServices,
                                    getProportionalScreenWidth(18),
                                Constants.blueColor,
                                    "Inter",
                                    FontWeight.w700)),
                        WidgetUtils().sizeBoxHeight(22),
                        Container(
                            padding: EdgeInsets.only(
                                left: getProportionalScreenWidth(16),
                                right: getProportionalScreenWidth(16)),
                            child: _ourServicesView()),
                        WidgetUtils().sizeBoxHeight(11),
                        (_objPremiumServicesRowModel.isNotEmpty)
                            ? Container(
                                padding: EdgeInsets.only(
                                    left: getProportionalScreenWidth(16),
                                    right: getProportionalScreenWidth(16)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: WidgetUtils()
                                            .simpleTextViewWithGivenFontSize(
                                            Translations.of(context).strOurPremiumServices,
                                                getProportionalScreenWidth(18),
                                            Constants.blueColor,
                                                "Inter",
                                                FontWeight.w700)),
                                    Expanded(
                                        flex: 0,
                                        child: WidgetUtils().buttonSimpleText(
                                            Translations.of(context).strViewAll,
                                            "Inter",
                                            getProportionalScreenWidth(14),
                                            Constants.appBarGreenColor, () {
                                          WidgetUtils().push(
                                              context,
                                              () => PremiumServices(
                                                    isFromDashboard: true,
                                                    objPremiumServices:
                                                        _objPremiumServicesRowModel,
                                                    objUserModel: userModel,
                                                  ));
                                        }, FontWeight.w500)),
                                  ],
                                ),
                              )
                            : Container(),
                        (_objPremiumServicesRowModel.isNotEmpty)
                            ? WidgetUtils().sizeBoxHeight(10)
                            : Container(),
                        (_objPremiumServicesRowModel.isNotEmpty)
                            ? Container(
                                padding: EdgeInsets.only(
                                    left: getProportionalScreenWidth(16),
                                    right: getProportionalScreenWidth(16)),
                                child: _premiumServicesView())
                            : Container(),
                        WidgetUtils().sizeBoxHeight(22),
                        Container(
                            padding: EdgeInsets.only(
                                left: getProportionalScreenWidth(16),
                                right: getProportionalScreenWidth(16)),
                            child: WidgetUtils()
                                .simpleTextViewWithGivenFontSize(
                                Translations.of(context).strMoreInfo,
                                    getProportionalScreenWidth(18),
                                Constants.blueColor,
                                    "Inter",
                                    FontWeight.w700)),
                        WidgetUtils().sizeBoxHeight(16),
                        Container(
                          padding: EdgeInsets.only(
                              left: getProportionalScreenWidth(16),
                              right: getProportionalScreenWidth(16)),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 4,
                            children: List.generate(
                              4,
                              (index) {
                                return cardView(index);
                              },
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
            ),
            onRefresh: _pullRefresh);
  }

  Widget cardView(int index) {
    var titleList = [Translations.of(context).strAmenities, Translations.of(context).strTermsOfUse, Translations.of(context).strAboutUs,Translations.of(context).strFAQs];
    String title = "";
    String imageName = "";
    switch (index) {
      case 0:
        title = titleList[0];
        imageName = 'assets/images/img_privacy_policy.png';
        break;
      case 1:
        title = titleList[1];
        imageName = 'assets/images/ic_terms_of_use.png';
        break;
      case 2:
        title = titleList[2];
        imageName = 'assets/images/ic_about_us.png';
        break;
      case 3:
        title = titleList[3];
        imageName = 'assets/images/img_faq.png';
        break;
    }
    return InkWell(
      onTap: () {
        switch (index) {
          case 0:
            WidgetUtils().push(
                context,
                () => AmenitiesScreen(
                      objHotelData: _hotelData,
                    ));
            break;
          case 1:
            WidgetUtils().push(
                context,
                () => TermsOfUse(
                      strTitle: title,
                      strType: "terms",
                    ));
            break;
          case 2:
            WidgetUtils().push(
                context,
                () => TermsOfUse(
                      strTitle: title,
                      strType: "aboutAs",
                    ));
            break;
          case 3:
            WidgetUtils().push(
                context,
                () => FAQs(
                      strTitle: title,
                    ));
            break;
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          padding: EdgeInsets.all(4),
          height: 70,
          width: getProportionalScreenWidth(70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imageName,
                height: 35,
                width: 35,
              ),
              WidgetUtils().sizeBoxHeight(5),
              WidgetUtils().simpleTextViewWithGivenFontSize(
                  title,
                  getProportionalScreenWidth(9),
                  Constants.appDarkBlueTextColor,
                  "Inter",
                  FontWeight.w500,
                  txtAlign: TextAlign.center)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    wsCurrentStay();
  }

  var imgCurrentIndex = 0;

  Widget _currentStayView() {
    final CarouselController _carouselController = CarouselController();
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Card(
          margin: EdgeInsets.only(top: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: [
                  (_hotelData.hotelImages?.isEmpty == true ||
                          (_hotelData.hotelImages!.length > 0 &&
                              _hotelData.hotelImages![0].isEmpty))
                      ? Container(
                          padding: EdgeInsets.only(top: 8),
                      height: SizeConfig.screenHeight * 0.30,
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/img_placeholder_logo.png',
                          ))
                      : Container(
                        child: CarouselSlider(
                            options: CarouselOptions(
                                viewportFraction: 1,
                                height: SizeConfig.screenHeight * 0.30,
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
                            items: _hotelData.hotelImages!
                                .map((item) => Container(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(15.0),
                                            topLeft: Radius.circular(15.0)),
                                        child: Center(
                                            child: CachedNetworkImage(
                                          width: SizeConfig.screenWidth,
                                          height: SizeConfig.screenHeight * 0.35,
                                          fit: BoxFit.cover,
                                          imageUrl: item,
                                          placeholder: (context, url) => Container(
                                            color: Constants.appAquaPlaceholderColor,
                                            child: Image.asset(
                                              'assets/images/img_placeholder_logo.png',
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            color: Constants.appAquaPlaceholderColor,
                                            child: Image.asset(
                                              'assets/images/img_placeholder_logo.png',
                                            ),
                                          ),
                                        )),
                                      ),
                                    ))
                                .toList(),
                          ),
                      ),
                  Positioned(
                    top: SizeConfig.screenHeight * 0.23,
                    right: SizeConfig.screenWidth * 0,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.all(Radius.circular(6.0)),
                          color: Colors.white.withOpacity(0.5),
                        ),
                        alignment: Alignment.center,
                        height: SizeConfig.screenHeight * 0.045,
                        width: SizeConfig.screenWidth * 0.16,
                        child: WidgetUtils().simpleTextViewWithGivenFontSize(
                            '${imgCurrentIndex + 1}/${_hotelData.hotelImages!.length}',
                            getProportionalScreenWidth(14),
                            Colors.white,
                            "Inter",
                            FontWeight.w600,
                            txtAlign: TextAlign.center),
                      ),
                    ),
                  ),
                ],
              ),
              WidgetUtils().sizeBoxHeight(18),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 20),
                      child: ReadMoreText(
                        '${_hotelData.hotelDescription ?? ""}',
                        trimLines: 2,
                        colorClickableText: Constants.appBarBlueColor,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: Translations.of(context).strReadMore,
                        trimExpandedText: Translations.of(context).strLess,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter",
                            fontSize: getProportionalScreenWidth(14),
                            color: Constants.appDarkBlueTextColor),
                      ),
                    ),

                    Visibility(
                      visible: _objOwnerMessageModel != null,
                      child: Container(
                        padding: EdgeInsets.only(right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WidgetUtils().sizeBoxHeight(15),

                            MarqueeWidget(
                              child: HtmlWidget(
                                  _objOwnerMessageModel?.description ?? ""),
                              animationDuration: Duration(seconds: 15),
                              //backDuration: Duration(milliseconds: 5000),
                              //pauseDuration: Duration(milliseconds: 2500),
                            ),

                            //HtmlWidget(_objOwnerMessageModel?.description ?? ""),

                            WidgetUtils().sizeBoxHeight(5),
                          ],
                        ),
                      ),
                    ),

                    WidgetUtils().sizeBoxHeight(15),

                    GestureDetector(
                      onTap: () {
                        WidgetUtils().push(context, () => RateHotel());
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.only(bottomRight: Radius.circular(15)),
                              color: Constants.appBlueColor,
                              /*gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: <Color>[
                                    Constants.gradient1,
                                    Constants.gradient2,
                                    Constants.gradient3,
                                    Constants.gradient4,
                                  ])*/),

                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          width: getProportionalScreenWidth(80),
                          alignment: Alignment.center,
                          child: colorizedTextViewWhite(Translations.of(context).strRateMe),
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          child:
          Container(
            padding: EdgeInsets.only(bottom: 2,top: 2),
            margin: EdgeInsets.only(bottom: 10),
            alignment: Alignment.center,
            width: SizeConfig.screenWidth * 0.6,
            decoration: BoxDecoration(
                borderRadius:
                BorderRadius.all(Radius.circular(0)),
                color: Constants.blueColor,
                /*gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Constants.gradient1,
                      Constants.gradient2,
                      Constants.gradient3,
                      Constants.gradient4,
                    ])*/),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: WidgetUtils().simpleTextViewWithGivenFontSize(DateUtilss.dateToString(
                      DateUtilss.stringToDate(
                          _hotelData.checkInTime!,
                          format:
                          AppDateFormat.serverDateTimeFormat1)!,
                      format: AppDateFormat
                          .dateMonthYearWithDashesFormatNew), 14, Colors.white, "Inter",FontWeight.w500),

                ),

                WidgetUtils().sizeBoxWidth(5),

                WidgetUtils().simpleTextViewWithGivenFontSize("-", 14, Colors.white, "Inter",FontWeight.w500),
                WidgetUtils().sizeBoxWidth(5),

                Container(
                  child:WidgetUtils().simpleTextViewWithGivenFontSize(DateUtilss.dateToString(
                      DateUtilss.stringToDate(
                          _hotelData.checkOutTime!,
                          format:
                          AppDateFormat.serverDateTimeFormat1)!,
                      format: AppDateFormat
                          .dateMonthYearWithDashesFormatNew), 14, Colors.white, "Inter",FontWeight.w500),
                ) ],
            ),
          ),
        )
      ],
    );
  }

  Widget _premiumServicesView() {
    return InkWell(
      onTap: () {
        WidgetUtils().push(
            context,
            () => PremiumServiceDetail(
                  objPremiumServices: _objPremiumServicesRowModel[0],
                ));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Colors.white,
        child: Stack(
          children: [
            _objPremiumServicesRowModel.isNotEmpty
                ? CachedNetworkImage(
                    width: SizeConfig.screenWidth - 40,
                    height: SizeConfig.screenHeight * 0.20,
                    fit: BoxFit.cover,
                    imageUrl: _objPremiumServicesRowModel[0].images != null
                        ? '${_objPremiumServicesRowModel[0].images![0].trim()}'
                        : "",
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
                  )
                : Container(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenHeight * 0.20,
                  ),
            Container(
              color: Colors.black.withAlpha(85),
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight * 0.20,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                              child:
                                  WidgetUtils().simpleTextViewWithGivenFontSize(
                            _objPremiumServicesRowModel.isNotEmpty
                                ? '${_objPremiumServicesRowModel[0].name ?? ""}'
                                : "",
                            getProportionalScreenWidth(16),
                            Colors.white,
                            "Inter",
                            FontWeight.bold,
                          ))),
                      WidgetUtils().buttonSimpleText(
                          Translations.of(context).strBookNow.toUpperCase(),
                          "Inter",
                          getProportionalScreenWidth(14),
                          Colors.white, () {
                        WidgetUtils().push(
                            context,
                            () => PremiumServiceDetail(
                                  objPremiumServices:
                                      _objPremiumServicesRowModel[0],
                                ));
                      }, FontWeight.w700,
                          bgColor: Constants.appBlueColor,
                          isRoundedCorners: true,
                          cornerRadius: 18.0)
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _ourServicesView() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _objMainServicesRowModel.length,
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
                    imageUrl: _objMainServicesRowModel[index].image ?? "",
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
                          '${_objMainServicesRowModel[index].name ?? ""}',
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
              index == 2
                  ? WidgetUtils().push(
                      context,
                      () => DiningOptions(
                            isFromDashboard: true,
                          ))
                  : index == 3
                      ? WidgetUtils().push(context, () => MyDirectory())
                      : index == 4
                          ? WidgetUtils().push(
                              context,
                              () => PremiumServices(
                                  isFromDashboard: true,
                                  objPremiumServices:
                                      _objPremiumServicesRowModel,
                                  objUserModel: userModel))
                          : index == 5
                  ? WidgetUtils().push(
                  context,
                      () => TermsOfUse(
                    strTitle: Translations.of(context).strNotes,strType: "note",
                  )) : WidgetUtils().push(
                              context,
                              () => ServicesList(
                                  objMainServicesRowModel:
                                      _objMainServicesRowModel[index]));
            });
      },
    );
  }

  Future<void> wsCurrentStay() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    String strFullname =
        '${userModel.firstName!.replaceAll(" ", "")} ${userModel.lastName}';
    List<String> nameparts = strFullname.split(" ");

    String initials = nameparts[0].characters.first.toUpperCase() +
        nameparts[1].characters.first.toUpperCase();

    Constants.userInitials = initials;

    setState(() {
      _isShowLoader = true;
    });
    var map = Map();
    map["hotel_id"] = userModel.hotelId;

    APICall(context).getCurrentStay(map, this);
  }

  Future<void> wsGetOwnerMessage() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    setState(() {
      _isShowLoader = true;
    });
    var map = Map();
    map["hotel_id"] = userModel.hotelId;

    APICall(context).getOwnerMessageApi(map, this);
  }

  Future<void> wsOurPremiumServices() async {
    setState(() {
      _isShowLoader = true;
    });

    var queryParameters = {
      'page': '1',
      'limits': '50',
    };
    var map = Map();
    map["hotel_id"] = userModel.hotelId;

    APICall(context).getPremiumServices(map, queryParameters, this);
  }

  Future<void> wsOurMainServices() async {
    setState(() {
      _isShowLoader = true;
    });

    var queryParameters = {
      'page': '1',
      'limits': '20',
    };

    APICall(context).getOurServices(Map(), queryParameters, this);
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
    if (requestCode == API.requestCurrentUser && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var hotelModel = HotelModel.fromJson(response);

      if (hotelModel.code! == 200) {
        setState(() {
          _hotelData = hotelModel.data!;
        });
      } else if (hotelModel.code! == 401) {
        MyPrefs.clearPref();
        Constants.token = null;

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()),
            (Route<dynamic> route) => false);
      } else {
        WidgetUtils().customToastMsg(hotelModel.msg!);
      }

      wsOurPremiumServices();
      wsOurMainServices();
      wsGetOwnerMessage();
    } else if (requestCode == API.requestOurPremiumServices && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var ourPremiumServicesModel = SubServicesModel.fromJson(response);

      if (ourPremiumServicesModel.code! == 200) {
        setState(() {
          _objPremiumServicesRowModel = ourPremiumServicesModel.data!.rows!;
        });
      } else if (ourPremiumServicesModel.code! == 400) {
        WidgetUtils().customToastMsg(
            ourPremiumServicesModel.data!.errors!.serviceId![0]);
      } else {
        WidgetUtils().customToastMsg(ourPremiumServicesModel.msg!);
      }
    } else if (requestCode == API.requestOurMainServices && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var ourMainServicesModel = MainServicesModel.fromJson(response);

      if (ourMainServicesModel.code! == 200) {
        setState(() {
          _objMainServicesRowModel = ourMainServicesModel.data!.rows!;
        });
      } else {
        WidgetUtils().customToastMsg(ourMainServicesModel.msg!);
      }
    } else if (requestCode == API.requestGetOwnerMessage && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var responseModel = GetOwnerMessageResponseModel.fromJson(response);

      if (responseModel.code! == 200) {
        setState(() {
          _objOwnerMessageModel = responseModel.data;
        });
      } else {
        // WidgetUtils().customToastMsg(responseModel.msg!);
      }
    }
  }

  Widget colorizedTextViewWhite(String text) {
    const colorizeColors = [
      Colors.white,
      Colors.white,
    ];

    const colorizeTextStyle = TextStyle(
      fontSize: 14.0,
      fontFamily: 'Inter',
    );

    return SizedBox(
      child: AnimatedTextKit(
        animatedTexts: [
          ColorizeAnimatedText(
            text,
            textStyle: colorizeTextStyle,
            colors: colorizeColors,
          ),
        ],
        isRepeatingAnimation: true,
        repeatForever: true,
        onTap: () {
          WidgetUtils().push(context, () => RateHotel());
        },
      ),
    );
  }
}
