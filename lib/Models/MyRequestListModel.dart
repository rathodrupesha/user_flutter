import 'dart:ui';

import 'package:hamrostay/Utils/Constants.dart';

class MyRequestListModel {
  int? code;
  int? status;
  String? msg;
  List<MyRequestData>? data;

  MyRequestListModel({this.code, this.status, this.msg, this.data});

  MyRequestListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <MyRequestData>[];
      json['data'].forEach((v) {
        data!.add(new MyRequestData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyRequestData {
  int? id;
  String? orderId;
  String? status;
  String? roomNumber;
  String? tax;
  String? taxType;
  String? taxAmount;
  String? discount;
  String? discountType;
  String? discountAmount;
  String? subTotal;
  String? totalAmount;
  String? createdAt;
  String? comment;
  String? expectedTime;
  String? expectedUnit;
  List<OrderItems>? orderItems;
  OrderComplaints? orderComplaints;
  OrderComplaints? requestComplaints;
  OrderComplaints? bookingComplaints;
  CancelOrder? cancelOrders;
  CancelBooking? cancelBookings;
  CancelRequests? cancelRequests;
  OrderReviewId? orderReviewId;
  String? type;
  String? name;
  String? amountUnit;
  int? noOfPerson;
  PremiumServices? premiumServices;
  PremiumPackageServices? premiumPackageServices;

  MyRequestData(
      {this.id,
        this.orderId,
        this.status,
        this.roomNumber,
        this.tax,
        this.taxType,
        this.taxAmount,
        this.discount,
        this.discountType,
        this.discountAmount,
        this.subTotal,
        this.totalAmount,
        this.createdAt,
        this.comment,
        this.expectedTime,
        this.expectedUnit,
        this.orderItems,
        this.orderComplaints,
        this.cancelOrders,
        this.cancelBookings,
        this.cancelRequests,
        this.orderReviewId,
        this.type,
        this.name,
      this.amountUnit});

  String get currentStatus{

    if(status == Constants.serviceStatusPending){
      return "Pending";
    }else if(status == Constants.serviceStatusAccepted){
      return "Accepted";
    }else if(status == Constants.serviceStatusCompleted){
      return "Completed";
    }else if(status == Constants.serviceStatusCanceled){
      return "Canceled";
    }else if(status == Constants.serviceStatusRejected){
      return "Rejected";
    }else if(status == Constants.serviceStatusInProgress){
      return "In Progress";
    }
    return "";
  }

  Color get currentStatusColor{

    if(status == Constants.serviceStatusPending){
      return Constants.appStatusYellowColor;
    }else if(status == Constants.serviceStatusAccepted){
      return Constants.appStatusOrangeColor;
    }else if(status == Constants.serviceStatusCompleted){
      return Constants.appStatusGreenColor;
    }else if(status == Constants.serviceStatusCanceled){
      return Constants.appStatusRedColor;
    }else if(status == Constants.serviceStatusRejected){
      return Constants.appStatusRedColor;
    }else if(status == Constants.serviceStatusInProgress){
      return Constants.appStatusOrangeColor;
    }
    return Constants.appStatusYellowColor;
  }

  String get orderItemString{

    if(orderItems != null) {
      String itemString = '';
      for (var model in orderItems!) {
        itemString += model.qty.toString() + " x " + model.name! + "\n";
      }
      return itemString;
    }else{
      return "";
    }
  }


  MyRequestData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    status = json['status'];
    roomNumber = json['room_number'];
    tax = json['tax'];
    taxType = json['tax_type'];
    taxAmount = json['tax_amount'];
    discount = json['discount'];
    discountType = json['discount_type'];
    discountAmount = json['discount_amount'];
    subTotal = json['sub_total'];
    totalAmount = json['total_amount'];
    createdAt = json['createdAt'];
    comment = json['comment'];
    expectedTime = json['expected_time'];
    expectedUnit = json['expected_unit'];
    amountUnit = json['amount_unit'];
    noOfPerson = json['no_of_person'];
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }
    premiumServices = json['premiumServices'] != null
        ? new PremiumServices.fromJson(json['premiumServices'])
        : null;
    premiumPackageServices = json['premiumPackageServices'] != null
        ? new PremiumPackageServices.fromJson(json['premiumPackageServices'])
        : null;

    orderComplaints = json['order_complaints'] != null
        ? new OrderComplaints.fromJson(json['order_complaints'])
        : json['request_complaints'] != null
        ? new OrderComplaints.fromJson(json['request_complaints'])
        : json['booking_complaints'] != null
        ? new OrderComplaints.fromJson(json['booking_complaints'])
        : null;
    cancelOrders = json['cancel_orders'] != null
        ? new CancelOrder.fromJson(json['cancel_orders'])
        : null;
    cancelBookings = json['cancel_bookings'] != null
        ? new CancelBooking.fromJson(json['cancel_bookings'])
        : null;
    cancelRequests = json['cancel_requests'] != null
        ? new CancelRequests.fromJson(json['cancel_requests'])
        : null;
    orderReviewId = json['orderReviewId'] != null
        ? new OrderReviewId.fromJson(json['orderReviewId'])
        : null;
    type = json['type'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['status'] = this.status;
    data['room_number'] = this.roomNumber;
    data['tax'] = this.tax;
    data['tax_type'] = this.taxType;
    data['tax_amount'] = this.taxAmount;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['discount_amount'] = this.discountAmount;
    data['sub_total'] = this.subTotal;
    data['total_amount'] = this.totalAmount;
    data['createdAt'] = this.createdAt;
    data['comment'] = this.comment;
    data['expected_time'] = this.expectedTime;
    data['expected_unit'] = this.expectedUnit;
    data['amount_unit'] = this.amountUnit;
    data['no_of_person'] = this.noOfPerson;
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    if (this.orderComplaints != null) {
      data['order_complaints'] = this.orderComplaints!.toJson();
    }
    if (this.cancelOrders != null) {
      data['cancel_orders'] = this.cancelOrders!.toJson();
    }
    if (this.cancelBookings != null) {
      data['cancel_bookings'] = this.cancelBookings!.toJson();
    }
    if (this.cancelRequests != null) {
      data['cancel_requests'] = this.cancelRequests!.toJson();
    }
    if (this.orderReviewId != null) {
      data['orderReviewId'] = this.orderReviewId!.toJson();
    }
    if (this.premiumServices != null) {
      data['premiumServices'] = this.premiumServices!.toJson();
    }
    if (this.premiumPackageServices != null) {
      data['premiumPackageServices'] = this.premiumPackageServices!.toJson();
    }

    data['type'] = this.type;
    data['name'] = this.name;
    return data;
  }
}

class OrderItems {
  int? id;
  String? name;
  String? unit;
  int? qty;
  String? pricePerUnit;
  String? totalPrice;

  OrderItems(
      {this.id,
        this.name,
        this.unit,
        this.qty,
        this.pricePerUnit,
        this.totalPrice});

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    unit = json['unit'];
    qty = json['qty'];
    pricePerUnit = json['price_per_unit'];
    totalPrice = json['total_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['unit'] = this.unit;
    data['qty'] = this.qty;
    data['price_per_unit'] = this.pricePerUnit;
    data['total_price'] = this.totalPrice;
    return data;
  }
}

class OrderComplaints {
  int? id;
  String? comment;
  String? status;

  OrderComplaints({this.id, this.comment, this.status});

  String get getComplaintStatus{

    if(status == Constants.serviceStatusPending){
      return "Complaint Raised";
    }else if(status == Constants.serviceStatusResolved){
      return "Complaint Resolved";
    }
    return "";
  }

  Color get getComplaintColor{

    if(status == Constants.serviceStatusPending){
      return Constants.appStatusPurpleColor;
    }else if(status == Constants.serviceStatusResolved){
      return Constants.appStatusGreenColor;
    }
    return Constants.appStatusPurpleColor;
  }

  OrderComplaints.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment'] = this.comment;
    data['status'] = this.status;
    return data;
  }
}

class CancelOrder {
  int? id;
  String? status;
  String? reason;

  CancelOrder({this.id, this.status, this.reason});

  String get currentStatus{

    if(status == Constants.serviceStatusPending){
      return "Pending";
    }else if(status == Constants.serviceStatusAccepted){
      return "Accepted";
    }else if(status == Constants.serviceStatusResolved){
      return "Resolved";
    }else if(status == Constants.serviceStatusCanceled){
      return "Canceled";
    }else if(status == Constants.serviceStatusRejected){
      return "Rejected";
    }
    return "Active";
  }

  Color get currentStatusColor{

    if(status == Constants.serviceStatusPending){
      return Constants.appStatusYellowColor;
    }else if(status == Constants.serviceStatusAccepted){
      return Constants.appStatusOrangeColor;
    }else if(status == Constants.serviceStatusResolved){
      return Constants.appStatusGreenColor;
    }else if(status == Constants.serviceStatusCanceled){
      return Constants.appStatusRedColor;
    }else if(status == Constants.serviceStatusRejected){
      return Constants.appStatusRedColor;
    }
    return Constants.appStatusYellowColor;
  }

  CancelOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['reason'] = this.reason;
    return data;
  }
}

class CancelBooking {
  int? id;
  String? status;
  String? reason;

