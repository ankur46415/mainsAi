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

class Items {
  String? workbookId;
  String? title;
  int? price;
  String? currency;

  Items({this.workbookId, this.title, this.price, this.currency});

  Items.fromJson(Map<String, dynamic> json) {
    workbookId = json['workbookId'];
    title = json['title'];
    price = json['price'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workbookId'] = this.workbookId;
    data['title'] = this.title;
    data['price'] = this.price;
    data['currency'] = this.currency;
    return data;
  }
}
