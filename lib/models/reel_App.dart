class ReelForApp {
  bool? success;
  int? count;
  List<Data>? data;

  ReelForApp({this.success, this.count, this.data});

  ReelForApp.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    count = json['count'];
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
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  Metrics? metrics;
  String? sId;
  String? title;
  String? description;
  String? youtubeLink;
  int? order;
  String? createdBy;
  bool? active;
  String? createdAt;
  String? updatedAt;
  String? youtubeId;
  int? iV;
  bool? isEnabled;
  List<String>? viewedBy;
  List<String>? likedBy;
  bool? isPopular;
  List<dynamic>? commentsList; // ✅ fixed here
  String? videoKey;
  String? videoUrl;

  Data({
    this.metrics,
    this.sId,
    this.title,
    this.description,
    this.youtubeLink,
    this.order,
    this.createdBy,
    this.active,
    this.createdAt,
    this.updatedAt,
    this.youtubeId,
    this.iV,
    this.isEnabled,
    this.viewedBy,
    this.likedBy,
    this.isPopular,
    this.commentsList,
    this.videoKey,
    this.videoUrl,
  });

  Data.fromJson(Map<String, dynamic> json) {
    metrics =
        json['metrics'] != null ? Metrics.fromJson(json['metrics']) : null;
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    youtubeLink = json['youtubeLink'];
    order = json['order'];
    createdBy = json['createdBy'];
    active = json['active'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    youtubeId = json['youtubeId'];
    iV = json['__v'];
    isEnabled = json['isEnabled'];
    viewedBy =
        json['viewedBy'] != null ? List<String>.from(json['viewedBy']) : [];
    likedBy = json['likedBy'] != null ? List<String>.from(json['likedBy']) : [];
    isPopular = json['isPopular'];
    commentsList = json['commentsList'] ?? []; // ✅ safe handling
    videoKey = json['videoKey'];
    videoUrl = json['videoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (metrics != null) {
      data['metrics'] = metrics!.toJson();
    }
    data['_id'] = sId;
    data['title'] = title;
    data['description'] = description;
    data['youtubeLink'] = youtubeLink;
    data['order'] = order;
    data['createdBy'] = createdBy;
    data['active'] = active;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['youtubeId'] = youtubeId;
    data['__v'] = iV;
    data['isEnabled'] = isEnabled;
    data['viewedBy'] = viewedBy;
    data['likedBy'] = likedBy;
    data['isPopular'] = isPopular;
    data['commentsList'] = commentsList; // ✅ fixed
    data['videoKey'] = videoKey;
    data['videoUrl'] = videoUrl;
    return data;
  }
}

class Metrics {
  int? views;
  int? likes;
  int? comments;
  int? shares;

  Metrics({this.views, this.likes, this.comments, this.shares});

  Metrics.fromJson(Map<String, dynamic> json) {
    views = json['views'];
    likes = json['likes'];
    comments = json['comments'];
    shares = json['shares'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['views'] = this.views;
    data['likes'] = this.likes;
    data['comments'] = this.comments;
    data['shares'] = this.shares;
    return data;
  }
}
