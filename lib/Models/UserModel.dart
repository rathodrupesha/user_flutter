class UserModel {
  int? code;
  int? status;
  String? msg;
  UserData? data;

  UserModel({this.code, this.status, this.msg, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    msg = json['msg'];
    if (json['data'] == "") {
      data = null;
    } else {
      data = json['data'] != null ? new UserData.fromJson(json['data']) : null;
    }
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

class UserData {
  int? id;
  String? userName;
  String? email;
  String? accessToken;
  int? hotelId;

  String? firstName;
  String? lastName;
  String? profileImage;
  String? address;
  String? mobileNum;
  String? roomNo;
  User? user;
  // List<String>? amenities;
  String? checkInDatetime;
  String? checkOutDatetime;
  bool? isRememberMe;

  UserData(
      {this.id,
      this.userName,
      this.email,
      this.accessToken,
      this.hotelId,
      this.firstName,
      this.lastName,
      this.profileImage,
      this.address,
      this.mobileNum,
      this.roomNo,
      // this.amenities,
      this.checkInDatetime,
      this.checkOutDatetime,
      this.isRememberMe});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['user_name'];
    email = json['email'];
    accessToken = json['access_token'];
    hotelId = json['hotel_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profileImage = json['profile_image'];
    address = json['address'];
    mobileNum = json['mobile_num'];
    roomNo = json['room_no'];
    // amenities = json['amenities'].cast<String>();
    checkInDatetime = json['check_in_datetime'];
    checkOutDatetime = json['check_out_datetime'];
    isRememberMe = json['remember_me'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_name'] = this.userName;
    data['email'] = this.email;
    data['access_token'] = this.accessToken;
    data['hotel_id'] = this.hotelId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['profile_image'] = this.profileImage;
    data['address'] = this.address;
    data['mobile_num'] = this.mobileNum;
    data['room_no'] = this.roomNo;
    // data['amenities'] = this.amenities;
    data['check_in_datetime'] = this.checkInDatetime;
    data['check_out_datetime'] = this.checkOutDatetime;
    data['remember_me'] = this.isRememberMe;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}
class User {
  int? hotelId;
  String? roomNo;
  CurrentHotel? currentHotel;

  User({this.hotelId, this.roomNo, this.currentHotel});

  User.fromJson(Map<String, dynamic> json) {
    hotelId = json['hotel_id'];
    roomNo = json['room_no'];
    currentHotel = json['current_hotel'] != null
        ? new CurrentHotel.fromJson(json['current_hotel'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hotel_id'] = this.hotelId;
    data['room_no'] = this.roomNo;
    if (this.currentHotel != null) {
      data['current_hotel'] = this.currentHotel!.toJson();
    }
    return data;
  }
}

class CurrentHotel {
  String? hotelName;
  String? currencySymbol;

  CurrentHotel({this.hotelName, this.currencySymbol});

  CurrentHotel.fromJson(Map<String, dynamic> json) {
    hotelName = json['hotel_name'];
    currencySymbol = json['currency_symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hotel_name'] = this.hotelName;
    data['currency_symbol'] = this.currencySymbol;

    return data;
  }
}