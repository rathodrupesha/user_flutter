class InRoomSpecialsModel {
  int? code;
  int? status;
  String? msg;
  List<InRoomSpecialsData>? data;

  InRoomSpecialsModel({this.code, this.status, this.msg, this.data});

  InRoomSpecialsModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <InRoomSpecialsData>[];
      json['data'].forEach((v) {
        data!.add(new InRoomSpecialsData.fromJson(v));
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

class InRoomSpecialsData {
  int? categoryId;
  String? category;
  String? image;
  List<Meals>? meals;

  InRoomSpecialsData({this.categoryId, this.category, this.meals});

  InRoomSpecialsData.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    category = json['category'];
    image = json['category_image'];
    if (json['meals'] != null) {
      meals = <Meals>[];
      json['meals'].forEach((v) {
        meals!.add(new Meals.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category'] = this.category;
    data['category_image'] = this.image;
    if (this.meals != null) {
      data['meals'] = this.meals!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Meals {
  int? id;
  String? name;
  String? image;
  String? price;
  String? unit;
  var preparationTime;
  String? preparationUnit;
  String? description;
  int count = 0;

  Meals(
      {this.id,
      this.name,
      this.image,
      this.price,
      this.unit,
      this.preparationTime,
      this.preparationUnit,
      this.description,
      required this.count});

  Meals.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    price = json['price'];
    unit = json['unit'];
    preparationTime = json['preparation_time'];
    preparationUnit = json['preparation_unit'];
    description = json['description'];
    count = json['count'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['price'] = this.price;
    data['unit'] = this.unit;
    data['preparation_time'] = this.preparationTime;
    data['preparation_unit'] = this.preparationUnit;
    data['description'] = this.description;
    data['count'] = this.count;
    return data;
  }
}
