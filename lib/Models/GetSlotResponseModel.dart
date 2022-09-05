class GetSlotResponseModel {
  int? code;
  int? status;
  String? msg;
  List<SlotDetail>? data;

  GetSlotResponseModel({this.code, this.status, this.msg, this.data});

  GetSlotResponseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <SlotDetail>[];
      json['data'].forEach((v) {
        data!.add(new SlotDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SlotDetail {
  String? startTime;
  String? endTime;
  int? id;

  SlotDetail({this.startTime, this.endTime, this.id});

  SlotDetail.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['id'] = this.id;
    return data;
  }
}
