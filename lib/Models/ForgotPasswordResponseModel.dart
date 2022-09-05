/// code : 200
/// status : 1
/// msg : "Reset password mail sent successfully."
/// data : null

class ForgotPasswordResponseModel {
  ForgotPasswordResponseModel({
    int? code,
    int? status,
    String? msg,
    dynamic data,
  }) {
    _code = code;
    _status = status;
    _msg = msg;
    _data = data;
  }

  ForgotPasswordResponseModel.fromJson(dynamic json) {
    _code = json['code'];
    _status = json['status'];
    _msg = json['msg'];
    _data = json['data'];
  }

  int? _code;
  int? _status;
  String? _msg;
  dynamic _data;

  ForgotPasswordResponseModel copyWith({
    int? code,
    int? status,
    String? msg,
    dynamic data,
  }) =>
      ForgotPasswordResponseModel(
        code: code ?? _code,
        status: status ?? _status,
        msg: msg ?? _msg,
        data: data ?? _data,
      );

  int? get code => _code;

  int? get status => _status;

  String? get msg => _msg;

  dynamic get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['status'] = _status;
    map['msg'] = _msg;
    map['data'] = _data;
    return map;
  }
}
