import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hamrostay/Controllers/RequestDetail.dart';
import 'package:hamrostay/Models/MyRequestListModel.dart';
import 'package:hamrostay/Models/UserModel.dart';
import 'package:hamrostay/Utils/API.dart';
import 'package:hamrostay/Utils/APICall.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';

import '../localization/localization.dart';

class MyRequests extends StatefulWidget {
  MyRequests({Key? key, this.isFromDashboard}) : super(key: key);

  @override
  _MyRequestsState createState() => _MyRequestsState();
  final isFromDashboard;
}

class _MyRequestsState extends State<MyRequests> implements OnResponseCallback {
  var userModel = UserData();
  var _isShowLoader = false;
  List<MyRequestData> _objMyRequestData = [];
  int selectedItemIndex = 0;

  @override
  void initState() {
    super.initState();
    wsGetAllRequestList();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        backgroundColor: Constants.appLightBackgroundColor,
        appBar: widget.isFromDashboard
            ? WidgetUtils().customAppBar(
                context,
                Translations.of(context).strMyRequest,
                'assets/images/btn_back.png',
                Colors.white,
                () {
                  Navigator.of(context).pop();
                },
                imgColor: Colors.white,
              )
            : null,
        body: Material(
          child: SafeArea(
            top: false,
            bottom: false,
            left: false,
            child:  _getBodyView(context),
          ),
        ));
  }

  Widget _getBodyView(BuildContext context) {
    return RefreshIndicator(
      child: Container(
        color: Constants.appLightBackgroundColor,
        child: DefaultTabController(
          initialIndex: 0,
          length: 4,
          child: Column(
            children: [
              TabBar(
                labelColor: Constants.blueColor,
                indicatorColor: Constants.appBlueColor,
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontFamily: "Inter",
                  color: Constants.blueColor,
                  fontWeight: FontWeight.w500
                ),
                onTap: (index) {
                  selectedItemIndex = index;
                  setState(() {});
                },
                tabs: [
                  Tab(
                    text: Translations.of(context).tabPending,
                  ),
                  Tab(
                    text: Translations.of(context).tabActive,
                  ),
                  Tab(
                    text: Translations.of(context).tabCompleted,
                  ),
                  Tab(
                    text: Translations.of(context).tabRejected,
                  )
                ],
              ),
              if (selectedItemIndex == 0) ...[
                // Active
                myRequestListView(_objMyRequestData
                    .where((element) =>
                        (element.status == Constants.serviceStatusPending))
                    .toList())
              ] else if (selectedItemIndex == 1) ...[
                // In Active
                myRequestListView(_objMyRequestData
                    .where((element) =>
                        (element.status == Constants.serviceStatusInProgress) || (element.status == Constants.serviceStatusAccepted))
                    .toList())
              ] else if (selectedItemIndex == 2) ...[
                // In Active
                myRequestListView(_objMyRequestData.where((element) =>
                (element.status == Constants.serviceStatusCompleted))
                    .toList())
              ] else ...[
                // Completed
                myRequestListView(_objMyRequestData.where((element) =>
                        (element.status == Constants.serviceStatusRejected) ||
                        (element.status == Constants.serviceStatusCanceled))
                    .toList())
              ]
            ],
          ),
        ),
      ),
      onRefresh: _pullRefresh,
    );
  }

  Future<void> _pullRefresh() async {
    wsGetAllRequestList();
  }

  Widget myRequestListView(List filteredList) {
    return Expanded(
      child: (filteredList.isNotEmpty) ? ListView.separated(
        //padding: const EdgeInsets.only(top:45.0,left: 16.0,right: 16.0,bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              WidgetUtils()
                  .push(context, () => RequestDetail(filteredList[index]));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      (filteredList[index].orderComplaints == null)
                          ? _acceptedView(filteredList[index])
                          : _complaintView(filteredList[index]),
                      WidgetUtils().sizeBoxHeight(6),
                      WidgetUtils().simpleTextViewWithGivenFontSize(
                          filteredList[index].name ?? "",
                          getProportionalScreenWidth(16),
                          Constants.appDarkBlueTextColor,
                          "Inter",
                          FontWeight.w500,
                          txtAlign: TextAlign.left),
                      WidgetUtils().sizeBoxHeight(5),
                      WidgetUtils().simpleTextViewWithGivenFontSize(
                          Translations.of(context).strOrderIdHash + filteredList[index].orderId!,
                          getProportionalScreenWidth(12),
                          Constants.appDarkBlueTextColor,
                          "Inter",
                          FontWeight.w400,
                          txtAlign: TextAlign.left)
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 15,
          );
        },
      ) : WidgetUtils()
          .noDataFoundText(_isShowLoader, Translations.of(context).strNoDataFound, 150, 150),
    );
  }

  Widget _acceptedView(MyRequestData objMyRequestData) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
              color: objMyRequestData.currentStatusColor,
              borderRadius: BorderRadius.all(Radius.circular(4))),
        ),
        WidgetUtils().sizeBoxWidth(5),
        WidgetUtils().simpleTextViewWithGivenFontSize(
            objMyRequestData.currentStatus.toString(),
            getProportionalScreenWidth(12),
            objMyRequestData.currentStatusColor,
            "Inter",
            FontWeight.w600,
            txtAlign: TextAlign.left)
      ],
    );
  }

  Widget _complaintView(MyRequestData objMyRequestData) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
              color: objMyRequestData.currentStatusColor,
              borderRadius: BorderRadius.all(Radius.circular(4))),
        ),
        WidgetUtils().sizeBoxWidth(5),
        WidgetUtils().simpleTextViewWithGivenFontSize(
            objMyRequestData.currentStatus.toString(),
            getProportionalScreenWidth(12),
            objMyRequestData.currentStatusColor,
            "Inter",
            FontWeight.w600,
            txtAlign: TextAlign.left),
        WidgetUtils().sizeBoxWidth(15),
        Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
              color: objMyRequestData.orderComplaints!.getComplaintColor,
              borderRadius: BorderRadius.all(Radius.circular(4))),
        ),
        WidgetUtils().sizeBoxWidth(5),
        WidgetUtils().simpleTextViewWithGivenFontSize(
            objMyRequestData.orderComplaints!.getComplaintStatus.toString(),
            getProportionalScreenWidth(12),
            objMyRequestData.orderComplaints!.getComplaintColor,
            "Inter",
            FontWeight.w600,
            txtAlign: TextAlign.left)
      ],
    );
  }

  Future<void> wsGetAllRequestList() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    setState(() {
      _isShowLoader = true;
    });

    var map = Map();
    map["hotel_id"] = userModel.hotelId;

    APICall(context).getAllRequestApi(map, this);
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
    if (requestCode == API.requestGetAllRequestList && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var myRequestListResponse = MyRequestListModel.fromJson(response);

      if (myRequestListResponse.code! == 200) {
        setState(() {
          _objMyRequestData = myRequestListResponse.data!;
        });
      } else {
        WidgetUtils().customToastMsg(myRequestListResponse.msg!);
      }
    }
  }
}
