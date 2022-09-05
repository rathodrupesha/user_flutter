import 'package:flutter/material.dart';
import 'package:hamrostay/Models/FAQModel.dart';
import 'package:hamrostay/Models/UserModel.dart';
import 'package:hamrostay/Utils/API.dart';
import 'package:hamrostay/Utils/APICall.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';
import 'package:hamrostay/localization/localization.dart';

class FAQs extends StatefulWidget {
  FAQs({Key? key, this.strTitle}) : super(key: key);

  @override
  _FAQsState createState() => _FAQsState();
  final strTitle;
}

class _FAQsState extends State<FAQs> implements OnResponseCallback {
  List<Rows> _faqDataList = [];

  UserData? userData;

  var isShowLoader = false;

  @override
  void initState() {
    super.initState();
    WidgetUtils.fetchUserDetailsFromPreference().then((value) {
      userData = value;
      wsGetFaqDetails();
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
            child: (_faqDataList.isEmpty)
                ? Container(
                height: SizeConfig.screenHeight * 0.80,
                child: WidgetUtils().noDataFoundText(
                    isShowLoader, Translations.of(context).strNoDataFound, 150, 150))
                :  SingleChildScrollView(
                    child: Container(child: _buildPanel()),
                  ),
          ),
        ));
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _faqDataList[index].isExpanded = !isExpanded;
        });
      },
      children: _faqDataList.map<ExpansionPanel>((Rows item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              tileColor: Colors.white,
              title: Text(item.question ?? "", style: TextStyle(fontWeight: FontWeight.w500)),
            );
          },
          body: ListTile(
            tileColor: Colors.white,
            title: Text(item.answer ?? ""),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }

  void wsGetFaqDetails() async {
    var map = Map();
    map['hotel_id'] = userData?.hotelId ?? 0;
    setState(() {
      isShowLoader = true;
    });

    APICall(context).getFaq(map, this);
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
    if (requestCode == API.requestFaqs && this.mounted) {
      setState(() {
        isShowLoader = false;
      });

      var faqResponse = FAQModel.fromJson(response);

      if (faqResponse.code! == 200) {
        if (faqResponse.data != null &&
            faqResponse.data?.rows != null &&
            faqResponse.data!.rows!.isNotEmpty) {
          setState(() {
            _faqDataList = faqResponse.data!.rows!;
          });
        }
      } else {
        WidgetUtils().customToastMsg(faqResponse.msg!);
      }
    }
  }
}
