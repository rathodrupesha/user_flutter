import 'package:hamrostay/Models/ErrorsModel.dart';

class PackageDetailModel {
  int? code;
  int? status;
  String? msg;
  PackageDetails? data;

  PackageDetailModel({this.code, this.status, this.msg, this.data});

  PackageDetailModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? new PackageDetails.fromJson(json['data']) : null;
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

class PackageDetails {
  int? id;
  String? name;
  var duration;
  String? durationUnit;
  String? amount;
  String? amountUnit;
  String? importantNotes;
  List<Slots>? slots;

  PackageDetails(
      {this.id,
        this.name,
        this.duration,
        this.durationUnit,
        this.amount,
        this.amountUnit,
        this.importantNotes,
        this.slots});

  PackageDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    duration = json['duration'];
    durationUnit = json['duration_unit'];
    amount = json['amount'];
    amountUnit = json['amount_unit'];
    importantNotes = json['important_notes'];
    if (json['slots'] != null) {
      slots = <Slots>[];
      json['slots'].forEach((v) {
        slots!.add(new Slots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['duration'] = this.duration;
    data['duration_unit'] = this.durationUnit;
    data['amount'] = this.amount;
    data['amount_unit'] = this.amountUnit;
    data['important_notes'] = this.importantNotes;
    if (this.slots != null) {
      data['slots'] = this.slots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Slots {
  String? date;
  String? startTime;
  String? endTime;

  Slots({this.date, this.startTime, this.endTime});

  Slots.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    return data;
  }
}
