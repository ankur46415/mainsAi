class CourseLectureModel {
  bool? success;
  String? message;
  List<Lecture>? lectures;

  CourseLectureModel({this.success, this.message, this.lectures});

  CourseLectureModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['lectures'] != null) {
      lectures = <Lecture>[];
      json['lectures'].forEach((v) {
        lectures!.add(Lecture.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    if (lectures != null) {
      data['lectures'] = lectures!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Lecture {
  String? sId;
  String? courseId;
  int? lectureNumber;
  String? lectureName;
  List<Topics>? topics;
  String? lectureDescription;
  int? iV;

  Lecture({
    this.sId,
    this.courseId,
    this.lectureNumber,
    this.lectureName,
    this.topics,
    this.lectureDescription,
    this.iV,
  });

  Lecture.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    courseId = json['courseId'];
    lectureNumber = json['lectureNumber'];
    lectureName = json['lectureName'];
    if (json['topics'] != null) {
      topics = <Topics>[];
      json['topics'].forEach((v) {
        topics!.add(new Topics.fromJson(v));
      });
    }
    lectureDescription = json['lectureDescription'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['courseId'] = this.courseId;
    data['lectureNumber'] = this.lectureNumber;
    data['lectureName'] = this.lectureName;
    if (this.topics != null) {
      data['topics'] = this.topics!.map((v) => v.toJson()).toList();
    }
    data['lectureDescription'] = this.lectureDescription;
    data['__v'] = this.iV;
    return data;
  }
}

class Topics {
  String? topicName;
  String? topicDescription;
  String? videoUrl;
  String? sId;

  Topics({this.topicName, this.topicDescription, this.videoUrl, this.sId});

  Topics.fromJson(Map<String, dynamic> json) {
    topicName = json['topicName'];
    topicDescription = json['topicDescription'];
    videoUrl = json['VideoUrl'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topicName'] = this.topicName;
    data['topicDescription'] = this.topicDescription;
    data['VideoUrl'] = this.videoUrl;
    data['_id'] = this.sId;
    return data;
  }
}
