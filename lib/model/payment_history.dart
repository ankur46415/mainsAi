class PaymentHistory {
  bool? success;
  List<Data>? data;

  PaymentHistory({this.success, this.data});

  PaymentHistory.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? userId;
  String? type;
  int? amount;
  int? balanceBefore;
  int? balanceAfter;
  String? category;
  String? description;
  String? referenceId;
  String? planId;
  int? paymentAmount;
  String? paymentCurrency;
  Metadata? metadata;
  String? status;
  Null? addedBy;
  Null? adminMessage;
  String? createdAt;
  int? iV;

  Data(
      {this.sId,
        this.userId,
        this.type,
        this.amount,
        this.balanceBefore,
        this.balanceAfter,
        this.category,
        this.description,
        this.referenceId,
        this.planId,
        this.paymentAmount,
        this.paymentCurrency,
        this.metadata,
        this.status,
        this.addedBy,
        this.adminMessage,
        this.createdAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    type = json['type'];
    amount = json['amount'];
    balanceBefore = json['balanceBefore'];
    balanceAfter = json['balanceAfter'];
    category = json['category'];
    description = json['description'];
    referenceId = json['referenceId'];
    planId = json['planId'];
    paymentAmount = json['paymentAmount'];
    paymentCurrency = json['paymentCurrency'];
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
    status = json['status'];
    addedBy = json['addedBy'];
    adminMessage = json['adminMessage'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['type'] = this.type;
    data['amount'] = this.amount;
    data['balanceBefore'] = this.balanceBefore;
    data['balanceAfter'] = this.balanceAfter;
    data['category'] = this.category;
    data['description'] = this.description;
    data['referenceId'] = this.referenceId;
    data['planId'] = this.planId;
    data['paymentAmount'] = this.paymentAmount;
    data['paymentCurrency'] = this.paymentCurrency;
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    data['status'] = this.status;
    data['addedBy'] = this.addedBy;
    data['adminMessage'] = this.adminMessage;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Metadata {
  String? gateway;
  String? transactionId;
  String? paytmTxnId;

  Metadata({this.gateway, this.transactionId, this.paytmTxnId});

  Metadata.fromJson(Map<String, dynamic> json) {
    gateway = json['gateway'];
    transactionId = json['transactionId'];
    paytmTxnId = json['paytmTxnId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gateway'] = this.gateway;
    data['transactionId'] = this.transactionId;
    data['paytmTxnId'] = this.paytmTxnId;
    return data;
  }
}
