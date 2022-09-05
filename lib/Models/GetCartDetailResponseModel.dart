class GetCartDetailResponseModel {
  int? code;
  int? status;
  String? msg;
  CartDetail? data;

  GetCartDetailResponseModel({this.code, this.status, this.msg, this.data});

  GetCartDetailResponseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? new CartDetail.fromJson(json['data']) : null;
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

class CartDetail {
  int? id;
  List<CartItems>? cartItems;
  int? subTotal;
  int? totalAmount;
  int? discount;
  String? discountType;
  int? discountAmount;
  int? tax;
  int? taxAmount;
  String? taxType;

  CartDetail(
      {this.id,
        this.cartItems,
        this.subTotal,
        this.totalAmount,
        this.discount,
        this.discountType,
        this.discountAmount,
        this.tax,
        this.taxAmount,
        this.taxType});

  CartDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['cart_items'] != null) {
      cartItems = <CartItems>[];
      json['cart_items'].forEach((v) {
        cartItems!.add(new CartItems.fromJson(v));
      });
    }
    subTotal = json['sub_total'];
    totalAmount = json['total_amount'];
    discount = json['discount'];
    discountType = json['discount_type'];
    discountAmount = json['discount_amount'];
    tax = json['tax'];
    taxAmount = json['tax_amount'];
    taxType = json['tax_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.cartItems != null) {
      data['cart_items'] = this.cartItems!.map((v) => v.toJson()).toList();
    }
    data['sub_total'] = this.subTotal;
    data['total_amount'] = this.totalAmount;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['discount_amount'] = this.discountAmount;
    data['tax'] = this.tax;
    data['tax_amount'] = this.taxAmount;
    data['tax_type'] = this.taxType;
    return data;
  }
}

class CartItems {
  int? units;
  int? mealId;
  int? id;
  int? totalPrice;
  String? preparationUnit;
  var preparationTime;
  String? price;
  String? name;
  String? image;
  String? unit;

  CartItems(
      {this.units,
        this.mealId,
        this.id,
        this.totalPrice,
        this.preparationUnit,
        this.preparationTime,
        this.price,
        this.name,
        this.image,
      this.unit});

  CartItems.fromJson(Map<String, dynamic> json) {
    units = json['units'];
    mealId = json['meal_id'];
    id = json['id'];
    totalPrice = json['total_price'];
    preparationUnit = json['preparation_unit'];
    preparationTime = json['preparation_time'];
    price = json['price'];
    name = json['name'];
    image = json['image'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['units'] = this.units;
    data['meal_id'] = this.mealId;
    data['id'] = this.id;
    data['total_price'] = this.totalPrice;
    data['preparation_unit'] = this.preparationUnit;
    data['preparation_time'] = this.preparationTime;
    data['price'] = this.price;
    data['name'] = this.name;
    data['image'] = this.image;
    data['unit'] = this.unit;
    return data;
  }
}
