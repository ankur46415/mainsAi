class GetAnswerAnlaysis {
  bool? success;
  String? message;
  Data? data;

  GetAnswerAnlaysis({this.success, this.message, this.data});

  GetAnswerAnlaysis.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Answer? answer;

  Data({this.answer});

  Data.fromJson(Map<String, dynamic> json) {
    answer =
        json['answer'] != null ? new Answer.fromJson(json['answer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.answer != null) {
      data['answer'] = this.answer!.toJson();
    }
    return data;
  }
}

class Answer {
  String? sId;
  HindiEvaluation? hindiEvaluation;
  String? questionId;
  int? attemptNumber;
  String? submissionStatus;
  String? reviewStatus;
  String? publishStatus;
  String? popularityStatus;
  String? submittedAt;
  String? evaluatedAt;
  bool? analysisAvailable;
  Question? question;
  Submission? submission;
  Evaluation? evaluation;
  Feedback? feedback;
  dynamic reviewedBy;
  List<AnalysedAnnotations>? annotatedImages;

  Answer({
    this.sId,
    this.questionId,
    this.attemptNumber,
    this.submissionStatus,
    this.reviewStatus,
    this.publishStatus,
    this.popularityStatus,
    this.submittedAt,
    this.evaluatedAt,
    this.analysisAvailable,
    this.question,
    this.submission,
    this.evaluation,
    this.feedback,
    this.reviewedBy,
    this.annotatedImages,
    this.hindiEvaluation,
  });

  Answer.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    questionId = json['questionId'];
    attemptNumber = json['attemptNumber'];
    submissionStatus = json['submissionStatus'];
    reviewStatus = json['reviewStatus'];
    publishStatus = json['publishStatus'];
    popularityStatus = json['popularityStatus'];
    submittedAt = json['submittedAt'];
    evaluatedAt = json['evaluatedAt'];
    analysisAvailable = json['analysisAvailable'];
    question =
        json['question'] != null ? Question.fromJson(json['question']) : null;
    submission =
        json['submission'] != null
            ? Submission.fromJson(json['submission'])
            : null;
    evaluation =
        json['evaluation'] != null
            ? Evaluation.fromJson(json['evaluation'])
            : null;
    hindiEvaluation =
        json['hindiEvaluation'] != null
            ? HindiEvaluation.fromJson(json['hindiEvaluation'])
            : null;
    feedback =
        json['feedback'] != null ? Feedback.fromJson(json['feedback']) : null;
    reviewedBy = json['reviewedBy'];
    annotatedImages =
        json['annotations'] != null
            ? List<AnalysedAnnotations>.from(
              json['annotations'].map((x) => AnalysedAnnotations.fromJson(x)),
            )
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['questionId'] = questionId;
    data['attemptNumber'] = attemptNumber;
    data['submissionStatus'] = submissionStatus;
    data['reviewStatus'] = reviewStatus;
    data['publishStatus'] = publishStatus;
    data['popularityStatus'] = popularityStatus;
    data['submittedAt'] = submittedAt;
    data['evaluatedAt'] = evaluatedAt;
    data['analysisAvailable'] = analysisAvailable;
    if (question != null) data['question'] = question!.toJson();
    if (submission != null) data['submission'] = submission!.toJson();
    if (evaluation != null) data['evaluation'] = evaluation!.toJson();
    if (feedback != null) data['feedback'] = feedback!.toJson();
    if (hindiEvaluation != null)
      data['hindiEvaluation'] = hindiEvaluation!.toJson();
    data['reviewedBy'] = reviewedBy;
    if (annotatedImages != null) {
      data['annotations'] = annotatedImages!.map((x) => x.toJson()).toList();
    }
    return data;
  }
}

class Question {
  String? id;
  String? text;
  String? detailedAnswer;
  String? modalAnswer;
  List<ModalAnswerPdf>? modalAnswerPdf;
  List<dynamic>? answerVideoUrls;
  Metadata? metadata;
  String? languageMode;
  String? evaluationMode;

  Question({
    this.id,
    this.text,
    this.detailedAnswer,
    this.modalAnswer,
    this.modalAnswerPdf,
    this.answerVideoUrls,
    this.metadata,
    this.languageMode,
    this.evaluationMode,
  });

  Question.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString();
    text = json['text'];
    detailedAnswer = json['detailedAnswer'];
    modalAnswer = json['modalAnswer'];
    if (json['modalAnswerPdf'] != null) {
      modalAnswerPdf =
          (json['modalAnswerPdf'] as List)
              .map((e) => ModalAnswerPdf.fromJson(e))
              .toList();
    }
    if (json['answerVideoUrls'] != null) {
      answerVideoUrls = json['answerVideoUrls'].cast<dynamic>();
    }
    metadata =
        json['metadata'] != null
            ? new Metadata.fromJson(json['metadata'])
            : null;
    languageMode = json['languageMode'];
    evaluationMode = json['evaluationMode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['text'] = this.text;
    data['detailedAnswer'] = this.detailedAnswer;
    data['modalAnswer'] = this.modalAnswer;
    if (this.modalAnswerPdf != null) {
      data['modalAnswerPdf'] =
          this.modalAnswerPdf!.map((e) => e.toJson()).toList();
    }
    data['answerVideoUrls'] = this.answerVideoUrls;
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    data['languageMode'] = this.languageMode;
    data['evaluationMode'] = this.evaluationMode;
    return data;
  }
}