  CancelBooking({this.id, this.status, this.reason});

  String get currentStatus{

    if(status == Constants.serviceStatusPending){
      return "Pending";
    }else if(status == Constants.serviceStatusAccepted){
      return "Accepted";
    }else if(status == Constants.serviceStatusResolved){
      return "Resolved";
    }else if(status == Constants.serviceStatusCanceled){
      return "Canceled";
    }else if(status == Constants.serviceStatusRejected){
      return "Rejected";
    }
    return "Active";
  }

  Color get currentStatusColor{

    if(status == Constants.serviceStatusPending){
      return Constants.appStatusYellowColor;
    }else if(status == Constants.serviceStatusAccepted){
      return Constants.appStatusOrangeColor;
    }else if(status == Constants.serviceStatusResolved){
      return Constants.appStatusGreenColor;
    }else if(status == Constants.serviceStatusCanceled){
      return Constants.appStatusRedColor;
    }else if(status == Constants.serviceStatusRejected){
      return Constants.appStatusRedColor;
    }
    return Constants.appStatusYellowColor;
  }

  CancelBooking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['reason'] = this.reason;
    return data;
  }
}

class CancelRequests {
  int? id;
  String? status;
  String? reason;

  CancelRequests({this.id, this.status, this.reason});

  String get currentStatus{

    if(status == Constants.serviceStatusPending){
      return "Pending";
    }else if(status == Constants.serviceStatusAccepted){
      return "Accepted";
    }else if(status == Constants.serviceStatusResolved){
      return "Resolved";
    }else if(status == Constants.serviceStatusCanceled){
      return "Canceled";
    }else if(status == Constants.serviceStatusRejected){
      return "Rejected";
    }
    return "Active";
  }

