import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:hamrostay/Utils/OnResponseCallback.dart';

import '../Models/AnnounceListModel.dart';
import '../Utils/API.dart';
import '../Utils/APICall.dart';
import '../Utils/Constants.dart';
import '../Utils/SizeConfig.dart';
import '../Utils/WidgetUtils.dart';
import '../localization/localization.dart';

class MoreStories extends StatefulWidget {
  MoreStories({Key? key, required this.categoryId,required this.categoryName}) : super(key: key);

  String categoryId;
  String categoryName;
  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> implements OnResponseCallback {
  final storyController = StoryController();
  var _isShowLoader = false;
  List<StoryItem?> storyItems = [];
  var currentIndex = 0;
  
  List<AnnouncementDataRows> objAnnouncementList = [];
  @override
  void initState() {
    super.initState();
    wsGetAnnouncement();
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Constants.gradient1,
                    Constants.gradient2,
                    Constants.gradient3,
                    Constants.gradient4,
                  ])),
        ),
        textTheme: TextTheme(
            headline6: TextStyle(
                color: Colors.white,
                fontSize: getProportionalScreenWidth(16),
                fontWeight: FontWeight.w600,
                fontFamily: "Inter-SemiBold")),
        title: Text(widget.categoryName),
        elevation: 0,
      ),
      body: (objAnnouncementList.isNotEmpty) ? Stack(
        children: [
          StoryView(
            storyItems: storyItems,
            onStoryShow: (storyItem) {
              int pos = storyItems.indexOf(storyItem);

              // the reason for doing setState only after the first
              // position is becuase by the first iteration, the layout
              // hasn't been laid yet, thus raising some exception
              // (each child need to be laid exactly once)
              if (pos > 0) {
                setState(() {
                  currentIndex = pos;
                });
              }else{
                if(currentIndex != 0) {
                  setState(() {
                    currentIndex = 0;
                  });
                }
              }
            },
            onComplete: () {
              print("Completed a cycle");
            },
            progressPosition: ProgressPosition.top,
            repeat: true,
            controller: storyController,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Align(
              alignment: Alignment.topCenter,
              child: WidgetUtils().simpleTextViewWithGivenFontSize(objAnnouncementList[currentIndex].title ?? "", 14, Colors.white, "Inter",FontWeight.w500),
            ),
          ),
        ],
      ) : WidgetUtils().noDataFoundText(_isShowLoader, Translations.of(context).strNoDataFound, 150, 150)
    );
  }

  Future<void> wsGetAnnouncement() async {
    setState(() {
      _isShowLoader = true;
    });

    var map = Map();

    map["category_id"] = widget.categoryId;

    APICall(context).getAnnouncement(map, this);
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
    if (requestCode == API.requestAnnouncement && this.mounted) {
      setState(() {
        _isShowLoader = false;
      });
      var responseList = AnnouncementListModel.fromJson(response);

      if (responseList.code! == 200 && responseList.data != null) {
        objAnnouncementList = responseList.data!.rows!;

        Map<String,dynamic>? map  = Map<String,dynamic>();

        map["Title"] = "Hello";

        for(var model in objAnnouncementList)
        storyItems.add(StoryItem.pageImage(url: model.image ?? "",
            caption: model.description ?? "",
            controller: storyController));
        setState(() {

        });
      } else {
        WidgetUtils().customToastMsg(responseList.msg!);
      }
    }
  }

}
