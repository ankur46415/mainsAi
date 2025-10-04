class SubjectiveOfQuestions {
  bool? success;
  String? message;
  String? totalTime;
  List<Data>? data;

  SubjectiveOfQuestions({
    this.success,
    this.message,
    this.data,
    this.totalTime,
  });

  SubjectiveOfQuestions.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    totalTime = json['total_time'];
    message = json['message'];
    if (json['questions'] != null) {
      data = <Data>[];
      json['questions'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['questions'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  Metadata? metadata;
  String? sId;
  String? question;
  String? detailedAnswer;
  String? modalAnswer;
  List<String>? answerVideoUrls;
  String? languageMode;
  String? evaluationMode;
  String? evaluationType;
  String? evaluationGuideline;
  String? test;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data({
    this.metadata,
    this.sId,
    this.question,
    this.detailedAnswer,
    this.modalAnswer,
    this.answerVideoUrls,
    this.languageMode,
    this.evaluationMode,
    this.evaluationType,
    this.evaluationGuideline,
    this.test,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Data.fromJson(Map<String, dynamic> json) {
    metadata =
        json['metadata'] != null
            ? new Metadata.fromJson(json['metadata'])
            : null;
    sId = json['_id'];
    question = json['question'];
    detailedAnswer = json['detailedAnswer'];
    modalAnswer = json['modalAnswer'];
    answerVideoUrls = json['answerVideoUrls'].cast<String>();
    languageMode = json['languageMode'];
    evaluationMode = json['evaluationMode'];
    evaluationType = json['evaluationType'];
    evaluationGuideline = json['evaluationGuideline'];
    test = json['test'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    data['_id'] = this.sId;
    data['question'] = this.question;
    data['detailedAnswer'] = this.detailedAnswer;
    data['modalAnswer'] = this.modalAnswer;
    data['answerVideoUrls'] = this.answerVideoUrls;
    data['languageMode'] = this.languageMode;
    data['evaluationMode'] = this.evaluationMode;
    data['evaluationType'] = this.evaluationType;
    data['evaluationGuideline'] = this.evaluationGuideline;
    data['test'] = this.test;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Metadata {
  QualityParameters? qualityParameters;
  List<String>? keywords;
  String? difficultyLevel;
  int? wordLimit;
  int? estimatedTime;
  int? maximumMarks;

  Metadata({
    this.qualityParameters,
    this.keywords,
    this.difficultyLevel,
    this.wordLimit,
    this.estimatedTime,
    this.maximumMarks,
  });

  Metadata.fromJson(Map<String, dynamic> json) {
    qualityParameters =
        json['qualityParameters'] != null
            ? new QualityParameters.fromJson(json['qualityParameters'])
            : null;
    keywords = json['keywords'].cast<String>();
    difficultyLevel = json['difficultyLevel'];
    wordLimit = json['wordLimit'];
    estimatedTime = json['estimatedTime'];
    maximumMarks = json['maximumMarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.qualityParameters != null) {
      data['qualityParameters'] = this.qualityParameters!.toJson();
    }
    data['keywords'] = this.keywords;
    data['difficultyLevel'] = this.difficultyLevel;
    data['wordLimit'] = this.wordLimit;
    data['estimatedTime'] = this.estimatedTime;
    data['maximumMarks'] = this.maximumMarks;
    return data;
  }
}

class QualityParameters {
  Body? body;
  bool? intro;
  bool? conclusion;
  List<String>? customParams;

  QualityParameters({
    this.body,
    this.intro,
    this.conclusion,
    this.customParams,
  });

  QualityParameters.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
    intro = json['intro'];
    conclusion = json['conclusion'];
    customParams = json['customParams'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    data['intro'] = this.intro;
    data['conclusion'] = this.conclusion;
    data['customParams'] = this.customParams;
    return data;
  }
}

class Body {
  bool? enabled;
  bool? features;
  bool? examples;
  bool? facts;
  bool? diagram;

  Body({this.enabled, this.features, this.examples, this.facts, this.diagram});

  Body.fromJson(Map<String, dynamic> json) {
    enabled = json['enabled'];
    features = json['features'];
    examples = json['examples'];
    facts = json['facts'];
    diagram = json['diagram'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['enabled'] = this.enabled;
    data['features'] = this.features;
    data['examples'] = this.examples;
    data['facts'] = this.facts;
    data['diagram'] = this.diagram;
    return data;
  }
}
