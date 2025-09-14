class CoursePlansData {
  bool? success;
  List<Data>? data;

  CoursePlansData({this.success, this.data});

  CoursePlansData.fromJson(Map<String, dynamic> json) {
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
  String? category;
  List<Items>? items;
  String? sId;
  String? name;
  String? description;
  String? clientId;
  int? credits;
  int? mRP;
  int? offerPrice;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? duration;
  String? imageKey;
  String? videoKey;

  Data(
      {this.category,
      this.items,
      this.sId,
      this.name,
      this.description,
      this.clientId,
      this.credits,
      this.mRP,
      this.offerPrice,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.duration,
      this.imageKey,
      this.videoKey});

  Data.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    clientId = json['clientId'];
    credits = json['credits'];
    mRP = json['MRP'];
    offerPrice = json['offerPrice'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    duration = json['duration'];
    imageKey = json['imageKey'];
    videoKey = json['videoKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['clientId'] = this.clientId;
    data['credits'] = this.credits;
    data['MRP'] = this.mRP;
    data['offerPrice'] = this.offerPrice;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['duration'] = this.duration;
    data['imageKey'] = this.imageKey;
    data['videoKey'] = this.videoKey;
    return data;
  }
}

class Items {
  String? sId;
  String? name;
  String? itemType;
  String? referenceId;
  bool? expiresWithPlan;
  int? quantity;
  String? clientId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Items(
      {this.sId,
      this.name,
      this.itemType,
      this.referenceId,
      this.expiresWithPlan,
      this.quantity,
      this.clientId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Items.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    itemType = json['itemType'];
    referenceId = json['referenceId'];
    expiresWithPlan = json['expiresWithPlan'];
    quantity = json['quantity'];
    clientId = json['clientId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['itemType'] = this.itemType;
    data['referenceId'] = this.referenceId;
    data['expiresWithPlan'] = this.expiresWithPlan;
    data['quantity'] = this.quantity;
    data['clientId'] = this.clientId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
