class CourseVideoDetailes {
  bool? success;
  String? message;
  List<Course>? course;

  CourseVideoDetailes({this.success, this.message, this.course});

  CourseVideoDetailes.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['course'] != null) {
      course = <Course>[];
      json['course'].forEach((v) {
        course!.add(new Course.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.course != null) {
      data['course'] = this.course!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Course {
  String? sId;
  String? bookId;
  String? name;
  String? overview;
  String? details;
  String? coverImageKey;
  String? coverImageUrl;
  List<Faculty>? faculty;
  int? iV;

  Course(
      {this.sId,
      this.bookId,
      this.name,
      this.overview,
      this.details,
      this.coverImageKey,
      this.coverImageUrl,
      this.faculty,
      this.iV});

  Course.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    bookId = json['bookId'];
    name = json['name'];
    overview = json['overview'];
    details = json['details'];
    coverImageKey = json['cover_imageKey'];
    coverImageUrl = json['cover_imageUrl'];
    if (json['faculty'] != null) {
      faculty = <Faculty>[];
      json['faculty'].forEach((v) {
        faculty!.add(new Faculty.fromJson(v));
      });
    }
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['bookId'] = this.bookId;
    data['name'] = this.name;
    data['overview'] = this.overview;
    data['details'] = this.details;
    data['cover_imageKey'] = this.coverImageKey;
    data['cover_imageUrl'] = this.coverImageUrl;
    if (this.faculty != null) {
      data['faculty'] = this.faculty!.map((v) => v.toJson()).toList();
    }
    data['__v'] = this.iV;
    return data;
  }
}

class Faculty {
  String? name;
  String? about;
  String? facultyImageKey;
  String? facultyImageUrl;
  String? sId;

  Faculty(
      {this.name,
      this.about,
      this.facultyImageKey,
      this.facultyImageUrl,
      this.sId});

  Faculty.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    about = json['about'];
    facultyImageKey = json['faculty_imageKey'];
    facultyImageUrl = json['faculty_imageUrl'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['about'] = this.about;
    data['faculty_imageKey'] = this.facultyImageKey;
    data['faculty_imageUrl'] = this.facultyImageUrl;
    data['_id'] = this.sId;
    return data;
  }
}
