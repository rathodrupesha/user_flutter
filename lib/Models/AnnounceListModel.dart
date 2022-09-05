class AnnouncementListModel {
  int? code;
  int? status;
  String? msg;
  AnnouncementData? data;

  AnnouncementListModel({this.code, this.status, this.msg, this.data});

  AnnouncementListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? new AnnouncementData.fromJson(json['data']) : null;
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

class AnnouncementData {
  int? count;
  List<AnnouncementDataRows>? rows;
  int? totalPages;
  int? currentPage;

  AnnouncementData({this.count, this.rows, this.totalPages, this.currentPage});

  AnnouncementData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      rows = <AnnouncementDataRows>[];
      json['rows'].forEach((v) {
        rows!.add(new AnnouncementDataRows.fromJson(v));
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

class AnnouncementDataRows {
  int? id;
  int? categoryId;
  String? title;
  String? description;
  String? image;
  AnnounceCatId? announceCatId;

  AnnouncementDataRows(
      {this.id,
        this.categoryId,
        this.title,
        this.description,
        this.image,
        this.announceCatId});

  AnnouncementDataRows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    announceCatId = json['announce_cat_id'] != null
        ? new AnnounceCatId.fromJson(json['announce_cat_id'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    if (this.announceCatId != null) {
      data['announce_cat_id'] = this.announceCatId!.toJson();
    }
    return data;
  }
}

class AnnounceCatId {
  String? categoryName;

  AnnounceCatId({this.categoryName});

  AnnounceCatId.fromJson(Map<String, dynamic> json) {
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_name'] = this.categoryName;
    return data;
  }
}