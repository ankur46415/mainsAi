class GetObjectQuestinTest {
  bool? success;
  List<Questions>? questions;
  Pagination? pagination;

  GetObjectQuestinTest({this.success, this.questions, this.pagination});

  GetObjectQuestinTest.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
      });
    }
    pagination =
        json['pagination'] != null
            ? new Pagination.fromJson(json['pagination'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Questions {
  Solution? solution;
  String? sId;
  String? question;
  List<String>? options;
  int? correctAnswer;
  String? difficulty;
  int? estimatedTime;
  int? positiveMarks;
  int? negativeMarks;
  Test? test;
  List<String>? tags; // ✅ fixed here
  bool? isActive;
  String? createdBy;
  int? timesAnswered;
  int? timesCorrect;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Questions({
    this.solution,
    this.sId,
    this.question,
    this.options,
    this.correctAnswer,
    this.difficulty,
    this.estimatedTime,
    this.positiveMarks,
    this.negativeMarks,
    this.test,
    this.tags,
    this.isActive,
    this.createdBy,
    this.timesAnswered,
    this.timesCorrect,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Questions.fromJson(Map<String, dynamic> json) {
    solution =
        json['solution'] != null ? Solution.fromJson(json['solution']) : null;
    sId = json['_id'];
    question = json['question'];
    options =
        json['options'] != null ? List<String>.from(json['options']) : null;
    correctAnswer = json['correctAnswer'];
    difficulty = json['difficulty'];
    estimatedTime = json['estimatedTime'];
    positiveMarks = json['positiveMarks'];
    negativeMarks = json['negativeMarks'];
    test = json['test'] != null ? Test.fromJson(json['test']) : null;
    tags =
        json['tags'] != null
            ? List<String>.from(json['tags'])
            : null; // ✅ fixed here
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    timesAnswered = json['timesAnswered'];
    timesCorrect = json['timesCorrect'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (solution != null) {
      data['solution'] = solution!.toJson();
    }
    data['_id'] = sId;
    data['question'] = question;
    data['options'] = options;
    data['correctAnswer'] = correctAnswer;
    data['difficulty'] = difficulty;
    data['estimatedTime'] = estimatedTime;
    data['positiveMarks'] = positiveMarks;
    data['negativeMarks'] = negativeMarks;
    if (test != null) {
      data['test'] = test!.toJson();
    }
    data['tags'] = tags; // ✅ no .toJson needed for List<String>
    data['isActive'] = isActive;
    data['createdBy'] = createdBy;
    data['timesAnswered'] = timesAnswered;
    data['timesCorrect'] = timesCorrect;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Solution {
  Video? video;
  Image? image;
  String? type;
  String? text;

  Solution({this.video, this.image, this.type, this.text});

  Solution.fromJson(Map<String, dynamic> json) {
    video = json['video'] != null ? new Video.fromJson(json['video']) : null;
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
    type = json['type'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.video != null) {
      data['video'] = this.video!.toJson();
    }
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    data['type'] = this.type;
    data['text'] = this.text;
    return data;
  }
}

class Video {
  String? url;
  String? title;
  String? description;
  int? duration;

  Video({this.url, this.title, this.description, this.duration});

  Video.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    title = json['title'];
    description = json['description'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['title'] = this.title;
    data['description'] = this.description;
    data['duration'] = this.duration;
    return data;
  }
}

class Image {
  String? url;
  String? caption;

  Image({this.url, this.caption});

  Image.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    caption = json['caption'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['caption'] = this.caption;
    return data;
  }
}

class Test {
  String? sId;
  String? name;

  Test({this.sId, this.name});

  Test.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? totalQuestions;
  bool? hasNextPage;
  bool? hasPrevPage;

  Pagination({
    this.currentPage,
    this.totalPages,
    this.totalQuestions,
    this.hasNextPage,
    this.hasPrevPage,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    totalQuestions = json['totalQuestions'];
    hasNextPage = json['hasNextPage'];
    hasPrevPage = json['hasPrevPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentPage'] = this.currentPage;
    data['totalPages'] = this.totalPages;
    data['totalQuestions'] = this.totalQuestions;
    data['hasNextPage'] = this.hasNextPage;
    data['hasPrevPage'] = this.hasPrevPage;
    return data;
  }
}
