class MainServicesModel {
  int? code;
  int? status;
  String? msg;
  MainServicesData? data;

  MainServicesModel({this.code, this.status, this.msg, this.data});

  MainServicesModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null
        ? new MainServicesData.fromJson(json['data'])
        : null;
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

class MainServicesData {
  int? count;
  List<MainServicesRows>? rows;
  int? totalPages;
  int? currentPage;

  MainServicesData({this.count, this.rows, this.totalPages, this.currentPage});

  MainServicesData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      rows = <MainServicesRows>[];
      json['rows'].forEach((v) {
        rows!.add(new MainServicesRows.fromJson(v));
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

class MainServicesRows {
  String? image;
  int? id;
  String? name;

  MainServicesRows({this.image, this.id, this.name});

  MainServicesRows.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
