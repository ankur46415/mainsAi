class AddAmountResponse {
  final bool success;
  final List<AddAmount> data;

  AddAmountResponse({required this.success, required this.data});

  factory AddAmountResponse.fromJson(Map<String, dynamic> json) {
    return AddAmountResponse(
      success: json['success'],
      data: List<AddAmount>.from(
        json['data'].map((item) => AddAmount.fromJson(item)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class AddAmount {
  final String id;
  final String name;
  final String description;
  final String clientId;
  final int credits;
  final int mrp;
  final int offerPrice;
  final String status;
  final String createdAt;
  final String updatedAt;
  final int v;

  AddAmount({
    required this.id,
    required this.name,
    required this.description,
    required this.clientId,
    required this.credits,
    required this.mrp,
    required this.offerPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory AddAmount.fromJson(Map<String, dynamic> json) {
    return AddAmount(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      clientId: json['clientId'],
      credits: json['credits'],
      mrp: json['MRP'],
      offerPrice: json['offerPrice'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'clientId': clientId,
      'credits': credits,
      'MRP': mrp,
      'offerPrice': offerPrice,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}
