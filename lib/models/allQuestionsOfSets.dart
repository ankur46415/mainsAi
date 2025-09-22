class AllQuestionsOfSets {
  bool? success;
  List<Questions>? questions;

  AllQuestionsOfSets({this.success, this.questions});

  AllQuestionsOfSets.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = this.success;
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  String? sId;
  String? question;
  String? setId;
  Metadata? metadata;

  Questions({this.sId, this.question, this.setId, this.metadata});

  Questions.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    question = json['question'];
    setId = json['setId'];
    metadata =
        json['metadata'] != null
            ? new Metadata.fromJson(json['metadata'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['question'] = this.question;
    data['setId'] = this.setId;
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    return data;
  }
}

class Metadata {
  String? difficultyLevel;
  int? maximumMarks;
  int? estimatedTime;
  int? wordLimit;

  Metadata({
    this.difficultyLevel,
    this.maximumMarks,
    this.estimatedTime,
    this.wordLimit,
  });

  Metadata.fromJson(Map<String, dynamic> json) {
    difficultyLevel = json['difficultyLevel'];
    maximumMarks = json['maximumMarks'];
    estimatedTime = json['estimatedTime'];
    wordLimit = json['wordLimit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['difficultyLevel'] = this.difficultyLevel;
    data['maximumMarks'] = this.maximumMarks;
    data['estimatedTime'] = this.estimatedTime;
    data['wordLimit'] = this.wordLimit;
    return data;
  }
}
