class AiTestHomeResponse {
  final bool success;
  final AiTestData data;

  AiTestHomeResponse({required this.success, required this.data});

  factory AiTestHomeResponse.fromJson(Map<String, dynamic> json) {
    return AiTestHomeResponse(
      success: json['success'] ?? false,
      data: AiTestData.fromJson(json['data']),
    );
  }
}

class AiTestData {
  final List<AiTestCategory> categories;

  AiTestData({required this.categories});

  factory AiTestData.fromJson(Map<String, dynamic> json) {
    return AiTestData(
      categories:
      (json['categories'] as List)
          .map((e) => AiTestCategory.fromJson(e))
          .toList(),
    );
  }
}

class AiTestCategory {
  final String category;
  final List<AiTestSubCategory> subcategories;

  AiTestCategory({required this.category, required this.subcategories});

  factory AiTestCategory.fromJson(Map<String, dynamic> json) {
    return AiTestCategory(
      category: json['category'] ?? '',
      subcategories:
      (json['subcategories'] as List)
          .map((e) => AiTestSubCategory.fromJson(e))
          .toList(),
    );
  }
}

class AiTestSubCategory {
  final String name;
  final int count;
  final List<AiTestItem> tests;

  AiTestSubCategory({
    required this.name,
    required this.count,
    required this.tests,
  });

  factory AiTestSubCategory.fromJson(Map<String, dynamic> json) {
    return AiTestSubCategory(
      name: json['name'] ?? '',
      count: json['count'] ?? 0,
      tests:
      (json['tests'] as List).map((e) => AiTestItem.fromJson(e)).toList(),
    );
  }
}

class AiTestItem {
  final String testId;
  final String name;
  final String description;
  final String category;
  final String subcategory;
  final String imageUrl;
  final String estimatedTime;
  final String instructions;
  final int totalQuestions;
  final int testMaximumMarks;

  AiTestItem({
    required this.testId,
    required this.name,
    required this.description,
    required this.category,
    required this.subcategory,
    required this.imageUrl,
    required this.totalQuestions,
    required this.testMaximumMarks,
    required this.estimatedTime,
    required this.instructions,
  });

  factory AiTestItem.fromJson(Map<String, dynamic> json) {
    return AiTestItem(
      testId: json['test_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      totalQuestions: json['totalQuestions'] ?? '',
      testMaximumMarks: json['testMaximumMarks'] ?? 0,
      subcategory: json['subcategory'] ?? '',
      imageUrl: json['image_url'] ?? '',
      estimatedTime: json['estimated_time'] ?? '',
      instructions: json['instructions'] ?? '',
    );
  }
}
