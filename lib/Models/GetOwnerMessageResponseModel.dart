class GetOwnerMessageResponseModel {
  int? code;
  int? status;
  OwnerMessageData? data;

  GetOwnerMessageResponseModel({this.code, this.status, this.data});

  GetOwnerMessageResponseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    data = json['data'] != null ? new OwnerMessageData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class OwnerMessageData {
  String? title;
  String? description;

  OwnerMessageData({this.title, this.description});

  OwnerMessageData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}
