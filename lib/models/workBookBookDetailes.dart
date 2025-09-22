class WorkBookBookDetailes {
  bool? success;
  int? totalQuestionsCount;
  Workbook? workbook;
  List<Sets>? sets;

  WorkBookBookDetailes({
    this.success,
    this.workbook,
    this.sets,
    this.totalQuestionsCount,
  });

  WorkBookBookDetailes.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    totalQuestionsCount = json['totalQuestionsCount'];
    workbook =
        json['workbook'] != null ? Workbook.fromJson(json['workbook']) : null;
    if (json['sets'] != null) {
      sets = List<Sets>.from(json['sets'].map((x) => Sets.fromJson(x)));
    }
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'totalQuestionsCount': totalQuestionsCount,
    'workbook': workbook?.toJson(),
    'sets': sets?.map((x) => x.toJson()).toList(),
  };
}

class Workbook {
  String? language;
  bool? isPaid;
  bool? isEnrolled;
  num? rating;
  num? ratingCount;
  List<dynamic>? conversations;
  List<dynamic>? users;
  String? summary;
  String? publisher;
  String? author;
  String? coverImageKey;
  String? coverImageUrl;
  String? mainCategory;
  String? subCategory;
  String? exam;
  String? paper;
  String? subject;
  List<dynamic>? tags;
  bool? isHighlighted;
  dynamic highlightedAt;
  dynamic highlightedBy;
  dynamic highlightedByType;
  int? highlightOrder;
  String? highlightNote;
  int? categoryOrder;
  dynamic categoryOrderBy;
  dynamic categoryOrderByType;
  dynamic categoryOrderedAt;
  bool? isTrending;
  int? trendingScore;
  dynamic trendingStartDate;
  dynamic trendingEndDate;
  dynamic trendingBy;
  dynamic trendingByType;
  int? viewCount;
  int? downloadCount;
  int? shareCount;
  dynamic lastViewedAt;
  bool? isPublic;
  String? sId;
  String? title;
  String? description;
  String? coverImage;
  UserMeta? user;
  String? userType;
  String? createdAt;
  String? updatedAt;
  int? iV;
  CreatedBy? createdBy;
  dynamic highlightedByUser;
  UserMeta? trendingByUser;
  dynamic categoryOrderByUser;
  bool? isMyWorkbookAdded;
 List<PlanDetails>? planDetails;
  Workbook({
    this.language,
    this.rating,
    this.ratingCount,
    this.conversations,
    this.publisher,
    this.author,
    this.users,
    this.isPaid,
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
    this.isPublic,
    this.sId,
    this.title,
    this.description,
    this.coverImage,
    this.user,
    this.userType,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.createdBy,
    this.highlightedByUser,
    this.trendingByUser,
    this.categoryOrderByUser,
    this.isMyWorkbookAdded,
    this.isEnrolled,
     this.planDetails,
  });

