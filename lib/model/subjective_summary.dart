class SummarySubjective {
  bool? success;
  TestStatus? testStatus;
  TestSubmissionSummary? testSubmissionSummary;
  Test? test;

  SummarySubjective({
    this.success,
    this.testStatus,
    this.testSubmissionSummary,
    this.test,
  });

  SummarySubjective.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    testStatus =
        json['TestStatus'] != null
            ? new TestStatus.fromJson(json['TestStatus'])
            : null;
    testSubmissionSummary =
        json['TestSubmissionSummary'] != null
            ? new TestSubmissionSummary.fromJson(json['TestSubmissionSummary'])
            : null;
    test = json['test'] != null ? new Test.fromJson(json['test']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.testStatus != null) {
      data['TestStatus'] = this.testStatus!.toJson();
    }
    if (this.testSubmissionSummary != null) {
      data['TestSubmissionSummary'] = this.testSubmissionSummary!.toJson();
    }
    if (this.test != null) {
      data['test'] = this.test!.toJson();
    }
    return data;
  }
}

class TestStatus {
  String? status;
  bool? attempted;
  int? progress;
  int? totalQuestions;
  int? attemptedQuestions;

  TestStatus({
    this.status,
    this.attempted,
    this.progress,
    this.totalQuestions,
    this.attemptedQuestions,
  });

  TestStatus.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    attempted = json['attempted'];
    progress = json['progress'];
    totalQuestions = json['totalQuestions'];
    attemptedQuestions = json['attemptedQuestions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['attempted'] = this.attempted;
    data['progress'] = this.progress;
    data['totalQuestions'] = this.totalQuestions;
    data['attemptedQuestions'] = this.attemptedQuestions;
    return data;
  }
}

class TestSubmissionSummary {
  int? totalQuestions;
  int? attemptedQuestions;
  int? notAttemptedQuestions;
  int? completionTime;
  List<AttemptedQuestionsDetails>? attemptedQuestionsDetails;
  List<String>? attemptedQuestionIds;
  List<String>? notAttemptedQuestionIds;
  int? averageTimePerQuestion;

  TestSubmissionSummary({
    this.totalQuestions,
    this.attemptedQuestions,
    this.notAttemptedQuestions,
    this.completionTime,
    this.attemptedQuestionsDetails,
    this.attemptedQuestionIds,
    this.notAttemptedQuestionIds,
    this.averageTimePerQuestion,
  });

  TestSubmissionSummary.fromJson(Map<String, dynamic> json) {
    totalQuestions = json['totalQuestions'];
    attemptedQuestions = json['attemptedQuestions'];
    notAttemptedQuestions = json['notAttemptedQuestions'];
    completionTime = json['completionTime'];
    if (json['attemptedQuestionsDetails'] != null) {
      attemptedQuestionsDetails = <AttemptedQuestionsDetails>[];
      json['attemptedQuestionsDetails'].forEach((v) {
        attemptedQuestionsDetails!.add(
          new AttemptedQuestionsDetails.fromJson(v),
        );
      });
    }
    attemptedQuestionIds = json['attemptedQuestionIds'].cast<String>();
    notAttemptedQuestionIds = json['notAttemptedQuestionIds'].cast<String>();
    averageTimePerQuestion = json['averageTimePerQuestion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalQuestions'] = this.totalQuestions;
    data['attemptedQuestions'] = this.attemptedQuestions;
    data['notAttemptedQuestions'] = this.notAttemptedQuestions;
    data['completionTime'] = this.completionTime;
    if (this.attemptedQuestionsDetails != null) {
      data['attemptedQuestionsDetails'] =
          this.attemptedQuestionsDetails!.map((v) => v.toJson()).toList();
    }
    data['attemptedQuestionIds'] = this.attemptedQuestionIds;
    data['notAttemptedQuestionIds'] = this.notAttemptedQuestionIds;
    data['averageTimePerQuestion'] = this.averageTimePerQuestion;
    return data;
  }
}

class AttemptedQuestionsDetails {
  String? questionId;
  int? attemptNumber;
  int? maximumMarks;
  String? submissionStatus;
  String? submittedAt;
  int? timeSpent;
  int? answerImages;
  Evaluation? evaluation;

