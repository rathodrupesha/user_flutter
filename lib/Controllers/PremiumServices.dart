import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hamrostay/Controllers/PremiumServiceDetail.dart';
import 'package:hamrostay/Models/SubServicesModel.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';
import 'package:hamrostay/localization/localization.dart';

import '../Models/UserModel.dart';
import '../Utils/API.dart';
import '../Utils/APICall.dart';

class PremiumServices extends StatefulWidget {
  PremiumServices(
      {Key? key,
      this.isFromDashboard,
      required this.objPremiumServices,
      this.objUserModel})
      : super(key: key);

  @override
  _PremiumServicesState createState() => _PremiumServicesState();
  final isFromDashboard;
  final objUserModel;

  List<SubServicesRows> objPremiumServices;
}

class _PremiumServicesState extends State<PremiumServices> implements OnResponseCallback {
  var _isShowLoader = false;
  var userModel = UserData();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        appBar: widget.isFromDashboard
            ? WidgetUtils().customAppBar(
                context,
                Translations.of(context).strPremiumServices,
                'assets/images/btn_back.png',
                Colors.white,
                () {
                  Navigator.of(context).pop();
                },
                imgColor: Colors.white,
                //isRightControl: true,
                //rightImgName: widget.objUserModel.profileImage ?? "",
                onRightBtnPress: () {
                  print('Notification image clicked');
                })
            : null,
        body: Material(
          child: SafeArea(
            top: false,
            bottom: false,
            left: false,
            child: ( widget.objPremiumServices.isNotEmpty) ? RefreshIndicator(onRefresh: () => wsOurPremiumServices(),child: _getBodyView()) :  Container(
                height: SizeConfig.screenHeight * 0.75,
                child: WidgetUtils().noDataFoundText(
                    false, Translations.of(context).strNoDataFound, 150, 150)),
          ),
        ));
  }

  Widget _getBodyView() {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _premiumServicesView(),
            WidgetUtils().sizeBoxHeight(20),
            ( widget.objPremiumServices.isNotEmpty &&  widget.objPremiumServices.length > 1) ? WidgetUtils().simpleTextViewWithGivenFontSize(
                Translations.of(context).strExploreOurPremiumServices,
                getProportionalScreenWidth(18),
                Constants.blueColor,
                "Inter",
                FontWeight.w700) : Container(),
            WidgetUtils().sizeBoxHeight(22),
            _ourServicesView()
          ],
        ),
      ),
    );
  }

  Widget _premiumServicesView() {
    return GestureDetector(
      onTap: () {
        WidgetUtils().push(
            context,
            () => PremiumServiceDetail(
                  objPremiumServices: widget.objPremiumServices[0],
                ));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Colors.white,
        child: Stack(
          children: [
            CachedNetworkImage(
              width: SizeConfig.screenWidth - 40,
              height: SizeConfig.screenWidth * 0.45,
              fit: BoxFit.cover,
              imageUrl: widget.objPremiumServices[0].images!.isNotEmpty
                  ? '${widget.objPremiumServices[0].images![0].trim()}'
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
            ),
            Container(
              color: Colors.black.withAlpha(85),
              width: SizeConfig.screenWidth - 40,
              height: SizeConfig.screenWidth * 0.45,
              child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20,bottom: 20),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: WidgetUtils()
                                    .simpleTextViewWithGivenFontSize(
                                  widget.objPremiumServices.isNotEmpty
                                      ? '${widget.objPremiumServices[0].name ?? ""}'
                                      : "",
                                  getProportionalScreenWidth(16),
                                  Colors.white,
                                  "Inter",
                                  FontWeight.bold,
                                ))),
                        WidgetUtils().sizeBoxWidth(10),
                      ])
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
      itemCount: widget.objPremiumServices.length - 1,
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
                    fit: BoxFit.cover,
                    imageUrl: widget.objPremiumServices.isNotEmpty
                        ? '${widget.objPremiumServices[index + 1].images![0]}'
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
                  ),
                  Container(
                      width: ((SizeConfig.screenWidth - 60) * 0.5),
                      height: ((SizeConfig.screenWidth - 60) * 0.17),
                    alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      child: WidgetUtils()
                          .simpleTextViewWithGivenFontSize(
                              '${widget.objPremiumServices[index + 1].name}',
                              getProportionalScreenWidth(14),
                              Constants.appDarkBlueTextColor,
                              "Inter",
                              FontWeight.w500,
                              maxLine: 2,
                              txtOverflow: TextOverflow.ellipsis,
                              txtAlign: TextAlign.center))
                ],
              ),
            ),
            onTap: () {
              WidgetUtils().push(
                  context,
                  () => PremiumServiceDetail(
                        objPremiumServices:
                            widget.objPremiumServices[index + 1],
                      ));
            });
      },
    );
  }

  Future<void> wsOurPremiumServices() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

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

  @override
  void onResponseError(String message, int requestCode) {
    setState(() {
      _isShowLoader = false;
    });
    WidgetUtils().customToastMsg(message);
  }

  @override
  void onResponseReceived(response, int requestCode) {
    if (requestCode == API.requestOurPremiumServices && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var ourPremiumServicesModel = SubServicesModel.fromJson(response);

      if (ourPremiumServicesModel.code! == 200) {
        setState(() {
          widget.objPremiumServices = ourPremiumServicesModel.data!.rows!;
        });
      } else if (ourPremiumServicesModel.code! == 400) {
        WidgetUtils().customToastMsg(
            ourPremiumServicesModel.data!.errors!.serviceId![0]);
      } else {
        WidgetUtils().customToastMsg(ourPremiumServicesModel.msg!);
      }
    }
  }
}

