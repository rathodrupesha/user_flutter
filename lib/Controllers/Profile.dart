import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hamrostay/Models/EditProfileResponseModel.dart';
import 'package:hamrostay/Utils/API.dart';
import 'package:hamrostay/Utils/APICall.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';
import 'package:image_picker/image_picker.dart';

import '../Models/UserModel.dart';
import '../Utils/MyPrefs.dart';
import '../Utils/SizeConfig.dart';
import '../Utils/WidgetUtils.dart';
import '../localization/localization.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, this.strTitle}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();

  final strTitle;
}

class _ProfileState extends State<Profile> implements OnResponseCallback {
  final ImagePicker _picker = ImagePicker();

  var _emailController = TextEditingController();
  var _firstNameController = TextEditingController();
  var _lastNameController = TextEditingController();
  var _phoneNumberController = TextEditingController();
  var userModel = UserData();
  var _isShowLoader = false;

  String? imageFile;

  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: WidgetUtils().customAppBar(
        context,
        widget.strTitle,
        'assets/images/btn_back.png',
        Colors.white,
        () {
          Navigator.of(context).pop();
        },
        imgColor: Colors.white,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                avatarView(),
                fieldsView(),
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
                      // make api call here
                      wsEditProfile();
                    },
                    btnAttributedText: Translations.of(context).btnSave,
                    strSubTextFontFamily: "Inter",
                  ),
                ),
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
              visible: _isShowLoader),
        ],
      ),
    );
  }

  void setData() async {
    userModel = (await WidgetUtils.fetchUserDetailsFromPreference())!;
    _firstNameController.text = userModel.firstName ?? "";
    _lastNameController.text = userModel.lastName ?? "";
    _emailController.text = userModel.email ?? "";
    _phoneNumberController.text = userModel.mobileNum ?? "";
    setState(() {});
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(Translations.of(context).strFromWhereDoYouWantTakePhoto),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text(Translations.of(context).strGallery),
                      onTap: () {
                        _openGallery(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text(Translations.of(context).strCamera),
                      onTap: () {
                        _openCamera(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  void _openGallery(BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery,maxHeight: 1080.0, maxWidth: 720.0);
    print("Gallery Image Path ==> ${image?.path}");
    this.setState(() {
      imageFile = image?.path;
    });
    Navigator.of(context).pop();
  }

  void _openCamera(BuildContext context) async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera,maxHeight: 1080.0, maxWidth: 720.0);
    print("Camera Image Path ==> ${photo?.path}");
    this.setState(() {
      imageFile = photo?.path;
    });
    Navigator.of(context).pop();
  }

  Widget fieldsView() {
    return Padding(
      padding: EdgeInsets.only(
          top: 40,
          left: 20,
          right: 20,
          bottom: getProportionalScreenHeight(140)),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            WidgetUtils().simpleTextViewWithGivenFontSize(
                Translations.of(context).strFirstName,
                getProportionalScreenWidth(14),
                Constants.appLightBlueTextColor,
                "Inter",
                FontWeight.normal),
            WidgetUtils().customTextField(
                "Inter",
                getProportionalScreenWidth(16),
                '',
                FontWeight.normal,
                Constants.appGrayBottomLineColor,
                Constants.appDarkBlueTextColor,
                false,
                typeOfKeyboard: TextInputType.name,
                myController: _firstNameController),
            WidgetUtils().sizeBoxHeight(20),
            WidgetUtils().simpleTextViewWithGivenFontSize(
                Translations.of(context).strLastName,
                getProportionalScreenWidth(14),
                Constants.appLightBlueTextColor,
                "Inter",
                FontWeight.normal),
            WidgetUtils().customTextField(
                "Inter",
                getProportionalScreenWidth(16),
                '',
                FontWeight.normal,
                Constants.appGrayBottomLineColor,
                Constants.appDarkBlueTextColor,
                false,
                typeOfKeyboard: TextInputType.name,
                myController: _lastNameController),
            WidgetUtils().sizeBoxHeight(20),
            WidgetUtils().simpleTextViewWithGivenFontSize(
                Translations.of(context).strEmail,
                getProportionalScreenWidth(14),
                Constants.appLightBlueTextColor,
                "Inter",
                FontWeight.normal),
            WidgetUtils().customTextField(
                "Inter",
                getProportionalScreenWidth(16),
                '',
                FontWeight.normal,
                Constants.appGrayBottomLineColor,
                Constants.appDarkBlueTextColor,
                false,
                typeOfKeyboard: TextInputType.emailAddress,
                myController: _emailController),
            WidgetUtils().sizeBoxHeight(20),
            WidgetUtils().simpleTextViewWithGivenFontSize(
                Translations.of(context).strPhoneNumber,
                getProportionalScreenWidth(14),
                Constants.appLightBlueTextColor,
                "Inter",
                FontWeight.normal),
            WidgetUtils().customTextField(
                "Inter",
                getProportionalScreenWidth(16),
                '',
                FontWeight.normal,
                Constants.appGrayBottomLineColor,
                Constants.appDarkBlueTextColor,
                false,
                typeOfKeyboard: TextInputType.phone,
                myController: _phoneNumberController),
          ],
        ),
      ),
    );
  }

  Future<void> wsEditProfile() async {
    setState(() {
      _isShowLoader = true;
    });

    var map = Map();
    map["first_name"] = _firstNameController.text.toString();
    map["last_name"] = _lastNameController.text.toString();
    map["email"] = _emailController.text.toString();
    map["mobile_num"] = _phoneNumberController.text.toString();
    map["profile_image"] = imageFile;

    APICall(context).editProfileApi(map, this);
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
    if (requestCode == API.requestEditProfile && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });

      // if status code is 200
      var editProfileResponse = EditProfileResponseModel.fromJson(response);
      if (editProfileResponse.code == 200) {
        setState(() {
          userModel.profileImage = editProfileResponse.data?.profileImage;
          userModel.firstName = editProfileResponse.data?.firstName;
          userModel.lastName = editProfileResponse.data?.lastName;
          userModel.email = editProfileResponse.data?.email;
          userModel.mobileNum = editProfileResponse.data?.mobileNum;
        });
      } else {
        WidgetUtils().customToastMsg(editProfileResponse.msg!);
      }
    }
  }

  Widget avatarView() {
    print("Image URL ==> $imageFile");
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
      child: Center(
        child: Stack(
          children: [
            Card(
              elevation: 20,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(150),
                  side: BorderSide(
                      color: Colors.white, width: 2, style: BorderStyle.solid)),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.transparent,
                backgroundImage: imageFile != null
                    ? Image.file(File(imageFile!)).image
                    : FadeInImage(
                            placeholder: AssetImage(
                                'assets/images/img_placeholder_logo.png'),
                            image: userModel.profileImage != null
                                ? NetworkImage(userModel.profileImage!)
                                : Image.asset(
                                        "assets/images/img_placeholder_logo.png",)
                                    .image)
                        .image,
              ),
            ),
            Positioned(
              right: 0,
              top: getProportionalScreenWidth(65),
              child: InkWell(
                onTap: () async {
                  print("onTap => Camera Icon");
                  _showSelectionDialog(context);
                },
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent, shape: BoxShape.circle),
                  child: Icon(Icons.camera_alt_outlined,
                      color: Colors.white, size: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