  Workbook.fromJson(Map<String, dynamic> json) {
    language = json['language'];
    publisher = json['publisher'];
    author = json['author'];
    isPaid = json['isPaid'] as bool?;
    isEnrolled = json['isEnrolled'] as bool?;
    rating = json['rating'];
    ratingCount = json['ratingCount'];
    conversations = json['conversations'];
    users = json['users'];
    summary = json['summary'];
    coverImageKey = json['coverImageKey'];
    coverImageUrl = json['coverImageUrl'];
    mainCategory = json['mainCategory'];
    subCategory = json['subCategory'];
    exam = json['exam'];
    paper = json['paper'];
    subject = json['subject'];
    tags = json['tags'];
    isHighlighted = json['isHighlighted'];
    highlightedAt = json['highlightedAt'];
    highlightedBy = json['highlightedBy'];
    highlightedByType = json['highlightedByType'];
    highlightOrder = json['highlightOrder'];
    highlightNote = json['highlightNote'];
    categoryOrder = json['categoryOrder'];
    categoryOrderBy = json['categoryOrderBy'];
    categoryOrderByType = json['categoryOrderByType'];
    categoryOrderedAt = json['categoryOrderedAt'];
    isTrending = json['isTrending'];
    trendingScore = json['trendingScore'];
    trendingStartDate = json['trendingStartDate'];
    trendingEndDate = json['trendingEndDate'];
    trendingBy = json['trendingBy'];
    trendingByType = json['trendingByType'];
    viewCount = json['viewCount'];
    downloadCount = json['downloadCount'];
    shareCount = json['shareCount'];
    lastViewedAt = json['lastViewedAt'];
    isPublic = json['isPublic'];
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    coverImage = json['coverImage'];
    // Fix for user field: can be String or Map
    if (json['user'] is Map) {
      user = UserMeta.fromJson(json['user']);
    } else if (json['user'] is String) {
      user = UserMeta(id: json['user']);
    } else {
      user = null;
    }
    userType = json['userType'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    createdBy =
        json['createdBy'] != null
            ? CreatedBy.fromJson(json['createdBy'])
            : null;
    highlightedByUser = json['highlightedByUser'];
    trendingByUser =
        json['trendingByUser'] != null
            ? UserMeta.fromJson(json['trendingByUser'])
            : null;
    categoryOrderByUser = json['categoryOrderByUser'];
    isMyWorkbookAdded = json['isMyWorkbookAdded'];
    planDetails = json['planDetails'] != null
        ? List<PlanDetails>.from(
            json['planDetails'].map((x) => PlanDetails.fromJson(x)),
          )
        : null;
  }

  Map<String, dynamic> toJson() => {
    'language': language,
    'publisher': publisher,
    'isPaid': isPaid,
    'isEnrolled': isEnrolled,
    'author': author,
    'rating': rating,
    'ratingCount': ratingCount,
    'conversations': conversations,
    'users': users,
    'summary': summary,
    'coverImageKey': coverImageKey,
    'coverImageUrl': coverImageUrl,
    'mainCategory': mainCategory,
    'subCategory': subCategory,
    'exam': exam,
    'paper': paper,
    'subject': subject,
    'tags': tags,
    'isHighlighted': isHighlighted,
    'highlightedAt': highlightedAt,
    'highlightedBy': highlightedBy,
    'highlightedByType': highlightedByType,
    'highlightOrder': highlightOrder,
    'highlightNote': highlightNote,
    'categoryOrder': categoryOrder,
    'categoryOrderBy': categoryOrderBy,
    'categoryOrderByType': categoryOrderByType,
    'categoryOrderedAt': categoryOrderedAt,
    'isTrending': isTrending,
    'trendingScore': trendingScore,
    'trendingStartDate': trendingStartDate,
    'trendingEndDate': trendingEndDate,
    'trendingBy': trendingBy,
    'trendingByType': trendingByType,
    'viewCount': viewCount,
    'downloadCount': downloadCount,
    'shareCount': shareCount,
    'lastViewedAt': lastViewedAt,
    'isPublic': isPublic,
    '_id': sId,
    'title': title,
    'description': description,
    'coverImage': coverImage,
    'user': user?.toJson(),
    'userType': userType,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    '__v': iV,
    'createdBy': createdBy?.toJson(),
    'highlightedByUser': highlightedByUser,
    'trendingByUser': trendingByUser?.toJson(),
    'categoryOrderByUser': categoryOrderByUser,
    'isMyWorkbookAdded': isMyWorkbookAdded,
    if (planDetails != null) 'planDetails': planDetails!.map((v) => v.toJson()).toList(),
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
class CreatedBy {
  String? id;
  String? name;
  String? email;
  String? userId;

  CreatedBy({this.id, this.name, this.email, this.userId});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'userId': userId,
  };
}

class UserMeta {
  String? id;
  String? name;
  String? email;
  String? userId;

  UserMeta({this.id, this.name, this.email, this.userId});

  UserMeta.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    name = json['name'];
    email = json['email'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'userId': userId,
  };
}

class Sets {
  String? sId;
  String? name;
  String? itemType;
  String? itemId;
  bool? isWorkbook;
  List<dynamic>? questions;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? questionCount;

  Sets({
    this.sId,
    this.name,
    this.itemType,
    this.itemId,
    this.isWorkbook,
    this.questions,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.questionCount,
  });

  Sets.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    itemType = json['itemType'];
    itemId = json['itemId'];
    isWorkbook = json['isWorkbook'];
    questions = json['questions'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    questionCount = json['questionCount'];
  }

  Map<String, dynamic> toJson() => {
    '_id': sId,
    'name': name,
    'itemType': itemType,
    'itemId': itemId,
    'isWorkbook': isWorkbook,
    'questions': questions,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    '__v': iV,
    'questionCount': questionCount,
  };
}
