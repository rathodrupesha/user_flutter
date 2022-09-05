import 'package:flutter/material.dart';
import 'package:hamrostay/Models/MyRequestListModel.dart';
import 'package:hamrostay/Models/NotificationListModel.dart';
import 'package:hamrostay/Models/UserModel.dart';
import 'package:hamrostay/Utils/API.dart';
import 'package:hamrostay/Utils/APICall.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/TimeAgo.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';

import '../localization/localization.dart';

class Notifications extends StatefulWidget {
  Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> implements OnResponseCallback{
  var _isShowLoader = false;
  List<NotificationRow> _objNotificationList =[];
  var userModel = UserData();

  @override
  void initState() {
    super.initState();
    wsNotificationList();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        body: Material(
          child: SafeArea(
            top: false,
            bottom: false,
            left: false,
            child: (_objNotificationList.isEmpty)
                ? Container(
                height: SizeConfig.screenHeight * 0.75,
                child: WidgetUtils().noDataFoundText(
                    _isShowLoader, Translations.of(context).strNoDataFound, 150, 150))
                :_getBodyView(),
          ),
        ));
  }

  Widget _getBodyView() {
    return RefreshIndicator(
        child:ListView.builder(
      itemCount: _objNotificationList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(
                              text: _objNotificationList[index].message,
                              style: TextStyle(
                                  fontSize: getProportionalScreenWidth(14),
                                  fontWeight: FontWeight.w400,
                                  color: Constants.appDarkBlueTextColor,
                                  fontFamily: "Inter"),
                            ),
                            /*TextSpan(
                              text: '#554455',
                              style: TextStyle(
                                  fontSize: getProportionalScreenWidth(14),
                                  fontWeight: FontWeight.w700,
                                  color: Constants.appDarkBlueTextColor,
                                  fontFamily: "Inter"),
                            ),
                            TextSpan(
                              text: " has been placed and received within 30 minutes",
                              style: TextStyle(
                                  fontSize: getProportionalScreenWidth(14),
                                  fontWeight: FontWeight.w400,
                                  color: Constants.appDarkBlueTextColor,
                                  fontFamily: "Inter"),
                            ),*/
                          ],
                        ),
                      ),
                      WidgetUtils().sizeBoxHeight(15),
                      WidgetUtils().simpleTextViewWithGivenFontSize(
                          TimeAgo.timeAgoSinceDate(_objNotificationList[index].createdAt ?? DateTime.now().toString()),
                          getProportionalScreenWidth(12),
                          Constants.appLightBlueTextColor,
                          "Inter",
                          FontWeight.w400)
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),onRefresh: _pullRefresh);
  }

  Future<void> _pullRefresh() async {
    wsNotificationList();
  }


  Future<void> wsNotificationList() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;


    setState(() {
      _isShowLoader = true;
    });

    var map = Map();
    map["hotel_id"] = userModel.hotelId;

    APICall(context).getNotificationListApi(map, this);
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
    if (requestCode == API.requestNotificationList && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var notificationResponse = NotificationListModel.fromJson(response);

      if (notificationResponse.code! == 200) {
        setState(() {
          _objNotificationList = notificationResponse.data!.rows!;
        });
      } else {
        WidgetUtils().customToastMsg(notificationResponse.msg!);
      }
    }
  }
}
