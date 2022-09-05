import 'dart:ffi';

import 'package:hamrostay/Models/ErrorsModel.dart';

class SubServicesModel {
  int? code;
  int? status;
  String? msg;
  SubServicesData? data;

  SubServicesModel({this.code, this.status, this.msg, this.data});

  SubServicesModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null
        ? new SubServicesData.fromJson(json['data'])
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

class SubServicesData {
  int? count;
  List<SubServicesRows>? rows;
  int? totalPages;
  int? currentPage;
  Errors? errors = Errors();

  int? id = -1;
  String? name = "";
  String? description = "";
  // List<String>? images;

  SubServicesData({
    this.count,
    this.rows,
    this.totalPages,
    this.currentPage,
    this.errors,
    this.id,
    this.name,
    this.description,
    // this.images,
  });

  SubServicesData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      rows = <SubServicesRows>[];
      json['rows'].forEach((v) {
        rows!.add(new SubServicesRows.fromJson(v));
      });
    }
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
    errors =
        json['errors'] != null ? new Errors.fromJson(json['errors']) : null;
    id = json['id'];
    name = json['name'];
    description = json['description'];
    // images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    data['totalPages'] = this.totalPages;
    data['currentPage'] = this.currentPage;
    if (this.errors != null) {
      data['errors'] = this.errors!.toJson();
    }
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    // data['images'] = this.images;

    return data;
  }
}

class SubServicesRows {
  int? id;
  String? name;
  String? description;
  List<String>? images;
  List<Packages>? packages;
  List<OpeningHours>? openingHours;

  SubServicesRows(
      {this.id, this.name, this.description, this.images, this.packages,this.openingHours});

  SubServicesRows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    if (json['images'] != null) {
      images = json['images'].cast<String>();
    }
    if (json['packages'] != null) {
      packages = <Packages>[];
      json['packages'].forEach((v) {
        packages!.add(new Packages.fromJson(v));
      });
    }

    if (json['OpeningHours'] != null) {
      openingHours = <OpeningHours>[];
      json['OpeningHours'].forEach((v) {
        openingHours!.add(new OpeningHours.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    if (this.images != null) {
      data['images'] = this.images;
    }
    if (this.packages != null) {
      data['packages'] = this.packages!.map((v) => v.toJson()).toList();
    }
    if (this.openingHours != null) {
      data['OpeningHours'] = this.openingHours!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OpeningHours {
  String? days;
  bool? openingStatus;
  String? openTime;
  String? closeTime;

  OpeningHours({this.days, this.openingStatus, this.openTime, this.closeTime});

  OpeningHours.fromJson(Map<String, dynamic> json) {
    days = json['days'];
    openingStatus = json['openingStatus'];
    openTime = json['openTime'];
    closeTime = json['closeTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['days'] = this.days;
    data['openingStatus'] = this.openingStatus;
    data['openTime'] = this.openTime;
    data['closeTime'] = this.closeTime;
    return data;
  }
}
class Packages {
  int? id;
  String? name;
  var duration;
  String? durationUnit;
  String? amount;
  String? amountUnit;

  Packages(
      {this.id,
      this.name,
      this.duration,
      this.durationUnit,
      this.amount,
      this.amountUnit});

  Packages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    duration = json['duration'];
    durationUnit = json['duration_unit'];
    amount = json['amount'];
    amountUnit = json['amount_unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['duration'] = this.duration;
    data['duration_unit'] = this.durationUnit;
    data['amount'] = this.amount;
    data['amount_unit'] = this.amountUnit;
    return data;
  }
}
