class BaseResponseModel {
  int? code;
  int? status;
  String? msg;

  BaseResponseModel({this.code, this.status, this.msg});

  BaseResponseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    data['msg'] = this.msg;
    return data;
  }
}
