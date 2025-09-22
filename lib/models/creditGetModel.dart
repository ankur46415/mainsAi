class CreditGetApi {
  bool? success;
  Data? data;

  CreditGetApi({this.success, this.data});

  CreditGetApi.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  UserId? userId;
  String? mobile;
  String? clientId;
  num? balance;
  int? totalEarned;
  int? totalSpent;
  String? status;
  String? lastTransactionDate;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
        this.userId,
        this.mobile,
        this.clientId,
        this.balance,
        this.totalEarned,
        this.totalSpent,
        this.status,
        this.lastTransactionDate,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId =
    json['userId'] != null ? new UserId.fromJson(json['userId']) : null;
    mobile = json['mobile'];
    clientId = json['clientId'];
    balance = json['balance'];
    totalEarned = json['totalEarned'];
    totalSpent = json['totalSpent'];
    status = json['status'];
    lastTransactionDate = json['lastTransactionDate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.userId != null) {
      data['userId'] = this.userId!.toJson();
    }
    data['mobile'] = this.mobile;
    data['clientId'] = this.clientId;
    data['balance'] = this.balance;
    data['totalEarned'] = this.totalEarned;
    data['totalSpent'] = this.totalSpent;
    data['status'] = this.status;
    data['lastTransactionDate'] = this.lastTransactionDate;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class UserId {
  String? userId;
  String? name;

  UserId({this.userId, this.name});

  UserId.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['name'] = this.name;
    return data;
  }
}
