class AiTestSubjective {
  bool? success;
  AiTestData? data;
  Meta? meta;

  AiTestSubjective({this.success, this.data, this.meta});

  factory AiTestSubjective.fromJson(Map<String, dynamic> json) {
    return AiTestSubjective(
      success: json['success'],
      data: json['data'] != null ? AiTestData.fromJson(json['data']) : null,
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    if (data != null) 'data': data!.toJson(),
    if (meta != null) 'meta': meta!.toJson(),
  };
}

class AiTestData {
  List<Category>? categories;
  int? totalTests;
  Pagination? pagination;

  AiTestData({this.categories, this.totalTests, this.pagination});

  factory AiTestData.fromJson(Map<String, dynamic> json) {
    return AiTestData(
      categories:
      (json['categories'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e))
          .toList(),
      totalTests: json['totalTests'],
      pagination:
      json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    if (categories != null)
      'categories': categories!.map((e) => e.toJson()).toList(),
    'totalTests': totalTests,
    if (pagination != null) 'pagination': pagination!.toJson(),
  };
}

class Category {
  String? category;
  List<Subcategory>? subcategories;
  int? totalTests;

  Category({this.category, this.subcategories, this.totalTests});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      category: json['category'],
      subcategories:
      (json['subcategories'] as List<dynamic>?)
          ?.map((e) => Subcategory.fromJson(e))
          .toList(),
      totalTests: json['total_tests'],
    );
  }

  Map<String, dynamic> toJson() => {
    'category': category,
    if (subcategories != null)
      'subcategories': subcategories!.map((e) => e.toJson()).toList(),
    'total_tests': totalTests,
  };
}

class Subcategory {
  String? name;
  int? count;
  List<Test>? tests;

  Subcategory({this.name, this.count, this.tests});

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      name: json['name'],
      count: json['count'],
      tests:
      (json['tests'] as List<dynamic>?)
          ?.map((e) => Test.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'count': count,
    if (tests != null) 'tests': tests!.map((e) => e.toJson()).toList(),
  };
}

class Test {
  bool? isEnabled;
  String? testId;
  String? name;
  String? description;
  String? category;
  String? subcategory;
  String? image;
  int? testMaximumMarks;
  String? imageUrl;
  String? estimatedTime;
  String? instructions;
  bool? isTrending;
  bool? isHighlighted;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  UserTestStatus? userTestStatus;
  Test({
    this.isEnabled,
    this.testId,
    this.name,
    this.description,
    this.category,
    this.subcategory,
    this.image,
    this.imageUrl,
    this.estimatedTime,
    this.instructions,
    this.testMaximumMarks,
    this.isTrending,
    this.isHighlighted,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.userTestStatus,
  });

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      isEnabled: json['isEnabled'],
      testId: json['test_id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      subcategory: json['subcategory'],
      testMaximumMarks: json['testMaximumMarks'],
      image: json['image'],
      imageUrl: json['image_url'],
      estimatedTime: json['estimated_time'],
      instructions: json['instructions'],
      isTrending: json['is_trending'],
      isHighlighted: json['is_highlighted'],
      isActive: json['is_active'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      userTestStatus:
      json['userTestStatus'] != null
          ? UserTestStatus.fromJson(json['userTestStatus'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'test_id': testId,
    'isEnabled': isEnabled,
    'name': name,
    'description': description,
    'category': category,
    'subcategory': subcategory,
    'image': image,
    'image_url': imageUrl,
    'estimated_time': estimatedTime,
    'instructions': instructions,
    'testMaximumMarks': testMaximumMarks,
    'is_trending': isTrending,
    'is_highlighted': isHighlighted,
    'is_active': isActive,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'userTestStatus': userTestStatus?.toJson(),
  };
}

class UserTestStatus {
  String? status;
  bool? attempted;
  int? progress;
  int? totalQuestions;
  int? attemptedQuestions;

  UserTestStatus({
    this.status,
    this.attempted,
    this.progress,
    this.totalQuestions,
    this.attemptedQuestions,
  });

  factory UserTestStatus.fromJson(Map<String, dynamic> json) {
    return UserTestStatus(
      status: json['status'],
      attempted: json['attempted'],
      progress: json['progress'],
      totalQuestions: json['totalQuestions'],
      attemptedQuestions: json['attemptedQuestions'],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'attempted': attempted,
    'progress': progress,
    'totalQuestions': totalQuestions,
    'attemptedQuestions': attemptedQuestions,
  };
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? totalItems;
  int? itemsPerPage;
  bool? hasNextPage;
  bool? hasPrevPage;

  Pagination({
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.itemsPerPage,
    this.hasNextPage,
    this.hasPrevPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'],
      totalPages: json['total_pages'],
      totalItems: json['total_items'],
      itemsPerPage: json['items_per_page'],
      hasNextPage: json['has_next_page'],
      hasPrevPage: json['has_prev_page'],
    );
  }

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    'total_pages': totalPages,
    'total_items': totalItems,
    'items_per_page': itemsPerPage,
    'has_next_page': hasNextPage,
    'has_prev_page': hasPrevPage,
  };
}

class Meta {
  String? clientId;
  String? timestamp;
  FiltersApplied? filtersApplied;

  Meta({this.clientId, this.timestamp, this.filtersApplied});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      clientId: json['clientId'],
      timestamp: json['timestamp'],
      filtersApplied:
      json['filters_applied'] != null
          ? FiltersApplied.fromJson(json['filters_applied'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'clientId': clientId,
    'timestamp': timestamp,
    if (filtersApplied != null) 'filters_applied': filtersApplied!.toJson(),
  };
}

class FiltersApplied {
  FiltersApplied();

  factory FiltersApplied.fromJson(Map<String, dynamic> json) {
    return FiltersApplied();
  }

  Map<String, dynamic> toJson() => {};
}
