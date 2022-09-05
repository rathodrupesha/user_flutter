import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'Constants.dart';
import 'enum.dart';

class NotificationView extends StatelessWidget {
  final String title;
  final String subTitle;
  final NotificationOViewCallback? onTap;

  NotificationView({this.title = "", this.subTitle = "", this.onTap});

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return Material(
        color: Colors.white,
        child: SafeArea(
          child: GestureDetector(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: 15,
                      left: 16,
                      right: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              child: Image.asset(
                                'assets/images/img_placeholder_logo.png',
                                width: 20,
                                height: 20,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              "HamroStay",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Constants.appDarkBlueTextColor,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 6,
                          ),
                        ),
                        Text(
                          this.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Constants.appDarkBlueTextColor,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 6,
                          ),
                        ),
                        Text(
                          this.subTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Constants.appDarkBlueTextColor,
                          ),
                          maxLines: 3,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 10,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              color: Colors.transparent,
              width: double.infinity,
            ),
            onTap: () {
              if (this.onTap != null) {
                this.onTap!(true);
              }
            },
          ),
          bottom: false,
        ),
      );
    } else {
      return Material(
        color: Colors.transparent,
        child: GestureDetector(
          child: SafeArea(
            child: Container(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        ClipRRect(
                          child: Image.asset(
                            'assets/images/img_placeholder_logo.png',
                            width: 20,
                            height: 20,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          "HamroStay",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Constants.appDarkBlueTextColor,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 6,
                      ),
                    ),
                    Text(
                      this.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Constants.appDarkBlueTextColor,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 6)),
                    Text(
                      this.subTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: Constants.appDarkBlueTextColor,
                      ),
                      maxLines: 3,
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white.withAlpha(200),
                  boxShadow: kElevationToShadow[2],
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
                boxShadow: kElevationToShadow[2],
              ),
              margin: EdgeInsets.all(10.0),
              width: double.infinity,
            ),
            bottom: false,
          ),
          onTap: () {
            if (this.onTap != null) {
              this.onTap!(true);
            }
          },
        ),
      );
    }
  }
}