class ModalAnswerPdf {
  String? key;
  String? url;

  ModalAnswerPdf({this.key, this.url});

  factory ModalAnswerPdf.fromJson(Map<String, dynamic> json) {
    return ModalAnswerPdf(key: json['key'], url: json['url']);
  }

  Map<String, dynamic> toJson() {
    return {'key': key, 'url': url};
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
  List<dynamic>? customParams;

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
    if (json['customParams'] != null) {
      customParams = json['customParams'].cast<dynamic>();
    }
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

class Submission {
  List<AnswerImages>? answerImages;
  String? textAnswer;
  List<String>? extractedTexts;
  int? timeSpent;
  String? sourceType;

  Submission({
    this.answerImages,
    this.textAnswer,
    this.extractedTexts,
    this.timeSpent,
    this.sourceType,
  });

  Submission.fromJson(Map<String, dynamic> json) {
    if (json['answerImages'] != null) {
      answerImages = <AnswerImages>[];
      json['answerImages'].forEach((v) {
        answerImages!.add(new AnswerImages.fromJson(v));
      });
    }
    textAnswer = json['textAnswer'];
    extractedTexts = json['extractedTexts'].cast<String>();
    timeSpent = json['timeSpent'];
    sourceType = json['sourceType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.answerImages != null) {
      data['answerImages'] = this.answerImages!.map((v) => v.toJson()).toList();
    }
    data['textAnswer'] = this.textAnswer;
    data['extractedTexts'] = this.extractedTexts;
    data['timeSpent'] = this.timeSpent;
    data['sourceType'] = this.sourceType;
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

class AnalysedAnnotations {
  String? s3Key;
  String? downloadUrl;
  String? uploadedAt;
  String? id;

  AnalysedAnnotations({this.s3Key, this.downloadUrl, this.uploadedAt, this.id});

  AnalysedAnnotations.fromJson(Map<String, dynamic> json) {
    s3Key = json['s3Key'];
    downloadUrl = json['downloadUrl'];
    uploadedAt = json['uploadedAt'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['s3Key'] = s3Key;
    data['downloadUrl'] = downloadUrl;
    data['uploadedAt'] = uploadedAt;
    data['_id'] = id;
    return data;
  }
}

class Evaluation {
  int? relevancy;
  String? score;
  String? remark;
  int? accuracy;
  int? marks;
  List<String>? strengths;
  List<String>? weaknesses;
  List<String>? suggestions;
  List<String>? comments;
  Analysis? analysis;
  String? feedback;

  Evaluation({
    this.relevancy,
    this.score,
    this.remark,
    this.accuracy,
    this.marks,
    this.strengths,
    this.weaknesses,
    this.suggestions,
    this.comments,
    this.analysis,
    this.feedback,
  });

  Evaluation.fromJson(Map<String, dynamic> json) {
    relevancy = json['relevancy'];
    score = json['score'];
    remark = json['remark'];
    accuracy = json['accuracy'];
    marks = json['marks'];
    strengths = (json['strengths'] as List?)?.cast<String>();
    weaknesses = (json['weaknesses'] as List?)?.cast<String>();
    suggestions = (json['suggestions'] as List?)?.cast<String>();
    comments = (json['comments'] as List?)?.cast<String>();
    feedback = json['feedback'];
    analysis =
        json['analysis'] != null ? Analysis.fromJson(json['analysis']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'relevancy': relevancy,
      'score': score,
      'remark': remark,
      'accuracy': accuracy,
      'marks': marks,
      'strengths': strengths,
      'weaknesses': weaknesses,
      'suggestions': suggestions,
      'comments': comments,
      'feedback': feedback,
      'analysis': analysis?.toJson(),
    };
  }
}

class Analysis {
  List<String>? introduction;
  List<String>? body;
  List<String>? conclusion;
  List<String>? strengths;
  List<String>? weaknesses;
  List<String>? suggestions;
  List<String>? feedback;

  Analysis({
    this.strengths,
    this.weaknesses,
    this.suggestions,
    this.feedback,
    this.introduction,
    this.body,
    this.conclusion,
  });

  factory Analysis.fromJson(Map<String, dynamic> json) {
    return Analysis(
      introduction: (json['introduction'] as List?)?.cast<String>() ?? [],
      body: (json['body'] as List?)?.cast<String>() ?? [],
      conclusion: (json['conclusion'] as List?)?.cast<String>() ?? [],
      strengths: (json['strengths'] as List?)?.cast<String>() ?? [],
      weaknesses: (json['weaknesses'] as List?)?.cast<String>() ?? [],
      suggestions: (json['suggestions'] as List?)?.cast<String>() ?? [],
      feedback: (json['feedback'] as List?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'introduction': introduction,
      'body': body,
      'conclusion': conclusion,
      'strengths': strengths,
      'weaknesses': weaknesses,
      'suggestions': suggestions,
      'feedback': feedback,
    };
  }
}

class Feedback {
  List<dynamic>? suggestions;
  ExpertReview? expertReview;

  Feedback({this.suggestions, this.expertReview});

  Feedback.fromJson(Map<String, dynamic> json) {
    suggestions = json['suggestions'] ?? [];
    expertReview =
        json['expertReview'] != null
            ? ExpertReview.fromJson(json['expertReview'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['suggestions'] = suggestions;
    if (expertReview != null) {
      data['expertReview'] = expertReview!.toJson();
    }
    return data;
  }
}

class ExpertReview {
  String? result;
  int? score;
  String? remarks;
  List<AnnotatedImage>? annotatedImages;
  String? reviewedAt;

  ExpertReview({
    this.result,
    this.score,
    this.remarks,
    this.annotatedImages,
    this.reviewedAt,
  });

  ExpertReview.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    score = json['score'];
    remarks = json['remarks'];
    reviewedAt = json['reviewedAt'];
    if (json['annotatedImages'] != null) {
      annotatedImages =
          (json['annotatedImages'] as List)
              .map((e) => AnnotatedImage.fromJson(e))
              .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['result'] = result;
    data['score'] = score;
    data['remarks'] = remarks;
    data['reviewedAt'] = reviewedAt;
    if (annotatedImages != null) {
      data['annotatedImages'] =
          annotatedImages!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class AnnotatedImage {
  String? s3Key; //experreviews
  String? downloadUrl;
  String? uploadedAt;
  String? id;

  AnnotatedImage({this.s3Key, this.downloadUrl, this.uploadedAt, this.id});

  AnnotatedImage.fromJson(Map<String, dynamic> json) {
    s3Key = json['s3Key'];
    downloadUrl = json['downloadUrl'];
    uploadedAt = json['uploadedAt'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['s3Key'] = s3Key;
    data['downloadUrl'] = downloadUrl;
    data['uploadedAt'] = uploadedAt;
    data['_id'] = id;
    return data;
  }
}

class HindiEvaluation {
  int? relevancy;
  int? score;
  String? remark;
  List<String>? comments;
  HindiAnalysis? analysis;

  HindiEvaluation({
    this.relevancy,
    this.score,
    this.remark,
    this.comments,
    this.analysis,
  });

  HindiEvaluation.fromJson(Map<String, dynamic> json) {
    relevancy = json['relevancy'];
    score = json['score'];
    remark = json['remark'];
    comments =
        json['comments'] != null ? List<String>.from(json['comments']) : null;
    analysis =
        json['analysis'] != null
            ? HindiAnalysis.fromJson(json['analysis'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['relevancy'] = relevancy;
    data['score'] = score;
    data['remark'] = remark;
    if (comments != null) data['comments'] = comments;
    if (analysis != null) data['analysis'] = analysis!.toJson();
    return data;
  }
}

class HindiAnalysis {
  List<String>? introduction;
  List<String>? body;
  List<String>? conclusion;
  List<String>? strengths;
  List<String>? weaknesses;
  List<String>? suggestions;
  List<String>? feedback;

  HindiAnalysis({
    this.introduction,
    this.body,
    this.conclusion,
    this.strengths,
    this.weaknesses,
    this.suggestions,
    this.feedback,
  });

  HindiAnalysis.fromJson(Map<String, dynamic> json) {
    introduction =
        json['introduction'] != null
            ? List<String>.from(json['introduction'])
            : null;
    body = json['body'] != null ? List<String>.from(json['body']) : null;
    conclusion =
        json['conclusion'] != null
            ? List<String>.from(json['conclusion'])
            : null;
    strengths =
        json['strengths'] != null ? List<String>.from(json['strengths']) : null;
    weaknesses =
        json['weaknesses'] != null
            ? List<String>.from(json['weaknesses'])
            : null;
    suggestions =
        json['suggestions'] != null
            ? List<String>.from(json['suggestions'])
            : null;
    feedback =
        json['feedback'] != null ? List<String>.from(json['feedback']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (introduction != null) data['introduction'] = introduction;
    if (body != null) data['body'] = body;
    if (conclusion != null) data['conclusion'] = conclusion;
    if (strengths != null) data['strengths'] = strengths;
    if (weaknesses != null) data['weaknesses'] = weaknesses;
    if (suggestions != null) data['suggestions'] = suggestions;
    if (feedback != null) data['feedback'] = feedback;
    return data;
  }
}
