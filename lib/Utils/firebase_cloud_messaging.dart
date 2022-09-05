import 'dart:convert';
import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:overlay_support/overlay_support.dart';

import 'notification_view.dart';

class FireBaseCloudMessagingWrapper extends Object {
  FirebaseMessaging? _fireBaseMessaging;
  String _fcmToken = "WDU9hl_B4UWdTfzCP";

  String get fcmToken => _fcmToken;

// Used for identify if navigation instance created
  RemoteMessage? pendingNotification;
  bool _isAppStarted = false;

  factory FireBaseCloudMessagingWrapper() {
    return _singleton;
  }

  static final FireBaseCloudMessagingWrapper _singleton = new FireBaseCloudMessagingWrapper._internal();

  String chatMessageType = "new_chat_message";
  String newRequestType = "new_request";
  String acceptRequestType = "accept_request";
  String favouriteType = "favourite";

  FireBaseCloudMessagingWrapper._internal() {
  print("===== Firebase Messaging instance created =====");
    _fireBaseMessaging = FirebaseMessaging.instance;
    firebaseCloudMessagingListeners();
  }

  Future<String> getFCMToken() async {
    try {
      String? token = await _fireBaseMessaging!.getToken();
      if (token != null && token.isNotEmpty) {
        print("===== FCM Token :: $token =====");
        _fcmToken = token;
      }
      return _fcmToken;
    } catch (e) {
      print("Error :: ${e.toString()}");
      return e.toString();

      /// return null
    }
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();

    _fireBaseMessaging!.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        if (this._isAppStarted) {
          this.notificationOperation(payload: message);
        } else {
          this.pendingNotification = message;
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage :: ${message.toString()}");
      Future.delayed(
        Duration(seconds: 1),
        () => this.displayNotificationView(payload: message),
      );
      // if (!SocketProvider().isChatScreenOpen) {
      //   Future.delayed(
      //     Duration(seconds: 1),
      //         () => this.displayNotificationView(payload: message),
      //   );
      // }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      notificationOperation(payload: message);
    });
  }

  performPendingNotificationOperation() {
    this._isAppStarted = true;
    print("Check Operation for pending notification");
    if (this.pendingNotification == null) return;
    this.notificationOperation(payload: this.pendingNotification);
    this.pendingNotification = null;
  }

  void iOSPermission() async {
    NotificationSettings settings = await _fireBaseMessaging!.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
    _fireBaseMessaging!.getNotificationSettings();
  }

//region notification action view
  void displayNotificationView({RemoteMessage? payload}) {
    String title = payload?.notification?.title?? "HamroStay";
    String body = payload?.notification?.body??"";

    Map<String, dynamic> notification = Map<String, dynamic>();
    if (Platform.isIOS) {
      notification = payload!.data;
    } else {
      // notification = payload!.data ?? Map<String, dynamic>();
      notification = payload!.data;
    }
    //title = notification["title"] ?? '';
    //body = notification["body"] ?? '';
    // body = notification["message"] ?? '';

    print("Display notification view  === ${payload.notification} ");

    showOverlayNotification((BuildContext _cont) {
      return NotificationView(
          title: title,
          subTitle: body,
          onTap: (isAllow) {
            OverlaySupportEntry.of(_cont)!.dismiss();
            if (isAllow) {
              this.notificationOperation(payload: payload);
            }
          });
    }, duration: Duration(milliseconds: 5000));
  }

//endregion

//region notificationOperation or input action
  void notificationOperation({RemoteMessage? payload}) {
    print(" Notification On tap Detected ");
//     SocketProvider().isChatScreenOpen = false;
    print("====== Notification content =====${payload!.data}======");
    var data;
    Map<String, dynamic> notification = Map<String, dynamic>();
    if (payload.data['data'] is String) {
      data = json.decode(payload.data['data']);
      print("===========${data}======");
      if (Platform.isIOS) {
        notification = data;
      } else {
        notification = data ?? Map<String, dynamic>();
      }
    } else {
      if (Platform.isIOS) {
        notification = payload.data;
      } else {
        // notification = payload.data ?? Map<String, dynamic>();
        notification = payload.data;
      }
    }

//     String id = notification["id"];
//     String notificationType = notification["notification"] ?? '';
//     String type = notification['type'] ?? '';
//     String roomId = notification['roomId'] ?? '';
//     String firstname = notification['firstname'] ?? '';
//     String lastname = notification['lastname'] ?? '';
// // String message = notification['message'] ?? '';
//     String referralId = notification['referral_id'] ?? '';
//     String orderId = notification['order_id'] ?? '';
//     ;
//     String feedId = notification['post_id'] ?? '';
  }
}
