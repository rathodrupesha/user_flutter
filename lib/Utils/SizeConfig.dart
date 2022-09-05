import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// class SizeConfig {
//   static MediaQueryData _mediaQueryData = MediaQueryData();
//   static double screenWidth = 0.0;
//   static double screenHeight = 0.0;
//   // static double defaultSize = 0.0;
//   // static double topHeight = 0.0;

//   static double blockSizeHorizontal = 0.0;
//   static double blockSizeVertical = 0.0;

//   static double _safeAreaHorizontal = 0.0;
//   static double _safeAreaVertical = 0.0;
//   static double safeBlockHorizontal = 0.0;
//   static double safeBlockVertical = 0.0;

//   void init(BuildContext context) {
//     _mediaQueryData = MediaQuery.of(context);
//     screenWidth = _mediaQueryData.size.width;
//     screenHeight = _mediaQueryData.size.height;
//     blockSizeHorizontal = screenWidth / 100;
//     blockSizeVertical = screenHeight / 100;

//     _safeAreaHorizontal =
//         _mediaQueryData.padding.left + _mediaQueryData.padding.right;
//     _safeAreaVertical =
//         _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
//     safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
//     safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
//   }

//   // // Get the proportional height as per screen size
//   double getProportionalScreenHeight(double inputHeight) {
//     double screenHeight = SizeConfig.screenHeight;
// // 812 is the layout height that designer use
//     return (inputHeight / 812.0) * screenHeight;
//   }

// // // Get the proportional width as per screen size
//   double getProportionalScreenWidth(double inputWidth) {
//     double screenWidth = SizeConfig.screenWidth;
// // 375 is the layout height that designer use
//     return (inputWidth / 375.0) * screenWidth;
//   }
// }

class SizeConfig {
  static MediaQueryData _mediaQueryData = MediaQueryData();
  static double screenWidth = 0.0;
  static double screenHeight = 0.0;
  static double defaultSize = 0.0;
  static double topHeight = 0.0;

  static Orientation orientation = Orientation.portrait;

// changes start
  // static double blockSizeHorizontal = 0.0;
  // static double blockSizeVertical = 0.0;

  // static double _safeAreaHorizontal = 0.0;
  // static double _safeAreaVertical = 0.0;
  // static double safeBlockHorizontal = 0.0;
  // static double safeBlockVertical = 0.0;
  // changes end

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    topHeight = _mediaQueryData.padding.top;

// changes start
    //     blockSizeHorizontal = screenWidth / 100;
    // blockSizeVertical = screenHeight / 100;

    // _safeAreaHorizontal =
    //     _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    // _safeAreaVertical =
    //     _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    // safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    // safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  // changes end

  }
}

// Get the proportional height as per screen size
double getProportionalScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
// 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportional width as per screen size
double getProportionalScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
// 375 is the layout height that designer use
  return (inputWidth / 375.0) * screenWidth;
}
