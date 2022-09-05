import 'package:hamrostay/Models/ErrorsModel.dart';

class AddToCartRequestModel {
  int? hotelId;
  List<Carts>? carts;

  AddToCartRequestModel({this.hotelId, this.carts});

  AddToCartRequestModel.fromJson(Map<String, dynamic> json) {
    hotelId = json['hotel_id'];
    if (json['carts'] != null) {
      carts = <Carts>[];
      json['carts'].forEach((v) {
        carts!.add(new Carts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hotel_id'] = this.hotelId;
    if (this.carts != null) {
      data['carts'] = this.carts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Carts {
  int? mealId;
  int? units;

  Carts({this.mealId, this.units});

  Carts.fromJson(Map<String, dynamic> json) {
    mealId = json['meal_id'];
    units = json['units'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['meal_id'] = this.mealId;
    data['units'] = this.units;
    return data;
  }
}
