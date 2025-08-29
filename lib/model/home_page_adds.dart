class HomePageAdds {
  bool? success;
  List<Data>? data;
  Pagination? pagination;

  HomePageAdds({this.success, this.data, this.pagination});

  HomePageAdds.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? name;
  String? category;
  String? subcategory;
  String? imageKey;
  String? imageUrl;
  int? imageWidth;
  int? imageHeight;
  String? imageSize;
  String? location;
  Route? route;
  bool? isActive;
  String? createdBy;
  String? clientId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
      this.name,
      this.category,
      this.subcategory,
      this.imageKey,
      this.imageUrl,
      this.imageWidth,
      this.imageHeight,
      this.imageSize,
      this.location,
      this.route,
      this.isActive,
      this.createdBy,
      this.clientId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    category = json['category'];
    subcategory = json['subcategory'];
    imageKey = json['imageKey'];
    imageUrl = json['imageUrl'];
    imageWidth = json['imageWidth'];
    imageHeight = json['imageHeight'];
    imageSize = json['imageSize'];
    location = json['location'];
    route = json['route'] != null ? new Route.fromJson(json['route']) : null;
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    clientId = json['clientId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['category'] = this.category;
    data['subcategory'] = this.subcategory;
    data['imageKey'] = this.imageKey;
    data['imageUrl'] = this.imageUrl;
    data['imageWidth'] = this.imageWidth;
    data['imageHeight'] = this.imageHeight;
    data['imageSize'] = this.imageSize;
    data['location'] = this.location;
    if (this.route != null) {
      data['route'] = this.route!.toJson();
    }
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['clientId'] = this.clientId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Route {
  String? type;
  Config? config;

  Route({this.type, this.config});

  Route.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    config =
        json['config'] != null ? new Config.fromJson(json['config']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.config != null) {
      data['config'] = this.config!.toJson();
    }
    return data;
  }
}

class Config {
  String? url;
  String? phone;
  String? message;

  Config({this.url, this.phone, this.message});

  Config.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    phone = json['phone'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['phone'] = this.phone;
    data['message'] = this.message;
    return data;
  }
}

class Pagination {
  int? page;
  int? limit;
  int? total;
  int? pages;

  Pagination({this.page, this.limit, this.total, this.pages});

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
    pages = json['pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['total'] = this.total;
    data['pages'] = this.pages;
    return data;
  }
}
