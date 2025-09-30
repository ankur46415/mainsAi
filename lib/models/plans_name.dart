class PlansName {
  final bool success;
  final int totalPlans;
  final List<PlanCategory> data;

  PlansName({
    required this.success,
    required this.totalPlans,
    required this.data,
  });

  factory PlansName.fromJson(Map<String, dynamic> json) {
    return PlansName(
      success: json['success'] ?? false,
      totalPlans: json['totalPlans'] ?? 0,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => PlanCategory.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "totalPlans": totalPlans,
      "data": data.map((e) => e.toJson()).toList(),
    };
  }
}

class PlanCategory {
  final String category;

  PlanCategory({required this.category});

  factory PlanCategory.fromJson(Map<String, dynamic> json) {
    return PlanCategory(category: json['category'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {"category": category};
  }
}
