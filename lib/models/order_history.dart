class OrderHistory {
  bool? success;
  Data? data;

  OrderHistory({this.success, this.data});

  OrderHistory.fromJson(Map<String, dynamic> json) {
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
  List<Orders>? orders;
  List<OrderStats>? orderStats;
  Pagination? pagination;

  Data({this.orders, this.orderStats, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
    if (json['orderStats'] != null) {
      orderStats = <OrderStats>[];
      json['orderStats'].forEach((v) {
        orderStats!.add(new OrderStats.fromJson(v));
      });
    }
    pagination =
        json['pagination'] != null
            ? new Pagination.fromJson(json['pagination'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    if (this.orderStats != null) {
      data['orderStats'] = this.orderStats!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Orders {
  String? sId;
  UserId? userId;
  PlanId? planId;
  String? clientId;
  String? orderId;
  int? creditsGranted;
  String? startDate;
  String? endDate;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;
  Payment? payment;

  Orders({
    this.sId,
    this.userId,
    this.planId,
    this.clientId,
    this.orderId,
    this.creditsGranted,
    this.startDate,
    this.endDate,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.payment,
  });

  Orders.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId =
        json['userId'] != null ? new UserId.fromJson(json['userId']) : null;
    planId =
        json['planId'] != null ? new PlanId.fromJson(json['planId']) : null;
    clientId = json['clientId'];
    orderId = json['orderId'];
    creditsGranted = json['creditsGranted'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    payment =
        json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.userId != null) {
      data['userId'] = this.userId!.toJson();
    }
    if (this.planId != null) {
      data['planId'] = this.planId!.toJson();
    }
    data['clientId'] = this.clientId;
    data['orderId'] = this.orderId;
    data['creditsGranted'] = this.creditsGranted;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.payment != null) {
      data['payment'] = this.payment!.toJson();
    }
    return data;
  }
}

class UserId {
  String? sId;
  String? userId;
  String? name;
  String? age;
  String? gender;

  UserId({this.sId, this.userId, this.name, this.age, this.gender});

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    name = json['name'];
    age = json['age'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['age'] = this.age;
    data['gender'] = this.gender;
    return data;
  }
}

class PlanId {
  String? sId;
  String? name;
  String? description;
  String? clientId;
  List<String>? items;

  PlanId({this.sId, this.name, this.description, this.clientId, this.items});

  PlanId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    clientId = json['clientId'];
    items = json['items'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['clientId'] = this.clientId;
    data['items'] = this.items;
    return data;
  }
}

class Payment {
  String? sId;
  int? amount;
  String? status;
  String? createdAt;

  Payment({this.sId, this.amount, this.status, this.createdAt});

  Payment.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    amount = json['amount'];
    status = json['status'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class OrderStats {
  String? sId;
  int? count;
  int? totalCredits;

  OrderStats({this.sId, this.count, this.totalCredits});

  OrderStats.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    count = json['count'];
    totalCredits = json['totalCredits'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['count'] = this.count;
    data['totalCredits'] = this.totalCredits;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? totalOrders;
  bool? hasNextPage;
  bool? hasPrevPage;

  Pagination({
    this.currentPage,
    this.totalPages,
    this.totalOrders,
    this.hasNextPage,
    this.hasPrevPage,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    totalOrders = json['totalOrders'];
    hasNextPage = json['hasNextPage'];
    hasPrevPage = json['hasPrevPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentPage'] = this.currentPage;
    data['totalPages'] = this.totalPages;
    data['totalOrders'] = this.totalOrders;
    data['hasNextPage'] = this.hasNextPage;
    data['hasPrevPage'] = this.hasPrevPage;
    return data;
  }
}