  AttemptedQuestionsDetails({
    this.questionId,
    this.attemptNumber,
    
    this.maximumMarks,
    this.submissionStatus,
    this.submittedAt,
    this.timeSpent,
    this.answerImages,
    this.evaluation,
  });

  AttemptedQuestionsDetails.fromJson(Map<String, dynamic> json) {
    questionId = json['questionId'];
    attemptNumber = json['attemptNumber'];
    submissionStatus = json['submissionStatus'];
    maximumMarks = json['maximumMarks'];
     submittedAt = json['submittedAt'];
    timeSpent = json['timeSpent'];
    answerImages = json['answerImages'];
    evaluation =
        json['evaluation'] != null
            ? new Evaluation.fromJson(json['evaluation'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['questionId'] = this.questionId;
     data['maximumMarks'] = this.maximumMarks;
    data['attemptNumber'] = this.attemptNumber;
    data['submissionStatus'] = this.submissionStatus;
    data['submittedAt'] = this.submittedAt;
    data['timeSpent'] = this.timeSpent;
    data['answerImages'] = this.answerImages;
    if (this.evaluation != null) {
      data['evaluation'] = this.evaluation!.toJson();
    }
    return data;
  }
}

class Evaluation {
  int? relevancy;
  int? score;
  String? remark;
  List<String>? comments;
  Analysis? analysis;

  Evaluation({
    this.relevancy,
    this.score,
    this.remark,
    this.comments,
    this.analysis,
  });

  Evaluation.fromJson(Map<String, dynamic> json) {
    relevancy = json['relevancy'];
    score = json['score'];
    remark = json['remark'];
    comments = json['comments'].cast<String>();
    analysis =
        json['analysis'] != null
            ? new Analysis.fromJson(json['analysis'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['relevancy'] = this.relevancy;
    data['score'] = this.score;
    data['remark'] = this.remark;
    data['comments'] = this.comments;
    if (this.analysis != null) {
      data['analysis'] = this.analysis!.toJson();
    }
    return data;
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
    this.introduction,
    this.body,
    this.conclusion,
    this.strengths,
    this.weaknesses,
    this.suggestions,
    this.feedback,
  });

  Analysis.fromJson(Map<String, dynamic> json) {
    introduction = json['introduction'].cast<String>();
    body = json['body'].cast<String>();
    conclusion = json['conclusion'].cast<String>();
    strengths = json['strengths'].cast<String>();
    weaknesses = json['weaknesses'].cast<String>();
    suggestions = json['suggestions'].cast<String>();
    feedback = json['feedback'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['introduction'] = this.introduction;
    data['body'] = this.body;
    data['conclusion'] = this.conclusion;
    data['strengths'] = this.strengths;
    data['weaknesses'] = this.weaknesses;
    data['suggestions'] = this.suggestions;
    data['feedback'] = this.feedback;
    return data;
  }
}

class Test {
  String? sId;
  String? name;
  String? clientId;
  String? description;
  String? estimatedTime;
  String? imageKey;
  String? imageUrl;
  bool? isTrending;
  bool? isHighlighted;
  bool? isActive;
  String? instructions;
  List<String>? questions;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? category;
  String? subcategory;

  Test({
    this.sId,
    this.name,
    this.clientId,
    this.description,
    this.estimatedTime,
    this.imageKey,
    this.imageUrl,
    this.isTrending,
    this.isHighlighted,
    this.isActive,
    this.instructions,
    this.questions,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.category,
    this.subcategory,
  });

  Test.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    clientId = json['clientId'];
    description = json['description'];
    estimatedTime = json['Estimated_time'];
    imageKey = json['imageKey'];
    imageUrl = json['imageUrl'];
    isTrending = json['isTrending'];
    isHighlighted = json['isHighlighted'];
    isActive = json['isActive'];
    instructions = json['instructions'];
    questions = json['questions'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    category = json['category'];
    subcategory = json['subcategory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['clientId'] = this.clientId;
    data['description'] = this.description;
    data['Estimated_time'] = this.estimatedTime;
    data['imageKey'] = this.imageKey;
    data['imageUrl'] = this.imageUrl;
    data['isTrending'] = this.isTrending;
    data['isHighlighted'] = this.isHighlighted;
    data['isActive'] = this.isActive;
    data['instructions'] = this.instructions;
    data['questions'] = this.questions;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['category'] = this.category;
    data['subcategory'] = this.subcategory;
    return data;
  }
}
