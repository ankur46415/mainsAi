class MyWorkBookList {
  bool? success;
  String? message;
  List<Workbooks>? data;

  MyWorkBookList({this.success, this.message, this.data});

  MyWorkBookList.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Workbooks>[];
      json['data'].forEach((v) {
        data!.add(Workbooks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Workbooks {
  String? myWorkbookId;
  String? workbookId;
  String? title;
  String? author;
  String? publisher;
  String? description;
  String? coverImage;
  String? coverImageUrl;
  double? rating;
  num? ratingCount;
  String? mainCategory;
  String? subCategory;
  String? exam;
  String? paper;
  String? subject;
  List<dynamic>? tags;
  num? viewCount;
  String? addedAt;
  String? lastAccessedAt;
  String? personalNote;
  String? priority;

  Workbooks({
    this.myWorkbookId,
    this.workbookId,
    this.title,
    this.author,
    this.publisher,
    this.description,
    this.coverImage,
    this.coverImageUrl,
    this.rating,
    this.ratingCount,
    this.mainCategory,
    this.subCategory,
    this.exam,
    this.paper,
    this.subject,
    this.tags,
    this.viewCount,
    this.addedAt,
    this.lastAccessedAt,
    this.personalNote,
    this.priority,
  });

  Workbooks.fromJson(Map<String, dynamic> json) {
    myWorkbookId = json['_id']?.toString();
    addedAt = json['addedAt']?.toString();
    lastAccessedAt = json['lastAccessedAt']?.toString();
    personalNote = json['personalNote']?.toString();
    priority = json['priority']?.toString();

    if (json['workbookId'] != null) {
      var w = json['workbookId'];
      workbookId = w['_id']?.toString();
      title = w['title']?.toString();
      author = w['author']?.toString();
      publisher = w['publisher']?.toString();
      description = w['description']?.toString();
      coverImage = w['coverImageKey']?.toString();
      coverImageUrl = w['coverImageUrl']?.toString();
      rating =
      (w['rating'] is int)
          ? (w['rating'] as int).toDouble()
          : (w['rating'] is double ? w['rating'] : null);
      ratingCount = w['ratingCount'];
      mainCategory = w['mainCategory']?.toString();
      subCategory = w['subCategory']?.toString();
      exam =
      (w['exam'] == null || w['exam'] == "") ? null : w['exam'].toString();
      paper =
      (w['paper'] == null || w['paper'] == "")
          ? null
          : w['paper'].toString();
      subject =
      (w['subject'] == null || w['subject'] == "")
          ? null
          : w['subject'].toString();
      tags = w['tags'] ?? [];
      viewCount = w['viewCount'];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': myWorkbookId,
      'workbook_id': workbookId,
      'title': title,
      'author': author,
      'publisher': publisher,
      'description': description,
      'cover_image': coverImage,
      'cover_image_url': coverImageUrl,
      'rating': rating,
      'rating_count': ratingCount,
      'main_category': mainCategory,
      'sub_category': subCategory,
      'exam': exam,
      'paper': paper,
      'subject': subject,
      'tags': tags ?? [],
      'view_count': viewCount,
      'added_at': addedAt,
      'last_accessed_at': lastAccessedAt,
      'personal_note': personalNote,
      'priority': priority,
    };
  }
}
