class GetCartList {
  bool? success;
  Data? data;

  GetCartList({this.success, this.data});

  GetCartList.fromJson(Map<String, dynamic> json) {
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
  String? userId;
  String? clientId;
  List<Items>? items;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data({
    this.sId,
    this.userId,
    this.clientId,
    this.items,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    clientId = json['clientId'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['clientId'] = this.clientId;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class WorkbookId {
  String? id;
  String? title;
  String? coverImageKey;
  String? coverImageUrl;
  int? mrp;
  String? currency;
  String? details;
  int? offerPrice;
  int? validityDays;

  WorkbookId({
    this.id,
    this.title,
    this.coverImageKey,
    this.coverImageUrl,
    this.mrp,
    this.currency,
    this.details,
    this.offerPrice,
    this.validityDays,
  });

  WorkbookId.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    title = json['title'];
    coverImageKey = json['coverImageKey'];
    coverImageUrl = json['coverImageUrl'];
    mrp = json['MRP'];
    currency = json['currency'];
    details = json['details'];
    offerPrice = json['offerPrice'];
    validityDays = json['validityDays'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = id;
    data['title'] = title;
    data['coverImageKey'] = coverImageKey;
    data['coverImageUrl'] = coverImageUrl;
    data['MRP'] = mrp;
    data['currency'] = currency;
    data['details'] = details;
    data['offerPrice'] = offerPrice;
    data['validityDays'] = validityDays;
    return data;
  }
}

class Items {
  WorkbookId? workbookId;
  String? title;
  int? price;
  String? currency;

  Items({this.workbookId, this.title, this.price, this.currency});

  Items.fromJson(Map<String, dynamic> json) {
    workbookId = json['workbookId'] != null
        ? WorkbookId.fromJson(json['workbookId'])
        : null;
    title = json['title'];
    price = json['price'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (workbookId != null) {
      data['workbookId'] = workbookId!.toJson();
    }
    data['title'] = title;
    data['price'] = price;
    data['currency'] = currency;
    return data;
  }
}
