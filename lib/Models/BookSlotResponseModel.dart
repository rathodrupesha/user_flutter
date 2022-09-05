class BookSlotResponseModel {
  int? code;
  int? status;
  String? msg;
  String? data;

  BookSlotResponseModel({this.code, this.status, this.msg, this.data});

  BookSlotResponseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    data['msg'] = this.msg;
    data['data'] = this.data;
    return data;
  }
}
