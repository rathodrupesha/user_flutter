class PlaceOrderResponseModel {
  int? code;
  int? status;
  String? msg;
  PlaceOrderData? data;

  PlaceOrderResponseModel({this.code, this.status, this.msg, this.data});

  PlaceOrderResponseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? new PlaceOrderData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class PlaceOrderData {
  String? orderId;
  int? userId;
  int? hotelId;
  String? roomNumber;
  int? tax;
  String? taxType;
  int? totalAmount;
  int? discount;
  String? discountType;
  int? discountAmount;
  int? taxAmount;
  int? subTotal;
  String? comment;
  int? expectedTime;
  String? expectedUnit;
  int? id;

  PlaceOrderData(
      {this.orderId,
        this.userId,
        this.hotelId,
        this.roomNumber,
        this.tax,
        this.taxType,
        this.totalAmount,
        this.discount,
        this.discountType,
        this.discountAmount,
        this.taxAmount,
        this.subTotal,
        this.comment,
        this.expectedTime,
        this.expectedUnit,
        this.id});

  PlaceOrderData.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    userId = json['user_id'];
    hotelId = json['hotel_id'];
    roomNumber = json['room_number'];
    tax = json['tax'];
    taxType = json['tax_type'];
    totalAmount = json['total_amount'];
    discount = json['discount'];
    discountType = json['discount_type'];
    discountAmount = json['discount_amount'];
    taxAmount = json['tax_amount'];
    subTotal = json['sub_total'];
    comment = json['comment'];
    expectedTime = json['expected_time'];
    expectedUnit = json['expected_unit'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['user_id'] = this.userId;
    data['hotel_id'] = this.hotelId;
    data['room_number'] = this.roomNumber;
    data['tax'] = this.tax;
    data['tax_type'] = this.taxType;
    data['total_amount'] = this.totalAmount;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['discount_amount'] = this.discountAmount;
    data['tax_amount'] = this.taxAmount;
    data['sub_total'] = this.subTotal;
    data['comment'] = this.comment;
    data['expected_time'] = this.expectedTime;
    data['expected_unit'] = this.expectedUnit;
    data['id'] = this.id;
    return data;
  }
}
