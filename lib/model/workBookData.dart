class WorkBookResponse {
  bool? success;
  num? count;
  num? total;
  List<Workbooks>? workbooks;
  CategoryOrders? categoryOrders;
  List<WorkBookHighlighted>? highlighted;
  List<WorkBookTrending>? trending;

  WorkBookResponse({
    this.success,
    this.count,
    this.total,
    this.workbooks,
    this.categoryOrders,
  });

  factory WorkBookResponse.fromJson(Map<String, dynamic> json) {
    return WorkBookResponse(
      success: json['success'] as bool?,
      count: json['count'] as num?,
      total: json['total'] as num?,
      workbooks:
          (json['workbooks'] as List<dynamic>?)
              ?.map((v) => Workbooks.fromJson(v as Map<String, dynamic>))
              .toList(),
      categoryOrders:
          json['categoryOrders'] != null
              ? CategoryOrders.fromJson(
                json['categoryOrders'] as Map<String, dynamic>,
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    data['count'] = count;
    data['total'] = total;
    if (workbooks != null) {
      data['workbooks'] = workbooks!.map((v) => v.toJson()).toList();
    }
    if (categoryOrders != null) {
      data['categoryOrders'] = categoryOrders!.toJson();
    }
    return data;
  }
}

class WorkBookHighlighted {
  bool? isEnabled;
  bool? isPaid;
  bool? isEnrolled;
  String? sId;
  String? title;
  String? description;
  String? coverImage;
  User? user;
  String? createdAt;
  String? updatedAt;
  num? iV;
  String? author;
  List<Null>? conversations;
  bool? isPublic;
  String? language;
  String? mainCategory;
  String? publisher;
  num? rating;
  num? ratingCount;
  String? subCategory;
  String? summary;
  List<Null>? tags;
  List<Null>? users;
  String? coverImageKey;
  String? coverImageUrl;
  String? clientId;
  String? exam;
  String? paper;
  String? userType;
  num? categoryOrder;
  num? downloadCount;
  String? highlightNote;
  num? highlightOrder;
  String? highlightedAt;
  User? highlightedBy;
  String? highlightedByType;
  bool? isHighlighted;
  bool? isTrending;
  num? shareCount;
  String? subject;
  num? trendingScore;
  num? viewCount;
  String? trendingBy;
  String? trendingByType;
  String? trendingEndDate;
  String? trendingStartDate;
  String? effectiveSubCategory;
  String? fullCategory;
  String? fullClassification;
  bool? isCurrentlyTrending;
  String? id;
  List<PlanDetails>? planDetails;

  WorkBookHighlighted({
    this.isEnabled,
    this.isPaid,
    this.isEnrolled,
    this.sId,
    this.title,
    this.description,
    this.coverImage,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.author,
    this.conversations,
    this.isPublic,
    this.language,
    this.mainCategory,
    this.publisher,
    this.rating,
    this.ratingCount,
    this.subCategory,
    this.summary,
    this.tags,
    this.users,
    this.coverImageKey,
    this.coverImageUrl,
    this.clientId,
    this.exam,
    this.paper,
    this.userType,
    this.categoryOrder,
    this.downloadCount,
    this.highlightNote,
    this.highlightOrder,
    this.highlightedAt,
    this.highlightedBy,
    this.highlightedByType,
    this.isHighlighted,
    this.isTrending,
    this.shareCount,
    this.subject,
    this.trendingScore,
    this.viewCount,
    this.trendingBy,
    this.trendingByType,
    this.trendingEndDate,
    this.trendingStartDate,
    this.effectiveSubCategory,
    this.fullCategory,
    this.fullClassification,
    this.isCurrentlyTrending,
    this.id,
    this.planDetails,
  });

  WorkBookHighlighted.fromJson(Map<String, dynamic> json) {
    isEnabled = json['isEnabled'] as bool?;
    isPaid = json['isPaid'] as bool?;
    isEnrolled = json['isEnrolled'] as bool?;
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    coverImage = json['coverImage'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    author = json['author'];

    isPublic = json['isPublic'];
    language = json['language'];
    mainCategory = json['mainCategory'];
    publisher = json['publisher'];
    rating = json['rating'];
    ratingCount = json['ratingCount'];
    subCategory = json['subCategory'];
    summary = json['summary'];

    coverImageKey = json['coverImageKey'];
    coverImageUrl = json['coverImageUrl'];
    clientId = json['clientId'];
    exam = json['exam'];
    paper = json['paper'];
    userType = json['userType'];
    categoryOrder = json['categoryOrder'];
    downloadCount = json['downloadCount'];
    highlightNote = json['highlightNote'];
    highlightOrder = json['highlightOrder'];
    highlightedAt = json['highlightedAt'];
    highlightedBy =
        json['highlightedBy'] != null
            ? new User.fromJson(json['highlightedBy'])
            : null;
    highlightedByType = json['highlightedByType'];
    isHighlighted = json['isHighlighted'];
    isTrending = json['isTrending'];
    shareCount = json['shareCount'];
    subject = json['subject'];
    trendingScore = json['trendingScore'];
    viewCount = json['viewCount'];
    trendingBy = json['trendingBy'];
    trendingByType = json['trendingByType'];
    trendingEndDate = json['trendingEndDate'];
    trendingStartDate = json['trendingStartDate'];
    effectiveSubCategory = json['effectiveSubCategory'];
    fullCategory = json['fullCategory'];
    fullClassification = json['fullClassification'];
    isCurrentlyTrending = json['isCurrentlyTrending'];
    id = json['id'];
    if (json['planDetails'] != null) {
      planDetails = <PlanDetails>[];
      json['planDetails'].forEach((v) {
        planDetails!.add(PlanDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isEnabled'] = isEnabled;
    data['isPaid'] = isPaid;
    data['isEnrolled'] = isEnrolled;
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['coverImage'] = this.coverImage;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['author'] = this.author;

    data['isPublic'] = this.isPublic;
    data['language'] = this.language;
    data['mainCategory'] = this.mainCategory;
    data['publisher'] = this.publisher;
    data['rating'] = this.rating;
    data['ratingCount'] = this.ratingCount;
    data['subCategory'] = this.subCategory;
    data['summary'] = this.summary;

    data['coverImageKey'] = this.coverImageKey;
    data['coverImageUrl'] = this.coverImageUrl;
    data['clientId'] = this.clientId;
    data['exam'] = this.exam;
    data['paper'] = this.paper;
    data['userType'] = this.userType;
    data['categoryOrder'] = this.categoryOrder;
    data['downloadCount'] = this.downloadCount;
    data['highlightNote'] = this.highlightNote;
    data['highlightOrder'] = this.highlightOrder;
    data['highlightedAt'] = this.highlightedAt;
    if (this.highlightedBy != null) {
      data['highlightedBy'] = this.highlightedBy!.toJson();
    }
    data['highlightedByType'] = this.highlightedByType;
    data['isHighlighted'] = this.isHighlighted;
    data['isTrending'] = this.isTrending;
    data['shareCount'] = this.shareCount;
    data['subject'] = this.subject;
    data['trendingScore'] = this.trendingScore;
    data['viewCount'] = this.viewCount;
    data['trendingBy'] = this.trendingBy;
    data['trendingByType'] = this.trendingByType;
    data['trendingEndDate'] = this.trendingEndDate;
    data['trendingStartDate'] = this.trendingStartDate;
    data['effectiveSubCategory'] = this.effectiveSubCategory;
    data['fullCategory'] = this.fullCategory;
    data['fullClassification'] = this.fullClassification;
    data['isCurrentlyTrending'] = this.isCurrentlyTrending;
    data['id'] = this.id;
    if (this.planDetails != null) {
      data['planDetails'] = this.planDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  String? sId;
  String? name;
  String? email;
  String? userId;

  User({this.sId, this.name, this.email, this.userId});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['userId'] = this.userId;
    return data;
  }
}

class WorkBookTrending {
  bool? isPaid;
  bool? isEnrolled;
  String? sId;
  String? title;
  String? description;
  String? author;
  String? publisher;
  String? language;
  num? rating;
  num? ratingCount;
  List<dynamic>? conversations; // Changed from List<Null> to List<dynamic>?
  List<dynamic>? users; // Changed from List<Null> to List<dynamic>?
  String? summary;
  String? coverImageKey;
  String? coverImageUrl;
  String? mainCategory;
  String? subCategory;
  String? exam;
  String? paper;
  String? subject;
  List<dynamic>? tags; // Changed from List<Null> to List<dynamic>?
  bool? isHighlighted;
  String? highlightedAt;
  dynamic highlightedBy; // Changed from String? to dynamic
  String? highlightedByType;
  num? highlightOrder;
  String? highlightNote;
  num? categoryOrder;
  dynamic categoryOrderBy; // Changed from Null? to dynamic
  dynamic categoryOrderByType; // Changed from Null? to dynamic
  dynamic categoryOrderedAt; // Changed from Null? to dynamic
  bool? isTrending;
  num? trendingScore;
  String? trendingStartDate;
  String? trendingEndDate;
  User? trendingBy;
  String? trendingByType;
  num? viewCount;
  num? downloadCount;
  num? shareCount;
  String? lastViewedAt;
  String? clientId;
  User? user;
  String? userType;
  bool? isPublic;
  String? createdAt;
  String? updatedAt;
  num? iV;
  String? effectiveSubCategory;
  String? fullCategory;
  String? fullClassification;
  bool? isCurrentlyTrending;
  String? id;
  String? coverImage;
  List<PlanDetails>? planDetails;

  WorkBookTrending({
    this.isPaid,
    this.isEnrolled,
    this.sId,
    this.title,
    this.description,
    this.author,
    this.publisher,
    this.language,
    this.rating,
    this.ratingCount,
    this.conversations,
    this.users,
    this.summary,
    this.coverImageKey,
    this.coverImageUrl,
    this.mainCategory,
    this.subCategory,
    this.exam,
    this.paper,
    this.subject,
    this.tags,
    this.isHighlighted,
    this.highlightedAt,
    this.highlightedBy,
    this.highlightedByType,
    this.highlightOrder,
    this.highlightNote,
    this.categoryOrder,
    this.categoryOrderBy,
    this.categoryOrderByType,
    this.categoryOrderedAt,
    this.isTrending,
    this.trendingScore,
    this.trendingStartDate,
    this.trendingEndDate,
    this.trendingBy,
    this.trendingByType,
    this.viewCount,
    this.downloadCount,
    this.shareCount,
    this.lastViewedAt,
    this.clientId,
    this.user,
    this.userType,
    this.isPublic,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.effectiveSubCategory,
    this.fullCategory,
    this.fullClassification,
    this.isCurrentlyTrending,
    this.id,
    this.coverImage,
    this.planDetails,
  });

  WorkBookTrending.fromJson(Map<String, dynamic> json) {
    isPaid = json['isPaid'] as bool?;
    isEnrolled = json['isEnrolled'] as bool?;
    sId = json['_id'] as String?;
    title = json['title'] as String?;
    description = json['description'] as String?;
    author = json['author'] as String?;
    publisher = json['publisher'] as String?;
    language = json['language'] as String?;
    rating = (json['rating'] is num) ? json['rating'] as num : null;

    ratingCount = json['ratingCount'] as num?;
    conversations = json['conversations'] as List<dynamic>?;
    users = json['users'] as List<dynamic>?;
    summary = json['summary'] as String?;
    coverImageKey = json['coverImageKey'] as String?;
    coverImageUrl = json['coverImageUrl'] as String?;
    mainCategory = json['mainCategory'] as String?;
    subCategory = json['subCategory'] as String?;
    exam = json['exam'] as String?;
    paper = json['paper'] as String?;
    subject = json['subject'] as String?;
    tags = json['tags'] as List<dynamic>?;
    isHighlighted = json['isHighlighted'] as bool?;
    highlightedAt = json['highlightedAt'] as String?;
    highlightedBy = json['highlightedBy'];
    highlightedByType = json['highlightedByType'] as String?;
    highlightOrder = json['highlightOrder'] as num?;
    highlightNote = json['highlightNote'] as String?;
    categoryOrder = json['categoryOrder'] as num?;
    categoryOrderBy = json['categoryOrderBy'];
    categoryOrderByType = json['categoryOrderByType'];
    categoryOrderedAt = json['categoryOrderedAt'];
    isTrending = json['isTrending'] as bool?;
    trendingScore = json['trendingScore'] as num?;
    trendingStartDate = json['trendingStartDate'] as String?;
    trendingEndDate = json['trendingEndDate'] as String?;
    trendingBy =
        json['trendingBy'] != null
            ? User.fromJson(json['trendingBy'] as Map<String, dynamic>)
            : null;
    trendingByType = json['trendingByType'] as String?;
    viewCount = json['viewCount'] as num?;
    downloadCount = json['downloadCount'] as num?;
    shareCount = json['shareCount'] as num?;
    lastViewedAt = json['lastViewedAt'] as String?;
    clientId = json['clientId'] as String?;
    user =
        json['user'] != null
            ? User.fromJson(json['user'] as Map<String, dynamic>)
            : null;
    userType = json['userType'] as String?;
    isPublic = json['isPublic'] as bool?;
    createdAt = json['createdAt'] as String?;
    updatedAt = json['updatedAt'] as String?;
    iV = json['__v'] as num?;
    effectiveSubCategory = json['effectiveSubCategory'] as String?;
    fullCategory = json['fullCategory'] as String?;
    fullClassification = json['fullClassification'] as String?;
    isCurrentlyTrending = json['isCurrentlyTrending'] as bool?;
    id = json['id'] as String?;
    coverImage = json['coverImage'] as String?;
    if (json['planDetails'] != null) {
      planDetails = <PlanDetails>[];
      json['planDetails'].forEach((v) {
        planDetails!.add(PlanDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isPaid'] = isPaid;
    data['isEnrolled'] = isEnrolled;
    data['_id'] = sId;
    data['title'] = title;
    data['description'] = description;
    data['author'] = author;
    data['publisher'] = publisher;
    data['language'] = language;
    data['rating'] = rating;
    data['ratingCount'] = ratingCount;
    data['conversations'] = conversations;
    data['users'] = users;
    data['summary'] = summary;
    data['coverImageKey'] = coverImageKey;
    data['coverImageUrl'] = coverImageUrl;
    data['mainCategory'] = mainCategory;
    data['subCategory'] = subCategory;
    data['exam'] = exam;
    data['paper'] = paper;
    data['subject'] = subject;
    data['tags'] = tags;
    data['isHighlighted'] = isHighlighted;
    data['highlightedAt'] = highlightedAt;
    data['highlightedBy'] = highlightedBy;
    data['highlightedByType'] = highlightedByType;
    data['highlightOrder'] = highlightOrder;
    data['highlightNote'] = highlightNote;
    data['categoryOrder'] = categoryOrder;
    data['categoryOrderBy'] = categoryOrderBy;
    data['categoryOrderByType'] = categoryOrderByType;
    data['categoryOrderedAt'] = categoryOrderedAt;
    data['isTrending'] = isTrending;
    data['trendingScore'] = trendingScore;
    data['trendingStartDate'] = trendingStartDate;
    data['trendingEndDate'] = trendingEndDate;
    if (trendingBy != null) {
      data['trendingBy'] = trendingBy!.toJson();
    }
    data['trendingByType'] = trendingByType;
    data['viewCount'] = viewCount;
    data['downloadCount'] = downloadCount;
    data['shareCount'] = shareCount;
    data['lastViewedAt'] = lastViewedAt;
    data['clientId'] = clientId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['userType'] = userType;
    data['isPublic'] = isPublic;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['effectiveSubCategory'] = effectiveSubCategory;
    data['fullCategory'] = fullCategory;
    data['fullClassification'] = fullClassification;
    data['isCurrentlyTrending'] = isCurrentlyTrending;
    data['id'] = id;
    data['coverImage'] = coverImage;
    if (planDetails != null) {
      data['planDetails'] = planDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Workbooks {
  bool? isEnabled;
  bool? isPaid;
  bool? isEnrolled;
  String? exam;
  String? paper;
  String? subject;
  bool? isHighlighted;
  String? highlightedAt;
  dynamic highlightedBy;
  String? highlightedByType;
  num? highlightOrder;
  String? highlightNote;
  num? categoryOrder;
  dynamic categoryOrderBy;
  String? categoryOrderByType;
  String? categoryOrderedAt;
  bool? isTrending;
  num? trendingScore;
  String? trendingStartDate;
  String? trendingEndDate;
  dynamic trendingBy;
  String? trendingByType;
  num? viewCount;
  num? downloadCount;
  num? shareCount;
  String? lastViewedAt;
  String? sId;
  String? title;
  String? description;
  String? coverImage;
  dynamic user;
  String? createdAt;
  String? updatedAt;
  num? iV;
  String? author;
  List<dynamic>? conversations;
  bool? isPublic;
  String? language;
  String? mainCategory;
  String? publisher;
  num? rating;
  num? ratingCount;
  String? subCategory;
  String? summary;

  String? coverImageKey;
  String? coverImageUrl;
  CreatedBy? createdBy;
  dynamic highlightedByUser;
  dynamic trendingByUser;
  dynamic categoryOrderByUser;
  String? clientId;
  String? userType;
  List<PlanDetails>? planDetails;

  Workbooks({
    this.isEnabled,
    this.isPaid,
    this.isEnrolled,
    this.exam,
    this.paper,
    this.subject,
    this.isHighlighted,
    this.highlightedAt,
    this.highlightedBy,
    this.highlightedByType,
    this.highlightOrder,
    this.highlightNote,
    this.categoryOrder,
    this.categoryOrderBy,
    this.categoryOrderByType,
    this.categoryOrderedAt,
    this.isTrending,
    this.trendingScore,
    this.trendingStartDate,
    this.trendingEndDate,
    this.trendingBy,
    this.trendingByType,
    this.viewCount,
    this.downloadCount,
    this.shareCount,
    this.lastViewedAt,
    this.sId,
    this.title,
    this.description,
    this.coverImage,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.author,
    this.conversations,
    this.isPublic,
    this.language,
    this.mainCategory,
    this.publisher,
    this.rating,
    this.ratingCount,
    this.subCategory,
    this.summary,

    this.coverImageKey,
    this.coverImageUrl,
    this.createdBy,
    this.highlightedByUser,
    this.trendingByUser,
    this.categoryOrderByUser,
    this.clientId,
    this.userType,
    this.planDetails,
  });

  factory Workbooks.fromJson(Map<String, dynamic> json) {
    return Workbooks(
      isEnabled: json['isEnabled'] as bool?,
      isPaid: json['isPaid'] as bool?,
      isEnrolled: json['isEnrolled'] as bool?,
      exam: json['exam'] as String?,
      paper: json['paper'] as String?,
      subject: json['subject'] as String?,
      isHighlighted: json['isHighlighted'] as bool?,
      highlightedAt: json['highlightedAt'] as String?,
      highlightedBy: json['highlightedBy'],
      highlightedByType: json['highlightedByType'] as String?,
      highlightOrder: json['highlightOrder'] as num?,
      highlightNote: json['highlightNote'] as String?,
      categoryOrder: json['categoryOrder'] as num?,
      categoryOrderBy: json['categoryOrderBy'],
      categoryOrderByType: json['categoryOrderByType'] as String?,
      categoryOrderedAt: json['categoryOrderedAt'] as String?,
      isTrending: json['isTrending'] as bool?,
      trendingScore: json['trendingScore'] as num?,
      trendingStartDate: json['trendingStartDate'] as String?,
      trendingEndDate: json['trendingEndDate'] as String?,
      trendingBy: json['trendingBy'],
      trendingByType: json['trendingByType'] as String?,
      viewCount: json['viewCount'] as num?,
      downloadCount: json['downloadCount'] as num?,
      shareCount: json['shareCount'] as num?,
      lastViewedAt: json['lastViewedAt'] as String?,
      sId: json['_id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      coverImage: json['coverImage'] as String?,
      user: json['user'],
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      iV: json['__v'] as num?,
      author: json['author'] as String?,
      conversations: json['conversations'] as List<dynamic>?,
      isPublic: json['isPublic'] as bool?,
      language: json['language'] as String?,
      mainCategory: json['mainCategory'] as String?,
      publisher: json['publisher'] as String?,
      rating:
          (json['rating'] is num) ? (json['rating'] as num).toDouble() : null,

      ratingCount: json['ratingCount'] as num?,
      subCategory: json['subCategory'] as String?,
      summary: json['summary'] as String?,

      coverImageKey: json['coverImageKey'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      createdBy:
          json['createdBy'] != null
              ? CreatedBy.fromJson(json['createdBy'] as Map<String, dynamic>)
              : null,
      highlightedByUser: json['highlightedByUser'],
      trendingByUser: json['trendingByUser'],
      categoryOrderByUser: json['categoryOrderByUser'],
      clientId: json['clientId'] as String?,
      userType: json['userType'] as String?,
      planDetails:
          json['planDetails'] != null
              ? (json['planDetails'] as List<dynamic>)
                  .map((v) => PlanDetails.fromJson(v as Map<String, dynamic>))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isEnabled'] = isEnabled;
    data['isPaid'] = isPaid;
    data['isEnrolled'] = isEnrolled;
    data['exam'] = exam;
    data['paper'] = paper;
    data['subject'] = subject;
    data['isHighlighted'] = isHighlighted;
    data['highlightedAt'] = highlightedAt;
    data['highlightedBy'] = highlightedBy;
    data['highlightedByType'] = highlightedByType;
    data['highlightOrder'] = highlightOrder;
    data['highlightNote'] = highlightNote;
    data['categoryOrder'] = categoryOrder;
    data['categoryOrderBy'] = categoryOrderBy;
    data['categoryOrderByType'] = categoryOrderByType;
    data['categoryOrderedAt'] = categoryOrderedAt;
    data['isTrending'] = isTrending;
    data['trendingScore'] = trendingScore;
    data['trendingStartDate'] = trendingStartDate;
    data['trendingEndDate'] = trendingEndDate;
    data['trendingBy'] = trendingBy;
    data['trendingByType'] = trendingByType;
    data['viewCount'] = viewCount;
    data['downloadCount'] = downloadCount;
    data['shareCount'] = shareCount;
    data['lastViewedAt'] = lastViewedAt;
    data['_id'] = sId;
    data['title'] = title;
    data['description'] = description;
    data['coverImage'] = coverImage;
    data['user'] = user;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['author'] = author;
    data['conversations'] = conversations;
    data['isPublic'] = isPublic;
    data['language'] = language;
    data['mainCategory'] = mainCategory;
    data['publisher'] = publisher;
    data['rating'] = rating;
    data['ratingCount'] = ratingCount;
    data['subCategory'] = subCategory;
    data['summary'] = summary;

    data['coverImageKey'] = coverImageKey;
    data['coverImageUrl'] = coverImageUrl;
    if (createdBy != null) {
      data['createdBy'] = createdBy!.toJson();
    }
    data['highlightedByUser'] = highlightedByUser;
    data['trendingByUser'] = trendingByUser;
    data['categoryOrderByUser'] = categoryOrderByUser;
    data['clientId'] = clientId;
    data['userType'] = userType;
    if (planDetails != null) {
      data['planDetails'] = planDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CreatedBy {
  String? id;
  String? userId;
  String? name;
  String? email;

  CreatedBy({this.id, this.userId, this.name, this.email});

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': name,
    'email': email,
  };
}

class CategoryOrders {
  num? teacher;
  num? cs;
  num? civilServices;

  CategoryOrders({this.teacher, this.cs, this.civilServices});

  factory CategoryOrders.fromJson(Map<String, dynamic> json) {
    return CategoryOrders(
      teacher: json['Teacher'] as num?,
      cs: json['CS'] as num?,
      civilServices: json['Civil Services'] as num?,
    );
  }

  Map<String, dynamic> toJson() => {
    'Teacher': teacher,
    'CS': cs,
    'Civil Services': civilServices,
  };
}

class PlanDetails {
  String? id;
  String? name;
  String? description;
  int? mrp;
  int? offerPrice;
  String? category;
  int? duration;
  String? status;

  PlanDetails({
    this.id,
    this.name,
    this.description,
    this.mrp,
    this.offerPrice,
    this.category,
    this.duration,
    this.status,
  });

  PlanDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    mrp = json['mrp'];
    offerPrice = json['offerPrice'];
    category = json['category'];
    duration = json['duration'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['mrp'] = mrp;
    data['offerPrice'] = offerPrice;
    data['category'] = category;
    data['duration'] = duration;
    data['status'] = status;
    return data;
  }
}
