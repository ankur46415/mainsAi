class ProfileData {
  bool? success;
  int? responseCode;
  bool? isProfileComplete;
  Profile? profile;

  ProfileData({
    this.success,
    this.responseCode,
    this.isProfileComplete,
    this.profile,
  });

  ProfileData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    responseCode = json['responseCode'];
    isProfileComplete = json['is_profile_complete'];
    profile =
        json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['responseCode'] = this.responseCode;
    data['is_profile_complete'] = this.isProfileComplete;
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    return data;
  }
}

class Profile {
  String? name;
  String? age;
  String? gender;
  List<String>? exams;
  String? nativeLanguage;
  String? mobile;
  String? createdAt;
  String? updatedAt;
  bool? isEvaluator;
  String? city;
  String? pincode;

  Profile({
    this.name,
    this.age,
    this.gender,
    this.exams,
    this.nativeLanguage,
    this.mobile,
    this.createdAt,
    this.updatedAt,
    this.isEvaluator,
    this.city,
    this.pincode,
  });

  Profile.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    age = json['age'];
    gender = json['gender'];
    exams = json['exams'] != null ? List<String>.from(json['exams']) : null;
    nativeLanguage = json['native_language'];
    mobile = json['mobile'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isEvaluator = json['isEvaluator'];
    city = json['city'];
    pincode = json['pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = this.name;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['exams'] = this.exams;
    data['native_language'] = this.nativeLanguage;
    data['mobile'] = this.mobile;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['isEvaluator'] = this.isEvaluator;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    return data;
  }
}
