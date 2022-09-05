class SearchMealResponseModel {
  int? code;
  int? status;
  String? msg;
  SearchMealData? data;

  SearchMealResponseModel({this.code, this.status, this.msg, this.data});

  SearchMealResponseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? new SearchMealData.fromJson(json['data']) : null;
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

class SearchMealData {
  int? count;
  List<SearchMealDetail>? rows;
  int? totalPages;
  int? currentPage;

  SearchMealData({this.count, this.rows, this.totalPages, this.currentPage});

  SearchMealData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      rows = <SearchMealDetail>[];
      json['rows'].forEach((v) {
        rows!.add(new SearchMealDetail.fromJson(v));
      });
    }
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    data['totalPages'] = this.totalPages;
    data['currentPage'] = this.currentPage;
    return data;
  }
}

class SearchMealDetail {
  int? id;
  String? name;
  String? price;
  String? unit;
  var preparationTime;
  String? preparationUnit;
  String? image;
  String? description;
  List<String>? categories;
  int count = 0;

  SearchMealDetail(
      {this.id,
        this.name,
        this.price,
        this.unit,
        this.preparationTime,
        this.preparationUnit,
        this.image,
        this.description,
        this.categories,
      required this.count});

  SearchMealDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    unit = json['unit'];
    preparationTime = json['preparation_time'];
    preparationUnit = json['preparation_unit'];
    image = json['image'];
    description = json['description'];
    categories = json['categories'].cast<String>();
    count = json['count'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['unit'] = this.unit;
    data['preparation_time'] = this.preparationTime;
    data['preparation_unit'] = this.preparationUnit;
    data['image'] = this.image;
    data['description'] = this.description;
    data['categories'] = this.categories;
    data['count'] = this.count;
    return data;
  }
}
