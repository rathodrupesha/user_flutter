class MealDetailResponseModel {
  int? code;
  int? status;
  String? msg;
  MealData? data;

  MealDetailResponseModel({this.code, this.status, this.msg, this.data});

  MealDetailResponseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? new MealData.fromJson(json['data']) : null;
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

class MealData {
  String? name;
  String? description;
  String? image;
  String? price;
  String? unit;
  var preparationTime;
  var preparationUnit;
  List<String>? categories;
  int count = 0;

  MealData(
      {this.name,
        this.description,
        this.image,
        this.price,
        this.unit,
        this.preparationTime,
        this.preparationUnit,
        this.categories,required this.count});

  MealData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    image = json['image'];
    price = json['price'];
    unit = json['unit'];
    preparationTime = json['preparation_time'];
    preparationUnit = json['preparation_unit'];
    categories = json['categories'].cast<String>();
    count = json['count'] ?? 0;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['price'] = this.price;
    data['unit'] = this.unit;
    data['preparation_time'] = this.preparationTime;
    data['preparation_unit'] = this.preparationUnit;
    data['categories'] = this.categories;
    data['count'] = this.count;
    return data;
  }
}
