import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:hamrostay/Models/DirectoriesModel.dart';
import 'package:hamrostay/Models/UserModel.dart';
import 'package:hamrostay/Utils/API.dart';
import 'package:hamrostay/Utils/APICall.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';

import '../localization/localization.dart';

class MyDirectory extends StatefulWidget {
  MyDirectory({Key? key}) : super(key: key);

  @override
  _DirectoryState createState() => _DirectoryState();
}

class _DirectoryState extends State<MyDirectory> implements OnResponseCallback {
  var _isShowLoader = false;
  List<Rows> _directoriesDataList = [];
  UserData? userData;
  var _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetUtils.fetchUserDetailsFromPreference().then((value) {
      userData = value;
      wsGetDirectoryDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return SafeArea(
      top: false,
      bottom: false,
      child: Stack(
        children: <Widget>[
          Scaffold(
              backgroundColor: Constants.appLightBackgroundColor,
              appBar: WidgetUtils().customAppBar(context, Translations.of(context).strDirectory,
                  'assets/images/btn_back.png', Colors.white, () {
                Navigator.of(context).pop();
              },
                  imgColor: Colors.white,
                  barHeight: _directoriesDataList.isNotEmpty ? 50 : 0),
              body: _directoriesDataList.isNotEmpty
                  ? _getBodyView(context)
                  : WidgetUtils().noDataFoundText(
                      _isShowLoader,
                      Translations.of(context).strNoDataFound,
                      150,
                      150)),
          _searchBarView()
        ],
      ),
    );
  }

  Widget _searchBarView() {
    return _directoriesDataList.isNotEmpty
        ? Positioned(
            child: Container(
              height: 50,
              child: Material(
                elevation: 5,
                borderRadius: new BorderRadius.all(new Radius.circular(10)),
                child: TextField(
                  controller: _searchController,
                  onEditingComplete: (){
                    wsGetDirectoryDetails();
                  },
                  textInputAction: TextInputAction.search,
                  onChanged: searchContact,
                  onSubmitted: (value) {
                    wsGetDirectoryDetails();
                  },
                  cursorColor: Constants.appDarkBlueTextColor,
                  decoration: InputDecoration(
                      hintText: Translations.of(context).strSearchHere,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 20,right: 5),
                      suffixIcon: IconButton(
                        iconSize: 25,
                        icon: Icon(
                          Icons.search,
                        ),
                        color: Constants.appDarkGreenColor,
                        onPressed: () {
                          wsGetDirectoryDetails();
                        },
                      )),
                  style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.normal,
                      color: Constants.appDarkBlueTextColor,
                      fontSize: getProportionalScreenWidth(16)),
                ),
              ),
            ),
            left: 10,
            top: SizeConfig.topHeight + kToolbarHeight + 25,
            right: 10,
          )
        : Container();
  }

  Widget _getBodyView(BuildContext context) {
    return Container(
      color: Constants.appLightBackgroundColor,
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 35.0, left: 16.0, right: 16.0, bottom: 20.0),
        itemCount: _directoriesDataList.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Padding(padding: const EdgeInsets.all(26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    WidgetUtils().simpleTextViewWithGivenFontSize(
                        _directoriesDataList[index].name ?? "",
                        getProportionalScreenWidth(16),
                        Constants.appDarkBlueTextColor,
                        "Inter",
                        FontWeight.w500,
                        txtAlign: TextAlign.left),
                    WidgetUtils().sizeBoxHeight(5),
                    WidgetUtils().simpleTextViewWithGivenFontSize(
                        _directoriesDataList[index].number ?? "",
                        getProportionalScreenWidth(12),
                        Constants.appDarkBlueTextColor,
                        "Inter",
                        FontWeight.w400,
                        txtAlign: TextAlign.left)
                  ],
                ),
              ),

              trailing: Container(
                alignment: Alignment.center,
                width: SizeConfig.screenWidth * 0.2,
                height: SizeConfig.screenWidth * 0.2,
                child: IconButton(
                  icon: Image.asset('assets/images/img_call_icon.png'),
                  onPressed: () async {
                    final contactNumber = _directoriesDataList[index].number;
                    //indirect phone calls
                    //launch('tel://$contactNumber');
                    //direct phone calls
                     await FlutterPhoneDirectCaller.callNumber('$contactNumber');
                  },
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 12,
          );
        },
      ),
    );
  }

  void wsGetDirectoryDetails() async {
    var map = Map();
    map['hotel_id'] = userData?.hotelId ?? 0;
    map['search_string'] = _searchController.text;

    setState(() {
      _isShowLoader = true;
      _directoriesDataList = [];
    });

    APICall(context).getDirectories(map, this);
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
    if (requestCode == API.requestDirectories && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });
      var directoriesResponse = DirectoriesModel.fromJson(response);

      if (directoriesResponse.code! == 200) {
        if (directoriesResponse.data != null &&
            directoriesResponse.data?.rows != null &&
            directoriesResponse.data!.rows!.isNotEmpty) {
          setState(() {
            _directoriesDataList = directoriesResponse.data!.rows!;
          });
        }
      } else {
        WidgetUtils().customToastMsg(directoriesResponse.msg!);
      }
    }
  }

  void searchContact(String value) {}
}
