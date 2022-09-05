class Errors {
  List<String>? serviceId;

  Errors({this.serviceId});

  Errors.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_id'] = this.serviceId;
    return data;
  }
}
