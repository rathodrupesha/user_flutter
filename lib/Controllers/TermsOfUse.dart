import 'package:flutter/material.dart';
import 'package:hamrostay/Models/CMSModel.dart';
import 'package:hamrostay/Models/UserModel.dart';
import 'package:hamrostay/Utils/API.dart';
import 'package:hamrostay/Utils/APICall.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../Models/NotesResponseMdel.dart';
import '../localization/localization.dart';

class TermsOfUse extends StatefulWidget {
  TermsOfUse({Key? key, this.strTitle, this.strType}) : super(key: key);

  @override
  _TermsOfUseState createState() => _TermsOfUseState();
  final strTitle;
  final strType;
}

class _TermsOfUseState extends State<TermsOfUse> implements OnResponseCallback {
  UserData? userData;
  String? cmsData;
  var isShowLoader = false;

  @override
  void initState() {
    super.initState();
    WidgetUtils.fetchUserDetailsFromPreference().then((value) {
      userData = value;

      if(widget.strType == "note"){
        wsGetNoted();
      }else {
        wsGetCMSDetails();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        appBar: WidgetUtils().customAppBar(context, widget.strTitle,
            'assets/images/btn_back.png', Colors.white, () {
          Navigator.of(context).pop();
        }, imgColor: Colors.white),
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
    return (cmsData != null)
        ? ListView(
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16,bottom: 16),
                  child: HtmlWidget(cmsData!))
            ],
          )
        : Center(
            child: WidgetUtils().noDataFoundText(isShowLoader, Translations.of(context).strNoDataFound, 150, 150));
  }

  void wsGetCMSDetails() async {
    var map = Map();
    map['type'] = widget.strType;
    map['hotel_id'] = userData?.hotelId ?? 0;
    map['cms_for'] = "customer";
    setState(() {
      isShowLoader = true;
    });

    APICall(context).getCms(map, this);
  }

  void wsGetNoted() async {
    var map = Map();
    map['hotel_id'] = userData?.hotelId ?? 0;
    setState(() {
      isShowLoader = true;
    });

    APICall(context).getNotesApi(map, this);
  }

  @override
  void onResponseError(String message, int requestCode) {
    setState(() {
      isShowLoader = false;
    });
    WidgetUtils().customToastMsg(message);
  }

  @override
  void onResponseReceived(response, int requestCode) {
    if (requestCode == API.requestCms && this.mounted) {
      setState(() {
        isShowLoader = false;
      });

      var cmsResponse = CMSModels.fromJson(response);

      if (cmsResponse.code! == 200) {
        if (cmsResponse.data != null &&
            cmsResponse.data?.content != null &&
            cmsResponse.data!.content!.isNotEmpty) {
          setState(() {
            cmsData = cmsResponse.data?.content;
          });
        }
      } else {
        WidgetUtils().customToastMsg(cmsResponse.msg!);
      }
    }else if(requestCode == API.getNotes && this.mounted){
      setState(() {
        isShowLoader = false;
      });

      var notesResponse = NotesResponseModel.fromJson(response);

      if (notesResponse.code! == 200) {
        if (notesResponse.data != null && notesResponse.data!.rows != null && notesResponse.data!.rows![0].notes != null && notesResponse.data!.rows![0].notes!.isNotEmpty ) {
          setState(() {
            cmsData = notesResponse.data!.rows![0].notes!;
          });
        }
      } else {
        WidgetUtils().customToastMsg(notesResponse.msg!);
      }
    }
  }
}
