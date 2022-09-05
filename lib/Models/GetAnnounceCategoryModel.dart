class GetAnnouncementCategoryModel {
  int? code;
  int? status;
  String? msg;
  AnnouncementCategoryData? data;

  GetAnnouncementCategoryModel({this.code, this.status, this.msg, this.data});

  GetAnnouncementCategoryModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? new AnnouncementCategoryData.fromJson(json['data']) : null;
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

class AnnouncementCategoryData {
  int? count;
  List<AnnouncementCategoryRows>? rows;

  AnnouncementCategoryData({this.count, this.rows});

  AnnouncementCategoryData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      rows = <AnnouncementCategoryRows>[];
      json['rows'].forEach((v) {
        rows!.add(new AnnouncementCategoryRows.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AnnouncementCategoryRows {
  int? id;
  String? categoryName;
  String? ancCatImage;

  AnnouncementCategoryRows({this.id, this.categoryName, this.ancCatImage});

  AnnouncementCategoryRows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    ancCatImage = json['anc_cat_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['anc_cat_image'] = this.ancCatImage;
    return data;
  }
}

