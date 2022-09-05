import 'dart:async';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:hamrostay/Utils/Constants.dart';
import 'package:http/http.dart' as http;

import 'API.dart';
import 'NetworkUtils.dart';
import 'OnResponseCallback.dart';
import 'package:mime/mime.dart';

class APICall {
  final BuildContext context;

  APICall(this.context);

  Future<void> login(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.LOGIN),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestLogin, request, API.LOGIN);
      print("Headers of ${API.LOGIN}, $_getHeader()");
      print("Request of ${API.LOGIN}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestLogin);
      return null;
    }
  }

  Future<void> deviceInfo(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.DEVICE_INFO),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestDeviceInfo, request,
          API.DEVICE_INFO);
      print("Headers of ${API.DEVICE_INFO}, $_getHeader()");
      print("Request of ${API.DEVICE_INFO}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestDeviceInfo);
      return null;
    }
  }

  Future<void> fetchUser(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response =
          await http.get(_getUri(API.FETCH_USER), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestFetchUser, request,
          API.FETCH_USER);
      print("Headers of ${API.FETCH_USER}, $_getHeader()");
      print("Request of ${API.FETCH_USER}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestFetchUser);
      return null;
    }
  }

  Future<void> getCurrentStay(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.CURRENT_STAY),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestCurrentUser,
          request, API.CURRENT_STAY);
      print("Headers of ${API.CURRENT_STAY}, $_getHeader()");
      print("Request of ${API.CURRENT_STAY}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestCurrentUser);
      return null;
    }
  }

  Future<void> getOurServices(Map request, Map<String, String> queryParams,
      OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(
          _getUriWithQuery(API.OUR_MAIN_SERVICES, queryParams),
          body: json.encode(request),
          headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestOurMainServices,
          request, API.OUR_MAIN_SERVICES);
      print("Headers of ${API.OUR_MAIN_SERVICES}, $_getHeader()");
      print("Request of ${API.OUR_MAIN_SERVICES}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestOurMainServices);
      return null;
    }
  }

  Future<void> getSubServices(Map request, Map<String, String> queryParams,
      OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(
          _getUriWithQuery(API.OUR_SUB_SERVICES, queryParams),
          body: json.encode(request),
          headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestOurSubServices,
          request, API.OUR_SUB_SERVICES);
      print("Headers of ${API.OUR_SUB_SERVICES}, $_getHeader()");
      print("Request of ${API.OUR_SUB_SERVICES}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestOurSubServices);
      return null;
    }
  }

  Future<void> getPremiumServices(Map request, Map<String, String> queryParams,
      OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(
          _getUriWithQuery(API.OUR_PREMIUM_SERVICES, queryParams),
          body: json.encode(request),
          headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestOurPremiumServices,
          request, API.OUR_PREMIUM_SERVICES);
      print("Headers of ${API.OUR_PREMIUM_SERVICES}, $_getHeader()");
      print("Request of ${API.OUR_PREMIUM_SERVICES}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestOurPremiumServices);
      return null;
    }
  }

  Future<void> bookingService(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.SERVICE_BOOKING),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestServiceBooking,
          request, API.SERVICE_BOOKING);
      print("Headers of ${API.SERVICE_BOOKING}, $_getHeader()");
      print("Request of ${API.SERVICE_BOOKING}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestServiceBooking);
      return null;
    }
  }

  Future<void> getPremiumServicesDetails(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(
          _getUri(API.PREMIUM_SERVICES_DETAILS),
          body: json.encode(request),
          headers: _getHeader());
      _checkResponse(
          response,
          responseCallback,
          API.requestPremiumServicesDetails,
          request,
          API.PREMIUM_SERVICES_DETAILS);
      print("Headers of ${API.PREMIUM_SERVICES_DETAILS}, $_getHeader()");
      print("Request of ${API.PREMIUM_SERVICES_DETAILS}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestPremiumServicesDetails);
      return null;
    }
  }

  Future<void> getFaq(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.FAQS),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestFaqs, request, API.FAQS);
      print("Headers of ${API.FAQS}, $_getHeader()");
      print("Request of ${API.FAQS}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestFaqs);
      return null;
    }
  }

  Future<void> getCms(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.CMS),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestCms, request, API.CMS);
      print("Headers of ${API.CMS}, $_getHeader()");
      print("Request of ${API.CMS}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestCms);
      return null;
    }
  }

  Future<void> getDirectories(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.DIRECTORIES),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestDirectories,
          request, API.DIRECTORIES);
      print("Headers of ${API.DIRECTORIES}, $_getHeader()");
      print("Request of ${API.DIRECTORIES}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestDirectories);
      return null;
    }
  }

  Future<void> logout(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.LOGOUT),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestLogout, request, API.LOGOUT);
      print("Headers of ${API.LOGOUT}, $_getHeader()");
      print("Request of ${API.LOGOUT}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestLogout);
      return null;
    }
  }

  Future<void> getDefaultCategoryMeals(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(
          _getUri(API.DEFAULT_CATEGORY_MEALS),
          body: json.encode(request),
          headers: _getHeader());
      _checkResponse(response, responseCallback,
          API.requestDefaultCategoryMeals, request, API.DEFAULT_CATEGORY_MEALS);
      print("Headers of ${API.DEFAULT_CATEGORY_MEALS}, $_getHeader()");
      print("Request of ${API.DEFAULT_CATEGORY_MEALS}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestDefaultCategoryMeals);
      return null;
    }
  }

  Future<void> getHotelMealCategories(
      Map request,
      Map<String, String> queryParams,
      OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(
          _getUriWithQuery(API.HOTEL_MEAL_CATEGORIES, queryParams),
          body: json.encode(request),
          headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestHotelMealCategories,
          request, API.HOTEL_MEAL_CATEGORIES);
      print("Headers of ${API.HOTEL_MEAL_CATEGORIES}, $_getHeader()");
      print("Request of ${API.HOTEL_MEAL_CATEGORIES}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestDefaultCategoryMeals);
      return null;
    }
  }

  Future<void> getHotelMealByCategory(
      Map request,
      Map<String, String> queryParams,
      OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(
          _getUriWithQuery(API.HOTEL_MEAL_BY_CATEGORY, queryParams),
          body: json.encode(request),
          headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestHotelMealByCategory,
          request, API.HOTEL_MEAL_BY_CATEGORY);
      print("Headers of ${API.HOTEL_MEAL_BY_CATEGORY}, $_getHeader()");
      print("Request of ${API.HOTEL_MEAL_BY_CATEGORY}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestDefaultCategoryMeals);
      return null;
    }
  }

  Future<void> addToCartApi(
      Map<String, dynamic> request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.ADD_TO_CART),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestAddToCart, request,
          API.ADD_TO_CART);
      print("Headers of ${API.ADD_TO_CART}, $_getHeader()");
      print("Request of ${API.ADD_TO_CART}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestAddToCart);
      return null;
    }
  }

  Future<void> getCartDetailApi(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.GET_CART_DETAIL),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestGetCartDetail,
          request, API.GET_CART_DETAIL);
      print("Headers of ${API.GET_CART_DETAIL}, $_getHeader()");
      print("Request of ${API.GET_CART_DETAIL}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestGetCartDetail);
      return null;
    }
  }

  Future<void> getBillDetails(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.GET_BILL_DETAIL),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestGetBillDetail,
          request, API.GET_BILL_DETAIL);
      print("Headers of ${API.GET_BILL_DETAIL}, $_getHeader()");
      print("Request of ${API.GET_BILL_DETAIL}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestGetBillDetail);
      return null;
    }
  }

  Future<void> placeOrderApi(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.PLACE_ORDER),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestPlaceOrder, request,
          API.PLACE_ORDER);
      print("Headers of ${API.PLACE_ORDER}, $_getHeader()");
      print("Request of ${API.PLACE_ORDER}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestPlaceOrder);
      return null;
    }
  }

  Future<void> deleteCartItemApi(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.delete(_getUri(API.DELETE_CART_ITEM),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestDeleteCartItem,
          request, API.DELETE_CART_ITEM);
      print("Headers of ${API.DELETE_CART_ITEM}, $_getHeader()");
      print("Request of ${API.DELETE_CART_ITEM}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestDeleteCartItem);
      return null;
    }
  }

  Future<void> getPackageDetailApi(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.PACKAGE_DETAIL),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestPackageDetail,
          request, API.PACKAGE_DETAIL);
      print("Headers of ${API.PACKAGE_DETAIL}, $_getHeader()");
      print("Request of ${API.PACKAGE_DETAIL}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestPackageDetail);
      return null;
    }
  }

  Future<void> searchMealListApi(Map request, Map<String, String> queryParams,
      OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(
          _getUriWithQuery(API.SEARCH_MEAL_LIST, queryParams),
          body: json.encode(request),
          headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestSearchMealList,
          request, API.SEARCH_MEAL_LIST);
      print("Headers of ${API.SEARCH_MEAL_LIST}, $_getHeader()");
      print("Request of ${API.SEARCH_MEAL_LIST}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestSearchMealList);
      return null;
    }
  }

  Future<void> bookSlotApi(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.BOOK_SLOT),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestBookSlot, request,
          API.BOOK_SLOT);
      print("Headers of ${API.BOOK_SLOT}, $_getHeader()");
      print("Request of ${API.BOOK_SLOT}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestBookSlot);
      return null;
    }
  }

  Future<void> getDateSlotApi(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.GET_DATE_SLOT),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestGetDateSlot,
          request, API.GET_DATE_SLOT);
      print("Headers of ${API.GET_DATE_SLOT}, $_getHeader()");
      print("Request of ${API.GET_DATE_SLOT}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestGetDateSlot);
      return null;
    }
  }

  Future<void> getAllRequestApi(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.ALL_REQUEST_LIST),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestGetAllRequestList,
          request, API.ALL_REQUEST_LIST);
      print("Headers of ${API.ALL_REQUEST_LIST}, $_getHeader()");
      print("Request of ${API.ALL_REQUEST_LIST}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestGetAllRequestList);
      return null;
    }
  }

  Future<void> getRequestServiceDetailApi(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(
          _getUri(API.REQUEST_SERVICE_DETAIL),
          body: json.encode(request),
          headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestServiceDetail,
          request, API.REQUEST_SERVICE_DETAIL);
      print("Headers of ${API.REQUEST_SERVICE_DETAIL}, $_getHeader()");
      print("Request of ${API.REQUEST_SERVICE_DETAIL}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestServiceDetail);
      return null;
    }
  }

  Future<void> bookingReviewApi(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.BOOKING_REVIEWS),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestBookingReview,
          request, API.BOOKING_REVIEWS);
      print("Headers of ${API.BOOKING_REVIEWS}, $_getHeader()");
      print("Request of ${API.BOOKING_REVIEWS}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestBookingReview);
      return null;
    }
  }

  Future<void> serviceReviewApi(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.SERVICE_REVIEW),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestServiceReview,
          request, API.SERVICE_REVIEW);
      print("Headers of ${API.SERVICE_REVIEW}, $_getHeader()");
      print("Request of ${API.SERVICE_REVIEW}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestServiceReview);
      return null;
    }
  }

  Future<void> orderReviewApi(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.ORDER_REVIEW),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestOrderReview,
          request, API.ORDER_REVIEW);
      print("Headers of ${API.ORDER_REVIEW}, $_getHeader()");
      print("Request of ${API.ORDER_REVIEW}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestOrderReview);
      return null;
    }
  }

  Future<void> bookingCancelApi(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.BOOKING_CANCEL),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestBookingCancel,
          request, API.BOOKING_CANCEL);
      print("Headers of ${API.BOOKING_CANCEL}, $_getHeader()");
      print("Request of ${API.BOOKING_CANCEL}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestBookingCancel);
      return null;
    }
  }

  Future<void> orderCancelApi(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.ORDER_CANCEL),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestOrderCancel,
          request, API.ORDER_CANCEL);
      print("Headers of ${API.ORDER_CANCEL}, $_getHeader()");
      print("Request of ${API.ORDER_CANCEL}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestOrderCancel);
      return null;
    }
  }

  Future<void> requestCancelApi(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.REQUEST_CANCEL),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestRequestCancel,
          request, API.REQUEST_CANCEL);
      print("Headers of ${API.REQUEST_CANCEL}, $_getHeader()");
      print("Request of ${API.REQUEST_CANCEL}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestRequestCancel);
      return null;
    }
  }

  Future<void> serviceComplaintApi(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.SERVICE_COMPLAINT),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestServiceComplaint,
          request, API.SERVICE_COMPLAINT);
      print("Headers of ${API.SERVICE_COMPLAINT}, $_getHeader()");
      print("Request of ${API.SERVICE_COMPLAINT}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestServiceComplaint);
      return null;
    }
  }

  Future<void> bookingComplaintApi(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.BOOKING_COMPLAINT),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestBookingComplaint,
          request, API.BOOKING_COMPLAINT);
      print("Headers of ${API.BOOKING_COMPLAINT}, $_getHeader()");
      print("Request of ${API.BOOKING_COMPLAINT}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestBookingComplaint);
      return null;
    }
  }

  Future<void> orderComplaintApi(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.ORDER_COMPLAINT),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestOrderComplaint,
          request, API.ORDER_COMPLAINT);
      print("Headers of ${API.ORDER_COMPLAINT}, $_getHeader()");
      print("Request of ${API.ORDER_COMPLAINT}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestOrderComplaint);
      return null;
    }
  }

  Future<void> getNotificationListApi(
      Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.NOTIFICATION_LIST),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(response, responseCallback, API.requestNotificationList,
          request, API.NOTIFICATION_LIST);
      print("Headers of ${API.NOTIFICATION_LIST}, $_getHeader()");
      print("Request of ${API.NOTIFICATION_LIST}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestNotificationList);
      return null;
    }
  }

  Future<void> editProfileApi(
      Map request, OnResponseCallback responseCallback) async {


    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      var multipartReq =
          http.MultipartRequest('POST', _getUri(API.EDIT_PROFILE));
      multipartReq.headers.addAll(_getHeader());
      multipartReq.fields["first_name"] = request["first_name"];
      multipartReq.fields["last_name"] = request["last_name"];
      multipartReq.fields["email"] = request["email"];
      multipartReq.fields["mobile_num"] = request["mobile_num"];
      var imagePath = request["profile_image"];

      if(imagePath != null){
      String? mineType = lookupMimeType(imagePath);

      if (imagePath != null && mineType != null) {
        multipartReq.files.add(await http.MultipartFile.fromPath(
            'profile_image', request["profile_image"], contentType: MediaType(mineType.split("/").first, mineType.split("/").last)));
      }}

      var response = await multipartReq.send();
      _checkResponse(await http.Response.fromStream(response), responseCallback,
          API.requestEditProfile, multipartReq, API.EDIT_PROFILE);
      print("Headers of ${API.EDIT_PROFILE}, $_getHeader()");
      print("Request of ${API.EDIT_PROFILE}, $multipartReq");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestEditProfile);
      return null;
    }
  }

  Future<void> hotelReviewApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(
          _getUri(API.HOTEL_COMMENT_REVIEW),
          body: json.encode(request),
          headers: _getHeader());
      _checkResponse(response, responseCallback,
          API.requestHotelCommentReview, request, API.HOTEL_COMMENT_REVIEW);
      print("Headers of ${API.HOTEL_COMMENT_REVIEW}, $_getHeader()");
      print("Request of ${API.HOTEL_COMMENT_REVIEW}, $request");
    } else {
      responseCallback.onResponseError('error_internet_connection', API.requestHotelCommentReview);
      return null;
    }
  }

  Future<void> changePasswordApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(
          _getUri(API.CHANGE_PASSWORD),
          body: json.encode(request),
          headers: _getHeader());
      _checkResponse(response, responseCallback,
          API.requestChangePassword, request, API.CHANGE_PASSWORD);
      print("Headers of ${API.CHANGE_PASSWORD}, $_getHeader()");
      print("Request of ${API.CHANGE_PASSWORD}, $request");
    } else {
      responseCallback.onResponseError('error_internet_connection', API.requestChangePassword);
      return null;
    }
  }

  Future<void> getOwnerMessageApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(
          _getUri(API.GET_OWNER_MESSAGE),
          body: json.encode(request),
          headers: _getHeader());
      _checkResponse(response, responseCallback,
          API.requestGetOwnerMessage, request, API.GET_OWNER_MESSAGE);
      print("Headers of ${API.GET_OWNER_MESSAGE}, $_getHeader()");
      print("Request of ${API.GET_OWNER_MESSAGE}, $request");
    } else {
      responseCallback.onResponseError('error_internet_connection', API.requestGetOwnerMessage);
      return null;
    }
  }

  Future<void> getMealDetailApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(
          _getUri(API.MEAL_DETAIL),
          body: json.encode(request),
          headers: _getHeader());
      _checkResponse(response, responseCallback,
          API.requestGetMealDetail, request, API.MEAL_DETAIL);
      print("Headers of ${API.MEAL_DETAIL}, $_getHeader()");
      print("Request of ${API.MEAL_DETAIL}, $request");
    } else {
      responseCallback.onResponseError('error_internet_connection', API.requestGetMealDetail);
      return null;
    }
  }

  Future<void> forgotPassword(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.FORGOT_PASSWORD),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.requestForgotPassword, request, API.FORGOT_PASSWORD);
      print("Headers of ${API.FORGOT_PASSWORD}, $_getHeader()");
      print("Request of ${API.FORGOT_PASSWORD}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.requestForgotPassword);
      return null;
    }
  }

  Future<void> getNotesApi(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(_getUri(API.GET_NOTES),
          body: json.encode(request), headers: _getHeader());
      _checkResponse(
          response, responseCallback, API.getNotes, request, API.GET_NOTES);
      print("Headers of ${API.GET_NOTES}, $_getHeader()");
      print("Request of ${API.GET_NOTES}, $request");
    } else {
      responseCallback.onResponseError(
          'error_internet_connection', API.getNotes);
      return null;
    }
  }

  Future<void> getAnnouncementCategory(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(
          _getUri(API.GET_ANNOUNCEMENT_CATEGORY),
          body: json.encode(request),
          headers: _getHeader());
      _checkResponse(response, responseCallback,
          API.requestAnnouncementCategory, request, API.GET_ANNOUNCEMENT_CATEGORY);
      print("Headers of ${API.GET_ANNOUNCEMENT_CATEGORY}, $_getHeader()");
      print("Request of ${API.GET_ANNOUNCEMENT_CATEGORY}, $request");
    } else {
      responseCallback.onResponseError('error_internet_connection', API.requestAnnouncementCategory);
      return null;
    }
  }

  Future<void> getAnnouncement(Map request, OnResponseCallback responseCallback) async {
    bool hasInternet = await NetworkUtils.check();
    if (hasInternet) {
      http.Response response = await http.post(
          _getUri(API.GET_ANNOUNCEMENT),
          body: json.encode(request),
          headers: _getHeader());
      _checkResponse(response, responseCallback,
          API.requestAnnouncement, request, API.GET_ANNOUNCEMENT);
      print("Headers of ${API.GET_ANNOUNCEMENT}, $_getHeader()");
      print("Request of ${API.GET_ANNOUNCEMENT}, $request");
    } else {
      responseCallback.onResponseError('error_internet_connection', API.requestAnnouncement);
      return null;
    }
  }

  Future<void> _checkResponse(http.Response response, responseCallback,
      requestCode, mapRequest, currentURL) async {
    var map = json.decode(utf8.decode(response.bodyBytes));
    switch (map["code"]) {
      case 200:
        print("RESPONSE $currentURL -> ${response.body}");
        responseCallback.onResponseReceived(map, requestCode);
        break;
      // case 204:
      //   responseCallback.onResponseError("No_Data", requestCode);
      //   print("ERROR -> ${response.statusCode}: ${response.body}");
      //   break;
      case 400:
        print("RESPONSE $currentURL -> ${response.body}");
        responseCallback.onResponseReceived(map, requestCode);
        break;

      case 401:
        print("RESPONSE $currentURL -> ${response.body}");
        responseCallback.onResponseReceived(map, requestCode);
        break;
      // case 401:
      // var map = Map();
      // var userModel = await WidgetUtils.fetchUserDetailsFromPreference();
      // map["refresh_token"] = userModel.data.refreshToken;
      // refreshToken(map, responseCallback, _getUri(currentURL), mapRequest,
      //     requestCode);
      // break;
      case 500:
        responseCallback.onResponseError('error_something_wrong', requestCode);
        print("ERROR -> ${response.statusCode}: ${response.body}");
        break;
      default:
        responseCallback.onResponseError('error_something_wrong', requestCode);
        print("ERROR -> ${response.statusCode}: ${response.body}");
        break;
    }
  }

  Map<String, String> _getHeader() {
    print('Token-> Bearer ${Constants.token}');
    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "language": Constants.isEnglishLanguage ? "english" : "chinese",
      "authorization": "Bearer ${Constants.token}"
    };
  }

  Uri _getUri(String path) {
    // var map = {
    //   'lang': Constants.isEnglishLanguage ? "en" : "ar",
    // };
    var url = Uri.https(API.BASE_URL, path);
    print("Normal URL:: $url");
    return url;
  }

  Uri _getUriWithQuery(String path, Map<String, String> queryParams) {
    var url = Uri.https(API.BASE_URL, path, queryParams);
    print("Query URL:: $url");
    return url;
  }
}
