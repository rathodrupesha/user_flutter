class BillDetailsModel {
  int? code;
  int? status;
  String? msg;
  BillData? data;

  BillDetailsModel({this.code, this.status, this.msg, this.data});

  BillDetailsModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? new BillData.fromJson(json['data']) : null;
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

class BillData {
  List<Result>? result;
  TotalDetails? totalDetails;

  BillData({this.result, this.totalDetails});

  BillData.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
    totalDetails = json['total_details'] != null
        ? new TotalDetails.fromJson(json['total_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    if (this.totalDetails != null) {
      data['total_details'] = this.totalDetails!.toJson();
    }
    return data;
  }
}

class Result {
  int? id;
  String? orderId;
  String? status;
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
  String? type;
  List<Item>? items;

  Result(
      {this.id,
        this.orderId,
        this.status,
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
        this.type,
        this.items});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    status = json['status'];
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
    type = json['type'];
    if (json['name'] != null) {
      items = <Item>[];
      //if(type == "order"){
        json['name'].forEach((v) {
          items!.add(new Item.fromJson(v));
        });
     // }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['status'] = this.status;
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
    data['type'] = this.type;
    if (this.items != null) {
      data['name'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Item {
  int? id;
  String? name;
  int? units;
  String? pricePerUnit;
  String? totalPrice;

  Item({this.id, this.name, this.units, this.pricePerUnit, this.totalPrice});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    units = json['units'];
    pricePerUnit = json['price_per_unit'];
    totalPrice = json['total_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['units'] = this.units;
    data['price_per_unit'] = this.pricePerUnit;
    data['total_price'] = this.totalPrice;
    return data;
  }
}

class TotalDetails {
  int? id;
  String? additionalAmount;
  //Null? additionalText;
  String? billNumber;
  String? checkInDatetime;
  String? checkOutDatetime;
  String? discount;
  String? finalTotal;
  //Null? paidDate;
  String? roomNumber;
  String? status;
  String? tax;
  String? totalAmount;
  String? totalBillAmount;
  String? currencySymbol;

  TotalDetails(
      {this.id,
        this.additionalAmount,
        //this.additionalText,
        this.billNumber,
        this.checkInDatetime,
        this.checkOutDatetime,
        this.discount,
        this.finalTotal,
        //this.paidDate,
        this.roomNumber,
        this.status,
        this.tax,
        this.totalAmount,
        this.currencySymbol,
        this.totalBillAmount});

  TotalDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    additionalAmount = json['additional_amount'];
    //additionalText = json['additional_text'];
    billNumber = json['bill_number'];
    checkInDatetime = json['check_in_datetime'];
    checkOutDatetime = json['check_out_datetime'];
    discount = json['discount'];
    finalTotal = json['final_total'];
    //paidDate = json['paid_date'];
    roomNumber = json['room_number'];
    status = json['status'];
    tax = json['tax'];
    totalAmount = json['total_amount'];
    totalBillAmount = json['total_bill_amount'];
    currencySymbol = json['currency_symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['additional_amount'] = this.additionalAmount;
    //data['additional_text'] = this.additionalText;
    data['bill_number'] = this.billNumber;
    data['check_in_datetime'] = this.checkInDatetime;
    data['check_out_datetime'] = this.checkOutDatetime;
    data['discount'] = this.discount;
    data['final_total'] = this.finalTotal;
    //data['paid_date'] = this.paidDate;
    data['room_number'] = this.roomNumber;
    data['status'] = this.status;
    data['tax'] = this.tax;
    data['total_amount'] = this.totalAmount;
    data['total_bill_amount'] = this.totalBillAmount;
    data['currency_symbol'] = this.currencySymbol;
    return data;
  }
}