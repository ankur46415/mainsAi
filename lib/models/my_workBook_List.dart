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
  // Pricing (optional)
  num? MRP;
  num? offerPrice;
  String? currency;

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
    this.MRP,
    this.offerPrice,
    this.currency,
  });

  Workbooks.fromJson(Map<String, dynamic> json) {
    // Parse flat structure from API response
    myWorkbookId = json['myworkbook_id']?.toString();
    workbookId = json['workbook_id']?.toString();
    title = json['title']?.toString();
    author = json['author']?.toString();
    publisher = json['publisher']?.toString();
    description = json['description']?.toString();
    coverImage = json['cover_image']?.toString();
    coverImageUrl = json['cover_image_url']?.toString();
    rating = (json['rating'] is int)
        ? (json['rating'] as int).toDouble()
        : (json['rating'] is double ? json['rating'] : null);
    ratingCount = json['rating_count'];
    mainCategory = json['main_category']?.toString();
    subCategory = json['sub_category']?.toString();
    exam = (json['exam'] == null || json['exam'] == "") ? null : json['exam'].toString();
    paper = (json['paper'] == null || json['paper'] == "")
        ? null
        : json['paper'].toString();
    subject = (json['subject'] == null || json['subject'] == "")
        ? null
        : json['subject'].toString();
    tags = json['tags'] ?? [];
    viewCount = json['view_count'];
    addedAt = json['added_at']?.toString();
    lastAccessedAt = json['last_accessed_at']?.toString();
    personalNote = json['personal_note']?.toString();
    priority = json['priority']?.toString();
    // Pricing (if provided by API)
    MRP = json['MRP'] as num?;
    offerPrice = json['offerPrice'] as num?;
    currency = json['currency']?.toString();
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
      // Pricing
      'MRP': MRP,
      'offerPrice': offerPrice,
      'currency': currency,
    };
  }
}