  Color get currentStatusColor{

    if(status == Constants.serviceStatusPending){
      return Constants.appStatusYellowColor;
    }else if(status == Constants.serviceStatusAccepted){
      return Constants.appStatusOrangeColor;
    }else if(status == Constants.serviceStatusResolved){
      return Constants.appStatusGreenColor;
    }else if(status == Constants.serviceStatusCanceled){
      return Constants.appStatusRedColor;
    }else if(status == Constants.serviceStatusRejected){
      return Constants.appStatusRedColor;
    }
    return Constants.appStatusYellowColor;
  }

  CancelRequests.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['reason'] = this.reason;
    return data;
  }
}

class OrderReviewId {
  int? id;
  String? numOfStars;
  String? comments;

  OrderReviewId({this.id, this.numOfStars, this.comments});

  OrderReviewId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    numOfStars = json['num_of_stars'];
    comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['num_of_stars'] = this.numOfStars;
    data['comments'] = this.comments;
    return data;
  }
}
class PremiumPackageServices {
  String? name;
  String? importantNotes;
  var duration;
  String? durationUnit;
  String? amount;
  String? amountUnit;
  String? deletedBy;
  String? deletedAt;

  PremiumPackageServices(
      {this.name,
        this.importantNotes,
        this.duration,
        this.durationUnit,
        this.amount,
        this.amountUnit,
        this.deletedBy,
        this.deletedAt});

  PremiumPackageServices.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    importantNotes = json['important_notes'];
    duration = json['duration'];
    durationUnit = json['duration_unit'];
    amount = json['amount'];
    amountUnit = json['amount_unit'];
    deletedBy = json['deleted_by'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['important_notes'] = this.importantNotes;
    data['duration'] = this.duration;
    data['duration_unit'] = this.durationUnit;
    data['amount'] = this.amount;
    data['amount_unit'] = this.amountUnit;
    data['deleted_by'] = this.deletedBy;
    data['deletedAt'] = this.deletedAt;
    return data;
  }
}
class PremiumServices {
  String? mainImage;
  String? name;
  String? description;
  //Null? discount;
  //Null? discountType;
  String? importantNotes;
  //Null? deletedBy;
  //Null? deletedAt;

  PremiumServices({this.mainImage,
    this.name,
    this.description,
    //this.discount,
    //this.discountType,
    this.importantNotes,
    //this.deletedBy,
    /*this.deletedAt*/});

  PremiumServices.fromJson(Map<String, dynamic> json) {
    mainImage = json['main_image'];
    name = json['name'];
    description = json['description'];
    //discount = json['discount'];
    //discountType = json['discount_type'];
    importantNotes = json['important_notes'];
    //deletedBy = json['deleted_by'];
    //deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['main_image'] = this.mainImage;
    data['name'] = this.name;
    data['description'] = this.description;
    //data['discount'] = this.discount;
    //data['discount_type'] = this.discountType;
    data['important_notes'] = this.importantNotes;
    //data['deleted_by'] = this.deletedBy;
    //data['deletedAt'] = this.deletedAt;
    return data;
  }
}