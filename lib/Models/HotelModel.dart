class HotelModel {
  int? code;
  int? status;
  String? msg;
  HotelData? data;

  HotelModel({this.code, this.status, this.msg, this.data});

  HotelModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    if (json['data'] == "" || json['data'] == null || json['data']['id'] == null) {
      data = HotelData();
    } else {
      data = json['data'] != null ? new HotelData.fromJson(json['data']) : null;
    }
    // data = json['data'] != null ? new HotelData.fromJson(json['data']) : null;
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

class HotelData {
  int? id;
  List<String>? amenities;
  int? hotelId;
  String? hotelName;
  String? hotelTitle;
  String? hotelDescription;
  String? checkInTime;
  String? checkOutTime;
  List<String>? hotelImages;

  HotelData(
      {this.id,
      this.amenities,
      this.hotelId,
      this.hotelName,
      this.hotelTitle,
      this.hotelDescription,
      this.checkInTime,
      this.checkOutTime,
      this.hotelImages});

  HotelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amenities = json['amenities'].cast<String>();
    hotelId = json['hotel_id'];
    hotelName = json['hotel_name'];
    hotelTitle = json['hotel_title'];
    hotelDescription = json['hotel_description'];
    checkInTime = json['check_in_datetime'];
    checkOutTime = json['check_out_datetime'];
    hotelImages = json['hotel_images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amenities'] = this.amenities;
    data['hotel_id'] = this.hotelId;
    data['hotel_name'] = this.hotelName;
    data['hotel_title'] = this.hotelTitle;
    data['hotel_description'] = this.hotelDescription;
    data['hotel_images'] = this.hotelImages;
    data['check_in_datetime'] = this.checkInTime;
    data['check_out_datetime'] = this.checkOutTime;
    return data;
  }
}
