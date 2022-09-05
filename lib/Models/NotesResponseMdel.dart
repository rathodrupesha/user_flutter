class NotesResponseModel {
  int? code;
  int? status;
  String? msg;
  NotesData? data;

  NotesResponseModel({this.code, this.status, this.msg, this.data});

  NotesResponseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? new NotesData.fromJson(json['data']) : null;
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

class NotesData {
  int? count;
  List<NotesRow>? rows;

  NotesData({this.count, this.rows});

  NotesData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      rows = <NotesRow>[];
      json['rows'].forEach((v) {
        rows!.add(new NotesRow.fromJson(v));
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

class NotesRow {
  int? id;
  String? notes;
  int? hotelId;
  String? createdAt;

  NotesRow({this.id, this.notes, this.hotelId, this.createdAt});

  NotesRow.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    notes = json['notes'];
    hotelId = json['hotel_id'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['notes'] = this.notes;
    data['hotel_id'] = this.hotelId;
    data['createdAt'] = this.createdAt;
    return data;
  }
}