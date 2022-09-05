class NotificationListModel {
  int? code;
  int? status;
  String? msg;
  NotificationData? data;

  NotificationListModel({this.code, this.status, this.msg, this.data});

  NotificationListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? new NotificationData.fromJson(json['data']) : null;
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

class NotificationData {
  int? count;
  List<NotificationRow>? rows;

  NotificationData({this.count, this.rows});

  NotificationData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['rows'] != null) {
      rows = <NotificationRow>[];
      json['rows'].forEach((v) {
        rows!.add(new NotificationRow.fromJson(v));
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

class NotificationRow {
  int? id;
  int? userId;
  String? title;
  String? message;
  String? createdAt;

  NotificationRow({this.id, this.userId, this.title, this.message, this.createdAt});

  NotificationRow.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    message = json['message'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['message'] = this.message;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
