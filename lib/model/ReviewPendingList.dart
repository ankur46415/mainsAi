class ReviewPendingList {
  bool? success;
  Data? data;

  ReviewPendingList({this.success, this.data});

  ReviewPendingList.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Requests>? requests;
  Pagination? pagination;

  Data({this.requests, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['requests'] != null) {
      requests = <Requests>[];
      json['requests'].forEach((v) {
        requests!.add(new Requests.fromJson(v));
      });
    }
    pagination =
        json['pagination'] != null
            ? new Pagination.fromJson(json['pagination'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.requests != null) {
      data['requests'] = this.requests!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Requests {
  ReviewData? reviewData;
  String? sId;
  UserId? userId;
  QuestionId? questionId;
  AnswerId? answerId;
  String? clientId;
  String? requestStatus;
  String? priority;
  String? notes;
  String? requestedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Requests({
    this.reviewData,
    this.sId,
    this.userId,
    this.questionId,
    this.answerId,
    this.clientId,
    this.requestStatus,
    this.priority,
    this.notes,
    this.requestedAt,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Requests.fromJson(Map<String, dynamic> json) {
    reviewData =
        json['reviewData'] != null
            ? new ReviewData.fromJson(json['reviewData'])
            : null;
    sId = json['_id'];
    userId =
        json['userId'] != null ? new UserId.fromJson(json['userId']) : null;
    questionId =
        json['questionId'] != null
            ? new QuestionId.fromJson(json['questionId'])
            : null;
    answerId =
        json['answerId'] != null
            ? new AnswerId.fromJson(json['answerId'])
            : null;
    clientId = json['clientId'];
    requestStatus = json['requestStatus'];
    priority = json['priority'];
    notes = json['notes'];
    requestedAt = json['requestedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.reviewData != null) {
      data['reviewData'] = this.reviewData!.toJson();
    }
    data['_id'] = this.sId;
    if (this.userId != null) {
      data['userId'] = this.userId!.toJson();
    }
    if (this.questionId != null) {
      data['questionId'] = this.questionId!.toJson();
    }
    if (this.answerId != null) {
      data['answerId'] = this.answerId!.toJson();
    }
    data['clientId'] = this.clientId;
    data['requestStatus'] = this.requestStatus;
    data['priority'] = this.priority;
    data['notes'] = this.notes;
    data['requestedAt'] = this.requestedAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class ReviewData {
  List<AnnotatedImage>? annotatedImages;

  ReviewData({this.annotatedImages});

  ReviewData.fromJson(Map<String, dynamic> json) {
    if (json['annotatedImages'] != null) {
      annotatedImages = <AnnotatedImage>[];
      json['annotatedImages'].forEach((v) {
        annotatedImages!.add(AnnotatedImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (annotatedImages != null) {
      data['annotatedImages'] =
          annotatedImages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AnnotatedImage {
  String? imageUrl;
  String? label;

  AnnotatedImage({this.imageUrl, this.label});

  factory AnnotatedImage.fromJson(Map<String, dynamic> json) {
    return AnnotatedImage(imageUrl: json['imageUrl'], label: json['label']);
  }

  Map<String, dynamic> toJson() {
    return {'imageUrl': imageUrl, 'label': label};
  }
}

class UserId {
  String? sId;
  String? mobile;
  String? id;

  UserId({this.sId, this.mobile, this.id});

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    mobile = json['mobile'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['mobile'] = this.mobile;
    data['id'] = this.id;
    return data;
  }
}

class QuestionId {
  Metadata? metadata;
  String? sId;
  String? question;

  QuestionId({this.metadata, this.sId, this.question});

  QuestionId.fromJson(Map<String, dynamic> json) {
    metadata =
        json['metadata'] != null
            ? new Metadata.fromJson(json['metadata'])
            : null;
    sId = json['_id'];
    question = json['question'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    data['_id'] = this.sId;
    data['question'] = this.question;
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
    if (json['keywords'] != null) {
      keywords = (json['keywords'] as List).map((e) => e.toString()).toList();
    } else {
      keywords = [];
    }
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
  List<CustomParam>? customParams;

  QualityParameters({
    this.body,
    this.intro,
    this.conclusion,
    this.customParams,
  });

  QualityParameters.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? Body.fromJson(json['body']) : null;
    intro = json['intro'];
    conclusion = json['conclusion'];
    if (json['customParams'] != null) {
      customParams = <CustomParam>[];
      json['customParams'].forEach((v) {
        customParams!.add(CustomParam.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (body != null) {
      data['body'] = body!.toJson();
    }
    data['intro'] = intro;
    data['conclusion'] = conclusion;
    if (customParams != null) {
      data['customParams'] = customParams!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomParam {
  String? key;
  dynamic value;

  CustomParam({this.key, this.value});

  factory CustomParam.fromJson(Map<String, dynamic> json) {
    return CustomParam(key: json['key'], value: json['value']);
  }

  Map<String, dynamic> toJson() {
    return {'key': key, 'value': value};
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

class AnswerId {
  Evaluation? evaluation;
  String? sId;
  int? attemptNumber;
  List<AnswerImages>? answerImages;
  String? submittedAt;

  AnswerId({
    this.evaluation,
    this.sId,
    this.attemptNumber,
    this.answerImages,
    this.submittedAt,
  });

  AnswerId.fromJson(Map<String, dynamic> json) {
    evaluation =
        json['evaluation'] != null
            ? new Evaluation.fromJson(json['evaluation'])
            : null;
    sId = json['_id'];
    attemptNumber = json['attemptNumber'];
    if (json['answerImages'] != null) {
      answerImages = <AnswerImages>[];
      json['answerImages'].forEach((v) {
        answerImages!.add(new AnswerImages.fromJson(v));
      });
    }
    submittedAt = json['submittedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.evaluation != null) {
      data['evaluation'] = this.evaluation!.toJson();
    }
    data['_id'] = this.sId;
    data['attemptNumber'] = this.attemptNumber;
    if (this.answerImages != null) {
      data['answerImages'] = this.answerImages!.map((v) => v.toJson()).toList();
    }
    data['submittedAt'] = this.submittedAt;
    return data;
  }
}

class Evaluation {
  int? accuracy;
  List<String>? strengths;
  List<String>? weaknesses;
  List<String>? suggestions;
  int? marks;
  String? feedback;
  bool? feedbackStatus;
  UserFeedback? userFeedback;

  Evaluation({
    this.accuracy,
    this.strengths,
    this.weaknesses,
    this.suggestions,
    this.marks,
    this.feedback,
    this.feedbackStatus,
    this.userFeedback,
  });

  Evaluation.fromJson(Map<String, dynamic> json) {
    accuracy = json['accuracy'];
    if (json['strengths'] != null) {
      strengths = (json['strengths'] as List).map((e) => e.toString()).toList();
    } else {
      strengths = [];
    }
    if (json['weaknesses'] != null) {
      weaknesses = (json['weaknesses'] as List).map((e) => e.toString()).toList();
    } else {
      weaknesses = [];
    }
    if (json['suggestions'] != null) {
      suggestions = (json['suggestions'] as List).map((e) => e.toString()).toList();
    } else {
      suggestions = [];
    }
    marks = json['marks'];
    feedback = json['feedback'];
    feedbackStatus = json['feedbackStatus'];
    userFeedback =
        json['userFeedback'] != null
            ? new UserFeedback.fromJson(json['userFeedback'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accuracy'] = this.accuracy;
    data['strengths'] = this.strengths;
    data['weaknesses'] = this.weaknesses;
    data['suggestions'] = this.suggestions;
    data['marks'] = this.marks;
    data['feedback'] = this.feedback;
    data['feedbackStatus'] = this.feedbackStatus;
    if (this.userFeedback != null) {
      data['userFeedback'] = this.userFeedback!.toJson();
    }
    return data;
  }
}

class UserFeedback {
  String? message;
  Null? submittedAt;

  UserFeedback({this.message, this.submittedAt});

  UserFeedback.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    submittedAt = json['submittedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['submittedAt'] = this.submittedAt;
    return data;
  }
}

class AnswerImages {
  String? imageUrl;
  String? cloudinaryPublicId;
  String? originalName;
  String? uploadedAt;
  String? sId;

  AnswerImages({
    this.imageUrl,
    this.cloudinaryPublicId,
    this.originalName,
    this.uploadedAt,
    this.sId,
  });

  AnswerImages.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    cloudinaryPublicId = json['cloudinaryPublicId'];
    originalName = json['originalName'];
    uploadedAt = json['uploadedAt'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageUrl'] = this.imageUrl;
    data['cloudinaryPublicId'] = this.cloudinaryPublicId;
    data['originalName'] = this.originalName;
    data['uploadedAt'] = this.uploadedAt;
    data['_id'] = this.sId;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? totalRequests;
  bool? hasMore;

  Pagination({
    this.currentPage,
    this.totalPages,
    this.totalRequests,
    this.hasMore,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    totalRequests = json['totalRequests'];
    hasMore = json['hasMore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentPage'] = this.currentPage;
    data['totalPages'] = this.totalPages;
    data['totalRequests'] = this.totalRequests;
    data['hasMore'] = this.hasMore;
    return data;
  }
}
