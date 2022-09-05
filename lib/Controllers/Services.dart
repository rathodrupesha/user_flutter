import 'package:flutter/material.dart';
import 'package:hamrostay/Controllers/ServicesDetail.dart';
import 'package:hamrostay/Models/MainServicesModel.dart';
import 'package:hamrostay/Models/SubServicesModel.dart';
import 'package:hamrostay/Utils/API.dart';
import 'package:hamrostay/Utils/APICall.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';

import '../localization/localization.dart';

class ServicesList extends StatefulWidget {
  final MainServicesRows objMainServicesRowModel;

  ServicesList({Key? key, required this.objMainServicesRowModel})
      : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<ServicesList>
    implements OnResponseCallback {
  var _isShowLoader = false;
  List<SubServicesRows> _objSubServicesRowModel = [];

  @override
  void initState() {
    super.initState();
    wsOurSubServices();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        appBar: WidgetUtils().customAppBar(
            context,
            widget.objMainServicesRowModel.name ?? "",
            'assets/images/btn_back.png',
            Colors.white, () {
          Navigator.of(context).pop();
        }, imgColor: Colors.white),
        body: Material(
          child: SafeArea(
            top: false,
            bottom: false,
            left: false,
            child: _objSubServicesRowModel.isNotEmpty
                ? _getBodyView(context)
                : WidgetUtils().noDataFoundText(
                    _isShowLoader,
                Translations.of(context).strNoDataFound,
                    150,
                    150),
          ),
        ));
  }

  Widget _getBodyView(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Constants.appLightBackgroundColor,
          child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: ListView.builder(
                itemCount: _objSubServicesRowModel.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      WidgetUtils().buttonSettingsWidget(
                          context, _objSubServicesRowModel[index].name ?? "",
                          () {
                        WidgetUtils().push(
                            context,
                            () => ServicesDetail(
                                  objMainServicesRowModel:
                                      widget.objMainServicesRowModel,
                                  objSubServicesRowModel:
                                      _objSubServicesRowModel[index],
                                ));
                      }, ''),
                      WidgetUtils().sizeBoxHeight(15),
                    ],
                  );
                },
              )),
        ),
        // Visibility(
        //     child: Center(
        //         child: CircularProgressIndicator(
        //       strokeWidth: 5.0,
        //       backgroundColor: Constants.appSepratorColor,
        //       color: Constants.appAquaTextColor,
        //     )),
        //     visible: _isShowLoader)
      ],
    );
  }

  Future<void> wsOurSubServices() async {
    setState(() {
      _isShowLoader = true;
    });

    var queryParameters = {
      'page': '',
      'limits': '',
    };
    var userModel = await WidgetUtils.fetchUserDetailsFromPreference();

    var map = Map();
    map["hotel_id"] = userModel!.hotelId;

    map["service_id"] = widget.objMainServicesRowModel.id;

    APICall(context).getSubServices(map, queryParameters, this);
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
    if (requestCode == API.requestOurSubServices && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var ourSubServicesModel = SubServicesModel.fromJson(response);

      if (ourSubServicesModel.code! == 200) {
        setState(() {
          _objSubServicesRowModel = ourSubServicesModel.data!.rows!;
        });
      } else if (ourSubServicesModel.code! == 400) {
        // WidgetUtils()
        //     .customToastMsg(ourSubServicesModel.data!.errors!.serviceId![0]);
      } else {
        WidgetUtils().customToastMsg(ourSubServicesModel.msg!);
      }
    }
  }
}
