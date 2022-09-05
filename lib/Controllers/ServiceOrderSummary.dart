import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hamrostay/Controllers/PremiumRequestSuccessPopup.dart';
import 'package:hamrostay/Models/BookSlotResponseModel.dart';
import 'package:hamrostay/Models/GetSlotResponseModel.dart';
import 'package:hamrostay/Models/PackageDetailModel.dart';
import 'package:hamrostay/Models/SubServicesModel.dart';
import 'package:hamrostay/Models/UserModel.dart';
import 'package:hamrostay/Utils/API.dart';
import 'package:hamrostay/Utils/APICall.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';
import 'package:hamrostay/Utils/app_date_format.dart';
import 'package:hamrostay/Utils/date_utils.dart';
import 'package:intl/intl.dart';

import '../localization/localization.dart';

class ServiceOrderSummary extends StatefulWidget {

  ServiceOrderSummary(this.objPremiumServices,this.serviceId,this.packageId, {Key? key}) : super(key: key);

  final SubServicesRows objPremiumServices;
  String packageId;
  String serviceId;

  @override
  State<ServiceOrderSummary> createState() => _ServiceOrderSummaryState();
}

class _ServiceOrderSummaryState extends State<ServiceOrderSummary>  implements OnResponseCallback {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDateTime = DateTime.now();
  var _isShowLoader = false;
  var userModel = UserData();
  PackageDetails objPackage = PackageDetails();
  SlotDetail? dropdownValue;
  int slotId = 0;
  String numberOfPerson = "1";
  List<SlotDetail> objSlotList = [];
  String selectedSlotStartTime = "";
  String selectedSlotEndTime = "";
  List<String> noSlotAvailable = [Translations.current!.strSlotNotAvailable];
  List<String> numberOfPersonList = ["1","2","3","4","5","6","7","8","9","10"];

