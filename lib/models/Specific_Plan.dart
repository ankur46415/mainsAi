class PlanResponse {
  final bool success;
  final PlanData data;

  PlanResponse({required this.success, required this.data});

  factory PlanResponse.fromJson(Map<String, dynamic> json) {
    return PlanResponse(
      success: json['success'] as bool? ?? false,
      data: PlanData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class PlanData {
  final String id;
  final String name;
  final String description;
  final String clientId;
  final int credits;
  final num mrp;
  final num offerPrice;
  final String status;
  final String category;
  final int duration;
  final String imageKey;
  final String videoKey;
  final List<PlanItem> items;
  final bool isEnrolled;

  PlanData({
    required this.id,
    required this.name,
    required this.description,
    required this.clientId,
    required this.credits,
    required this.mrp,
    required this.offerPrice,
    required this.status,
    required this.category,
    required this.duration,
    required this.imageKey,
    required this.videoKey,
    required this.items,
    required this.isEnrolled,
  });

  factory PlanData.fromJson(Map<String, dynamic> json) {
    return PlanData(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      clientId: json['clientId'] as String? ?? '',
      credits: json['credits'] as int? ?? 0,
      mrp: json['MRP'] as num? ?? 0,
      offerPrice: json['offerPrice'] as num? ?? 0,
      status: json['status'] as String? ?? '',
      category: json['category'] as String? ?? '',
      duration: json['duration'] as int? ?? 0,
      imageKey: json['imageKey'] as String? ?? '',
      videoKey: json['videoKey'] as String? ?? '',
      items: (json['items'] as List<dynamic>? ?? <dynamic>[])
          .map((e) => PlanItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      isEnrolled: json['isEnrolled'] as bool? ?? false,
    );
  }
}

class PlanItem {
  final String id;
  final String name;
  final String itemType;
  final String referenceId;
  final bool expiresWithPlan;
  final int quantity;
  final String clientId;
  final ReferencedItem? referencedItem;

  PlanItem({
    required this.id,
    required this.name,
    required this.itemType,
    required this.referenceId,
    required this.expiresWithPlan,
    required this.quantity,
    required this.clientId,
    required this.referencedItem,
  });

  factory PlanItem.fromJson(Map<String, dynamic> json) {
    return PlanItem(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      itemType: json['itemType'] as String? ?? '',
      referenceId: json['referenceId'] as String? ?? '',
      expiresWithPlan: json['expiresWithPlan'] as bool? ?? false,
      quantity: json['quantity'] as int? ?? 0,
      clientId: json['clientId'] as String? ?? '',
      referencedItem: json['referencedItem'] == null
          ? null
          : ReferencedItem.fromJson(
              json['referencedItem'] as Map<String, dynamic>,
            ),
    );
  }
}

class ReferencedItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final String subCategory;
  final String? coverImageUrl;

  ReferencedItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.subCategory,
    required this.coverImageUrl,
  });

  factory ReferencedItem.fromJson(Map<String, dynamic> json) {
    return ReferencedItem(
      id: json['_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      subCategory: json['subCategory'] as String? ?? '',
      coverImageUrl: json['coverImageUrl'] as String?,
    );
  }
}


