import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hamrostay/Controllers/Dashboard.dart';
import 'package:hamrostay/Controllers/StoryView.dart';
import 'package:hamrostay/Models/GetAnnounceCategoryModel.dart';
import 'package:hamrostay/Models/UserModel.dart';
import 'package:hamrostay/Utils/API.dart';
import 'package:hamrostay/Utils/APICall.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/MyPrefs.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/Validations.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';
import 'package:hamrostay/localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/device_utils.dart';
import '../Utils/firebase_cloud_messaging.dart';
import 'ForgotPassword.dart';

class AnnouncementCategoryPage extends StatefulWidget {
  AnnouncementCategoryPage({Key? key}) : super(key: key);

  @override
  _AnnouncementCategoryPageState createState() => _AnnouncementCategoryPageState();
}

class _AnnouncementCategoryPageState extends State<AnnouncementCategoryPage> implements OnResponseCallback {
  var _isShowLoader = false;
  List<AnnouncementCategoryRows> objAnnouncementCategory = [];

  @override
  void initState() {
    super.initState();
    wsGetAnnouncementCategory();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        body: Material(
      child: SafeArea(
        top: false,
        bottom: false,
        child: _getBodyView(),
      ),
    ));
  }

  Widget _getBodyView() {
    return Stack(
      children: <Widget>[
        Container(
          color: Constants.appSepratorColor,
         /* decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Constants.gradient4,
                    Constants.gradient3,
                    Constants.gradient2,
                    Constants.gradient1,
                  ])),*/
          width: double.infinity,
          child:  Container(
              padding: EdgeInsets.only(
                  top: getProportionalScreenWidth(16),
                  left: getProportionalScreenWidth(16),
                  right: getProportionalScreenWidth(16)),
              child: _ourServicesView()),
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

  Widget _ourServicesView() {
    return GridView.builder(
      itemCount: objAnnouncementCategory.length,
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
                    imageUrl: objAnnouncementCategory[index].ancCatImage ?? "",
                    placeholder: (context, url) => Container(
                      color: Constants.appAquaPlaceholderColor,
                      child: Image.asset(
                        'assets/images/img_placeholder_logo.png'
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
                          '${objAnnouncementCategory[index].categoryName ?? ""}',
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
              WidgetUtils().push(context, () => MoreStories(categoryId:objAnnouncementCategory[index].id.toString(),categoryName: objAnnouncementCategory[index].categoryName.toString(),));
            });
      },
    );
  }


  void wsDeviceInfo(int id) {
    FocusScope.of(context).requestFocus(FocusNode());

    var map = Map();

    map["device_id"] = DeviceUtil().deviceId;
    map["device_type"] = DeviceUtil().deviceType;
    map["device_token"] = FireBaseCloudMessagingWrapper().fcmToken;
    map["id"] = id.toString();

    APICall(context).deviceInfo(map, this);
  }

  Future<void> wsGetAnnouncementCategory() async {
    setState(() {
      _isShowLoader = true;
    });

    APICall(context).getAnnouncementCategory(Map(), this);
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
    if (requestCode == API.requestAnnouncementCategory && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });
      var announcementCategory = GetAnnouncementCategoryModel.fromJson(response);

      if (announcementCategory.code! == 200 && announcementCategory.data != null) {

        objAnnouncementCategory = announcementCategory.data!.rows!;

      } else {
        WidgetUtils().customToastMsg(announcementCategory.msg!);
      }
    }
  }
}