  @override
  void initState() {
    super.initState();

    wsPackageDetailAPi();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        appBar: WidgetUtils().customAppBar(
            context,
            Translations.of(context).strOrderSummary,
            'assets/images/btn_back.png',
            Colors.white,
            () {
              Navigator.of(context).pop();
            },
            imgColor: Colors.white,
            //isRightControl: true,
            //rightImgName: userModel.profileImage ?? "",
            onRightBtnPress: () {
              print('Notification image clicked');
            }),
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
          child: (objPackage.id == null)
              ? Container(
              height: SizeConfig.screenHeight * 0.75,
              child: WidgetUtils().noDataFoundText(
              _isShowLoader, Translations.of(context).strNoDataFound, 150, 150))
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  WidgetUtils().sizeBoxHeight(10),
                  _getOrderDetails(),
                  WidgetUtils().sizeBoxHeight(8),
                  _selectDateTime(),
                  WidgetUtils().sizeBoxHeight(8),
                  _getImportantNotes()
                ],
              ),
              WidgetUtils().sizeBoxHeight(SizeConfig.screenHeight * 0.15),
            ],
          ),
        ),
        Positioned(
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 25, right: 25, top: 25, bottom: 35),
                  child: WidgetUtils().customButton(
                    context,
                    '',
                    Constants.appBlueColor,
                    "Inter",
                    getProportionalScreenWidth(16),
                    Colors.white,
                    () {
                      wsBookSlot();
                    },
                    btnAttributedText: Translations.of(context).strBookTheService,
                    strSubTextFontFamily: "Inter",
                  ),
                ),
              )),
        )
      ],
    );
  }

  Widget _getOrderDetails() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: WidgetUtils().simpleTextViewWithGivenFontSize(
                      objPackage.name ?? "",
                      getProportionalScreenWidth(16),
                      Constants.appDarkBlueTextColor,
                      "Inter",
                      FontWeight.w700,
                      txtAlign: TextAlign.left)),
              Expanded(
                  flex: 0,
                  child: WidgetUtils().simpleTextViewWithGivenFontSize(
                      '${objPackage.amountUnit}${objPackage.amount}',
                      getProportionalScreenWidth(16),
                      Constants.appCobaltBlueTextColor,
                      "Inter",
                      FontWeight.bold,
                      txtAlign: TextAlign.right))
            ],
          ),
          WidgetUtils().sizeBoxHeight(6),
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
              Expanded(
                  flex: 1,
                  child: WidgetUtils().simpleTextViewWithGivenFontSize(
                      '${objPackage.duration}  ${objPackage.durationUnit}',
                      getProportionalScreenWidth(12),
                      Constants.appDarkBlueTextColor,
                      "Inter",
                      FontWeight.w400,
                      txtAlign: TextAlign.left)),
              Expanded(
                  flex: 0,
                  child: WidgetUtils().simpleTextViewWithGivenFontSize(
                      '/person',
                      getProportionalScreenWidth(12),
                      Constants.appDarkBlueTextColor,
                      "Inter",
                      FontWeight.w400,
                      txtAlign: TextAlign.left))
            ],
          )
        ],
      ),
    );
  }

  Widget _selectDateTime() {
    return Container(
        color: Colors.white,
        width: SizeConfig.screenWidth,
        padding: EdgeInsets.all(20.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              WidgetUtils().simpleTextViewWithGivenFontSize(
                  Translations.of(context).strSelectDate,
                  getProportionalScreenWidth(15),
                  Constants.appDarkBlueTextColor,
                  "Inter",
                  FontWeight.w600,
                  txtAlign: TextAlign.left),
              WidgetUtils().sizeBoxHeight(10),
              GestureDetector(
                onTap: () {
                  _selectDate(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: new BorderRadius.all(Radius.circular(12.0)),
                    color: Constants.appTagBackgroundColor,
                  ),
                  width: SizeConfig.screenWidth,
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/img_calendar.png',
                        width: 22,
                        height: 22,
                      ),
                      WidgetUtils().sizeBoxWidth(12),
                      Expanded(
                          flex: 1,
                          child: WidgetUtils().simpleTextViewWithGivenFontSize(
                              '${DateFormat('dd MMM yyyy').format(selectedDate)}',
                              getProportionalScreenWidth(16),
                              Constants.appDarkBlueTextColor,
                              "Inter",
                              FontWeight.w500,
                              txtAlign: TextAlign.left)),
                      Expanded(
                          flex: 0,
                          child: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: Constants.appDarkBlueTextColor,
                            size: 32,
                          ))
                    ],
                  ),
                ),
              ),
              WidgetUtils().sizeBoxHeight(20),
              WidgetUtils().simpleTextViewWithGivenFontSize(
                  Translations.of(context).strSelectTimeSlot,
                  getProportionalScreenWidth(15),
                  Constants.appDarkBlueTextColor,
                  "Inter",
                  FontWeight.w600,
                  txtAlign: TextAlign.left),
              WidgetUtils().sizeBoxHeight(10),

              Container(
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.all(Radius.circular(
                      SizeConfig.screenHeight * 0.05 / 4)),
                  color: Color.fromRGBO(244, 245, 247, 1.0),
                ),
                height: getProportionalScreenHeight(60) ,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: DropdownButton<SlotDetail>(
                    isExpanded: true,
                    value: dropdownValue,
                      hint: Text(Translations.of(context).strPleaseSelectTimeSlot),
                    iconSize: 30,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_outlined,
                    ),
                    elevation: 16,
                    style: const TextStyle(
                        fontFamily: "Inter",
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Constants.appDarkBlueTextColor),
                    underline: Container(
                      height: 0,
                      color: Colors.transparent,
                    ),
                    onChanged: (SlotDetail? newValue) {
                      setState(() {
                        dropdownValue = newValue!;

                        selectedSlotStartTime =newValue.startTime!;
                        selectedSlotEndTime = newValue.endTime!;
                        slotId = newValue.id!;
                      });
                    },
                    items:  objSlotList.map<DropdownMenuItem<SlotDetail>>((SlotDetail value) {
                      return DropdownMenuItem<SlotDetail>(
                        value: value,
                        child: Row(
                          children: [
                            WidgetUtils().sizeBoxWidth(5),
                            Image.asset(
                              'assets/images/img_clock.png',
                              width: 22,
                              height: 22,
                            ),
                            WidgetUtils().sizeBoxWidth(12),
                            Text(DateUtilss.dateToString(DateUtilss.stringToDate(value.startTime!,format: AppDateFormat.hoursFormat,isUTCTime: false)!,format: AppDateFormat.hoursAMPMFormat)+ " - " + DateUtilss.dateToString(DateUtilss.stringToDate(value.endTime!,format: AppDateFormat.hoursFormat,isUTCTime: false)!,format: AppDateFormat.hoursAMPMFormat)),
                          ],
                        ),
                      );
                    }).toList() /*: noSlotAvailable.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: dropdownValue,
                        child: Text("Slot Not Available"),
                      );
                    }).toList(),*/
                  ),
                ),
              ),

              WidgetUtils().sizeBoxHeight(20),

              WidgetUtils().simpleTextViewWithGivenFontSize(
                  Translations.of(context).strNoOfPerson,
                  getProportionalScreenWidth(15),
                  Constants.appDarkBlueTextColor,
                  "Inter",
                  FontWeight.w600,
                  txtAlign: TextAlign.left),
              WidgetUtils().sizeBoxHeight(10),

              Container(
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.all(Radius.circular(
                      SizeConfig.screenHeight * 0.05 / 4)),
                  color: Color.fromRGBO(244, 245, 247, 1.0),
                ),
                height: getProportionalScreenHeight(60) ,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: numberOfPerson,
                    iconSize: 30,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_outlined,
                    ),
                    elevation: 16,
                    style: const TextStyle(
                        fontFamily: "Inter",
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Constants.appDarkBlueTextColor),
                    underline: Container(
                      height: 0,
                      color: Colors.transparent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        numberOfPerson = newValue!;
                      });
                    },
                    items: numberOfPersonList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ]));
  }

  Widget _getImportantNotes() {
    return Container(
        color: Colors.white,
        width: SizeConfig.screenWidth,
        padding: EdgeInsets.all(20.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              WidgetUtils().simpleTextViewWithGivenFontSize(
                  Translations.of(context).strImportantNotes,
                  getProportionalScreenWidth(15),
                  Constants.appDarkBlueTextColor,
                  "Inter",
                  FontWeight.w600,
                  txtAlign: TextAlign.left),
              WidgetUtils().sizeBoxHeight(12),
              WidgetUtils().simpleTextViewWithGivenFontSize(
                  objPackage.importantNotes ?? "",
                  getProportionalScreenWidth(14),
                  Constants.appDarkBlueTextColor,
                  "Inter",
                  FontWeight.w400)
            ]));
  }

  _selectDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(context);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context);
    }

  }

  buildMaterialDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        wsGetDateSlot();
      });
    print("selected date $selectedDate");
  }

  buildCupertinoDatePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              minimumDate: DateTime.now(),
              onDateTimeChanged: (picked) {
                if (picked != null && picked != selectedDate)
                  setState(() {
                    selectedDate = picked;
                    wsGetDateSlot();
                  });
                print("selected date $selectedDate");
              },
              initialDateTime: selectedDate,
              minimumYear: 2000,
              maximumYear: 2025,
            ),
          );
        });
  }

  _selectTime(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialTimePicker(context);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoTimePicker(context);
    }
  }

  buildMaterialTimePicker(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
    print("selected time $selectedTime");
  }

  buildCupertinoTimePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              onDateTimeChanged: (picked) {
                if (picked != null && picked != selectedDateTime)
                  setState(() {
                    selectedDateTime = picked;
                  });
              },
              initialDateTime: selectedDateTime,
              minimumYear: 2000,
              maximumYear: 2025,
            ),
          );
        });
  }

  Future<void> wsPackageDetailAPi() async {
    setState(() {
      _isShowLoader = true;
    });
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    var map = Map();
    map["hotel_id"] = userModel.hotelId;
    map["package_id"] = widget.packageId;

    APICall(context).getPackageDetailApi(map, this);
  }

  Future<void> wsBookSlot() async {
    setState(() {
      _isShowLoader = true;
    });
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;

    if(slotId == 0){
      WidgetUtils().customToastMsg(Translations.of(context).strPleaseSelectTimeSlotSmall);
      return;
    }

    var map = Map();
    map["premium_service_id"] = widget.serviceId;
    map["hotel_id"] = userModel.hotelId;
    map["start_time"] = selectedSlotStartTime;
    map["end_time"] = selectedSlotEndTime;
    map["premium_packages_services_id"] = widget.packageId;
    map["package_slot_id"] = slotId;
    map["no_of_person"] = numberOfPerson;

    APICall(context).bookSlotApi(map, this);
  }

  Future<void> wsGetDateSlot() async {
    setState(() {
      _isShowLoader = true;
    });

    var map = Map();
    map["enterDate"] = DateUtilss.dateToString(selectedDate,format: AppDateFormat.appDobFormat);
    map["premium_service_packages_id"] = objPackage.id;
    map["enterDay"] = DateFormat('EEEE').format(selectedDate);
    map["page"] = 1;
    map["limits"] = 100;

    APICall(context).getDateSlotApi(map, this);
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
    if (requestCode == API.requestPackageDetail && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var packageModel = PackageDetailModel.fromJson(response);

      if (packageModel.code! == 200) {
        setState(() {
          objPackage = packageModel.data!;
          wsGetDateSlot();
        });
      } else {
         WidgetUtils().customToastMsg(packageModel.msg!);
      }
    } else if (requestCode == API.requestBookSlot && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var bookSlotResponse = BookSlotResponseModel.fromJson(response);

      if (bookSlotResponse.code! == 200) {
        setState(() {
          showDialog(
              context: context,
              builder: (context) => PremiumRequestSucessPopup(bookSlotResponse.data.toString()),
              useSafeArea: false);
        });
      } else {
        WidgetUtils().customToastMsg(bookSlotResponse.msg!);
      }
    } else if (requestCode == API.requestGetDateSlot && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      var getSlotResponse = GetSlotResponseModel.fromJson(response);

      if (getSlotResponse.code! == 200) {
        setState(() {
          dropdownValue = null;
          slotId = 0;
          objSlotList = getSlotResponse.data!;
          if(objSlotList.isEmpty){
            slotId = 0;
          }
        });
      } else {
        WidgetUtils().customToastMsg(getSlotResponse.msg!);
      }
    }
  }
}
