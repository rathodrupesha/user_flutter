import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hamrostay/Models/HotelModel.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:hamrostay/Utils/SizeConfig.dart';
import 'package:hamrostay/Utils/WidgetUtils.dart';
import 'package:hamrostay/localization/localization.dart';

import '../Utils/app_date_format.dart';
import '../Utils/date_utils.dart';

class AmenitiesScreen extends StatefulWidget {
  final HotelData objHotelData;
  final objUserModel;

  AmenitiesScreen({Key? key, required this.objHotelData, this.objUserModel})
      : super(key: key);

  @override
  _AmenitiesScreenState createState() => _AmenitiesScreenState();
}

class _AmenitiesScreenState extends State<AmenitiesScreen> {
  final CarouselController _carouselController = CarouselController();
  var imgCurrentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: WidgetUtils().customAppBar(
            context,
            Translations.of(context).strAmenities,
            'assets/images/btn_back.png',
            Colors.white,
            () {
              Navigator.of(context).pop();
            },
            imgColor: Colors.white,
            onRightBtnPress: () {
              print('Notification image clicked');
            }),
        body: Material(
          color: Colors.white,
          child: SafeArea(
            top: false,
            bottom: false,
            left: false,
            child: _getBodyView(),
          ),
        ));
  }

  Widget _getBodyView() {
    return SingleChildScrollView(
      child: Material(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                        viewportFraction: 1,
                        height: SizeConfig.screenHeight * 0.28,
                        enableInfiniteScroll: false,
                        autoPlay: false,
                        scrollDirection: Axis.horizontal,
                        initialPage: 0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            imgCurrentIndex = index;
                          });
                        }),
                    carouselController: _carouselController,
                    items: widget.objHotelData.hotelImages!
                        .map((item) => Container(
                              child: Center(
                                  child: CachedNetworkImage(
                                width: SizeConfig.screenWidth,
                                height: SizeConfig.screenHeight * 0.28,
                                fit: BoxFit.fill,
                                imageUrl: item,
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
                              )),
                            ))
                        .toList(),
                  ),
                  Positioned(
                    top: SizeConfig.screenHeight * 0.2,
                    right: SizeConfig.screenWidth * 0.025,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(Radius.circular(6.0)),
                          color: Colors.white.withOpacity(0.5),
                        ),
                        alignment: Alignment.center,
                        height: SizeConfig.screenHeight * 0.045,
                        width: SizeConfig.screenWidth * 0.16,
                        child: WidgetUtils().simpleTextViewWithGivenFontSize(
                            '${imgCurrentIndex + 1}/${widget.objHotelData.hotelImages!.length}',
                            getProportionalScreenWidth(14),
                            Colors.white,
                            "Inter",
                            FontWeight.w600,
                            txtAlign: TextAlign.center),
                      ),
                    ),
                  )
                ],
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    WidgetUtils().sizeBoxHeight(15),
                    (widget.objHotelData.amenities!.isNotEmpty) ? Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: tagView(),
                    ) : Center(child: WidgetUtils()
                        .noDataFoundText(false, Translations.of(context).strNoDataFound, 150, 150))
                  ])
            ],
          ),
        ),
      ),
    );
  }

  Widget tagView() {
    List<Widget> list = <Widget>[];
    for (var i = 0; i < widget.objHotelData.amenities!.length; i++) {
      list.add(Chip(
        backgroundColor: Constants.appTagBackgroundColor,
        padding: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        // avatar: CircleAvatar(
        //   backgroundColor: Colors.transparent,
        //   // child:
        //   // Image.asset(
        //   //   '${_choicesImgList[i]}',
        //   //   width: 18,
        //   //   height: 18,
        //   // ),
        // ),
        label: Text('${widget.objHotelData.amenities![i]}'),
      ));
    }
    return Wrap(
        spacing: 10.0, // gap between adjacent chips
        runSpacing: 2.0, // gap between lines
        children: list);
  }
}
