class GetAllAnswers {
  bool? success;
  String? message;
  Data? data;

  GetAllAnswers({this.success, this.message, this.data});

  GetAllAnswers.fromJson(Map<String, dynamic> json) {
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
  List<Answers>? answers;
  Pagination? pagination;
  Summary? summary;

  Data({this.answers, this.pagination, this.summary});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['answers'] != null) {
      answers = <Answers>[];
      json['answers'].forEach((v) {
        answers!.add(new Answers.fromJson(v));
      });
    }
    pagination =
        json['pagination'] != null
            ? new Pagination.fromJson(json['pagination'])
            : null;
    summary =
        json['summary'] != null ? new Summary.fromJson(json['summary']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.answers != null) {
      data['answers'] = this.answers!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.summary != null) {
      data['summary'] = this.summary!.toJson();
    }
    return data;
  }
}

class Answers {
  String? sId;
  String? questionId;
  Question? question;
  int? attemptNumber;
  BookWorkbookInfo? bookWorkbookInfo;
  String? submissionStatus;
  TestInfo? testInfo;
  String? submissionType;
  String? reviewStatus;
  String? requestID;
  String? publishStatus;
  String? popularityStatus;
  String? submittedAt;
  String? reviewRequested;
  String? reviewCompleted;
  String? reviewedAt;
  String? evaluatedAt;
  bool? hasImages;
  bool? hasTextAnswer;
  List<TestAnswerImages>? answerImages;
  List<TestAnswerImages>? images;
  List<Annotation>? annotations;
  int? timeSpent;
  String? sourceType;
  bool? isEvaluated;
  bool? hasEvaluation;
  bool? hasFeedback;
  EvaluationSummary? evaluationSummary;
  FeedbackSummary? feedbackSummary;
  Feedback? feedback;

  Answers({
    this.sId,
    this.questionId,
    this.question,
    this.attemptNumber,
    this.bookWorkbookInfo,
    this.submissionStatus,
    this.testInfo, // Add this
    this.submissionType,
    this.reviewStatus,
    this.requestID,
    this.publishStatus,
    this.popularityStatus,
    this.submittedAt,
    this.reviewRequested,
    this.reviewCompleted,
    this.reviewedAt,
    this.evaluatedAt,
    this.hasImages,
    this.annotations,
    this.hasTextAnswer,
    this.answerImages,
    this.images,
    this.timeSpent,
    this.sourceType,
    this.isEvaluated,
    this.hasEvaluation,
    this.hasFeedback,
    this.evaluationSummary,
    this.feedbackSummary,
    this.feedback,
  });

  Answers.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    questionId = json['questionId'];
    question =
        json['question'] != null
            ? new Question.fromJson(json['question'])
            : null;
    bookWorkbookInfo =
        json['bookWorkbookInfo'] != null
            ? new BookWorkbookInfo.fromJson(json['bookWorkbookInfo'])
            : null;
    attemptNumber = json['attemptNumber'];
    submissionStatus = json['submissionStatus'];
    testInfo =
        json['testInfo'] != null ? TestInfo.fromJson(json['testInfo']) : null;
    submissionType = json['submissionType'];
    reviewStatus = json['reviewStatus'];
    requestID = json['requestID'];
    publishStatus = json['publishStatus'];
    popularityStatus = json['popularityStatus'];
    submittedAt = json['submittedAt'];
    reviewRequested = json['reviewRequestedAt'];
    reviewCompleted = json['reviewCompletedAt'];
    reviewedAt = json['reviewedAt'];
    evaluatedAt = json['evaluatedAt'];
    hasImages = json['hasImages'];
    hasTextAnswer = json['hasTextAnswer'];
    if (json['answerImages'] != null) {
      answerImages = <TestAnswerImages>[];
      json['answerImages'].forEach((v) {
        answerImages!.add(new TestAnswerImages.fromJson(v));
      });
      images = answerImages;
    }
    if (json['annotations'] != null) {
      annotations =
          (json['annotations'] as List)
              .map((v) => Annotation.fromJson(v))
              .toList();
    }
    timeSpent = json['timeSpent'];
    sourceType = json['sourceType'];
    isEvaluated = json['isEvaluated'];
    hasEvaluation = json['hasEvaluation'];
    hasFeedback = json['hasFeedback'];
    evaluationSummary =
        json['evaluationSummary'] != null
            ? new EvaluationSummary.fromJson(json['evaluationSummary'])
            : null;
    feedbackSummary =
        json['feedbackSummary'] != null
            ? new FeedbackSummary.fromJson(json['feedbackSummary'])
            : null;
    feedback =
        json['feedback'] != null ? Feedback.fromJson(json['feedback']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['questionId'] = this.questionId;
    if (this.question != null) {
      data['question'] = this.question!.toJson();
    }
    if (this.bookWorkbookInfo != null) {
      data['bookWorkbookInfo'] = this.bookWorkbookInfo!.toJson();
    }
    if (this.testInfo != null) {
      data['testInfo'] = this.testInfo!.toJson(); // Add this
    }
    data['attemptNumber'] = this.attemptNumber;
    data['submissionStatus'] = this.submissionStatus;
    data['submissionType'] = this.submissionType;
    data['reviewStatus'] = this.reviewStatus;
    data['requestID'] = this.requestID;
    data['publishStatus'] = this.publishStatus;
    data['popularityStatus'] = this.popularityStatus;
    data['submittedAt'] = this.submittedAt;
    data['reviewRequestedAt'] = this.reviewRequested;
    data['reviewCompletedAt'] = this.reviewCompleted;
    data['reviewedAt'] = this.reviewedAt;
    data['evaluatedAt'] = this.evaluatedAt;
    data['hasImages'] = this.hasImages;
    data['hasTextAnswer'] = this.hasTextAnswer;
    if (this.answerImages != null) {
      data['answerImages'] = this.answerImages!.map((v) => v.toJson()).toList();
    }
    data['timeSpent'] = this.timeSpent;
    data['sourceType'] = this.sourceType;
    data['isEvaluated'] = this.isEvaluated;
    data['hasEvaluation'] = this.hasEvaluation;
    data['hasFeedback'] = this.hasFeedback;
    if (this.evaluationSummary != null) {
      data['evaluationSummary'] = this.evaluationSummary!.toJson();
    }
    if (this.feedbackSummary != null) {
      data['feedbackSummary'] = this.feedbackSummary!.toJson();
    }
    if (this.feedback != null) {
      data['feedback'] = this.feedback!.toJson();
    }
    if (annotations != null) {
      data['annotations'] = annotations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TestInfo {
  String? id;
  String? name;
  String? description;
  String? category;
  String? subcategory;
  String? estimatedTime;
  String? imageUrl;
  String? instructions;

  TestInfo({
    this.id,
    this.name,
    this.description,
    this.category,
    this.subcategory,
    this.estimatedTime,
    this.imageUrl,
    this.instructions,
  });

  TestInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    category = json['category'];
    subcategory = json['subcategory'];
    estimatedTime = json['estimatedTime'];
    imageUrl = json['imageUrl'];
    instructions = json['instructions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['category'] = this.category;
    data['subcategory'] = this.subcategory;
    data['estimatedTime'] = this.estimatedTime;
    data['imageUrl'] = this.imageUrl;
    data['instructions'] = this.instructions;
    return data;
  }
}

class BookWorkbookInfo {
  Null? book;
  Workbook? workbook;
  String? questionType;

  BookWorkbookInfo({this.book, this.workbook, this.questionType});

  BookWorkbookInfo.fromJson(Map<String, dynamic> json) {
    book = json['book'];
    workbook =
        json['workbook'] != null
            ? new Workbook.fromJson(json['workbook'])
            : null;
    questionType = json['questionType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['book'] = this.book;
    if (this.workbook != null) {
      data['workbook'] = this.workbook!.toJson();
    }
    data['questionType'] = this.questionType;
    return data;
  }
}

class Workbook {
  String? sId;
  String? title;
  String? description;
  String? createdAt;
  String? updatedAt;
  String? author;
  String? coverImageUrl;
  String? mainCategory;
  String? publisher;
  num? rating;
  String? subCategory;
  String? effectiveSubCategory;
  String? fullCategory;
  String? fullClassification;
  bool? isCurrentlyTrending;
  String? id;

  Workbook({
    this.sId,
    this.title,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.author,
    this.coverImageUrl,
    this.mainCategory,
    this.publisher,
    this.rating,
    this.subCategory,
    this.effectiveSubCategory,
    this.fullCategory,
    this.fullClassification,
    this.isCurrentlyTrending,
    this.id,
  });

  Workbook.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    author = json['author'];
    coverImageUrl = json['coverImageUrl'];
    mainCategory = json['mainCategory'];
    publisher = json['publisher'];
    rating = json['rating'];
    subCategory = json['subCategory'];
    effectiveSubCategory = json['effectiveSubCategory'];
    fullCategory = json['fullCategory'];
    fullClassification = json['fullClassification'];
    isCurrentlyTrending = json['isCurrentlyTrending'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['author'] = this.author;
    data['coverImageUrl'] = this.coverImageUrl;
    data['mainCategory'] = this.mainCategory;
    data['publisher'] = this.publisher;
    data['rating'] = this.rating;
    data['subCategory'] = this.subCategory;
    data['effectiveSubCategory'] = this.effectiveSubCategory;
    data['fullCategory'] = this.fullCategory;
    data['fullClassification'] = this.fullClassification;
    data['isCurrentlyTrending'] = this.isCurrentlyTrending;
    data['id'] = this.id;
    return data;
  }
}

class Annotation {
  String? s3Key;
  String? downloadUrl;
  String? uploadedAt;
  String? id;

  Annotation({this.s3Key, this.downloadUrl, this.uploadedAt, this.id});

  Annotation.fromJson(Map<String, dynamic> json) {
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

class Question {
  String? id;
  String? text;
  String? question;
  String? difficultyLevel;
  int? maximumMarks;
  int? wordLimit;
  int? estimatedTime;
  String? languageMode;
  String? evaluationMode;

  Question({
    this.id,
    this.text,
    this.question,
    this.difficultyLevel,
    this.maximumMarks,
    this.wordLimit,
    this.estimatedTime,
    this.languageMode,
    this.evaluationMode,
  });

  Question.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString();
    text = json['text']?.toString();
    question = json['question']?.toString();
    difficultyLevel = json['difficultyLevel']?.toString();
    maximumMarks = json['maximumMarks'];
    wordLimit = json['wordLimit'];
    estimatedTime = json['estimatedTime'];
    languageMode = json['languageMode']?.toString();
    evaluationMode = json['evaluationMode']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['text'] = this.text;
    data['question'] = this.question;
    data['difficultyLevel'] = this.difficultyLevel;
    data['maximumMarks'] = this.maximumMarks;
    data['wordLimit'] = this.wordLimit;
    data['estimatedTime'] = this.estimatedTime;
    data['languageMode'] = this.languageMode;
    data['evaluationMode'] = this.evaluationMode;
    return data;
  }
}

class TestAnswerImages {
  String? imageUrl;
  String? cloudinaryPublicId;
  String? originalName;
  String? uploadedAt;
  String? id;
  String? downloadUrl;

  TestAnswerImages({
    this.imageUrl,
    this.cloudinaryPublicId,
    this.originalName,
    this.uploadedAt,
    this.id,
    this.downloadUrl,
  });

  TestAnswerImages.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    cloudinaryPublicId = json['cloudinaryPublicId'];
    originalName = json['originalName'];
    uploadedAt = json['uploadedAt'];
    id = json['_id'];
    downloadUrl =
        json['downloadUrl'] ?? json['imageUrl']; // Use imageUrl as fallback
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageUrl'] = this.imageUrl;
    data['cloudinaryPublicId'] = this.cloudinaryPublicId;
    data['originalName'] = this.originalName;
    data['uploadedAt'] = this.uploadedAt;
    data['_id'] = this.id;
    data['downloadUrl'] = this.downloadUrl;
    return data;
  }
}

class EvaluationSummary {
  int? accuracy;
  int? marks;
  bool? hasStrengths;
  bool? hasWeaknesses;
  bool? hasSuggestions;

  EvaluationSummary({
    this.accuracy,
    this.marks,
    this.hasStrengths,
    this.hasWeaknesses,
    this.hasSuggestions,
  });

  EvaluationSummary.fromJson(Map<String, dynamic> json) {
    accuracy = json['accuracy'];
    marks = json['marks'];
    hasStrengths = json['hasStrengths'];
    hasWeaknesses = json['hasWeaknesses'];
    hasSuggestions = json['hasSuggestions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accuracy'] = this.accuracy;
    data['marks'] = this.marks;
    data['hasStrengths'] = this.hasStrengths;
    data['hasWeaknesses'] = this.hasWeaknesses;
    data['hasSuggestions'] = this.hasSuggestions;
    return data;
  }
}

class FeedbackSummary {
  bool? hasComments;
  bool? hasSuggestions;

  FeedbackSummary({this.hasComments, this.hasSuggestions});

  FeedbackSummary.fromJson(Map<String, dynamic> json) {
    hasComments = json['hasComments'];
    hasSuggestions = json['hasSuggestions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hasComments'] = this.hasComments;
    data['hasSuggestions'] = this.hasSuggestions;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? totalAnswers;
  bool? hasNextPage;
  bool? hasPreviousPage;
  int? limit;

  Pagination({
    this.currentPage,
    this.totalPages,
    this.totalAnswers,
    this.hasNextPage,
    this.hasPreviousPage,
    this.limit,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    totalAnswers = json['totalAnswers'];
    hasNextPage = json['hasNextPage'];
    hasPreviousPage = json['hasPreviousPage'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentPage'] = this.currentPage;
    data['totalPages'] = this.totalPages;
    data['totalAnswers'] = this.totalAnswers;
    data['hasNextPage'] = this.hasNextPage;
    data['hasPreviousPage'] = this.hasPreviousPage;
    data['limit'] = this.limit;
    return data;
  }
}

class Feedback {
  bool? feedbackStatus;
  UserFeedbackReview? userFeedbackReview;
  ExpertReview? expertReview;

  Feedback({this.feedbackStatus, this.userFeedbackReview, this.expertReview});

  Feedback.fromJson(Map<String, dynamic> json) {
    feedbackStatus = json['feedbackStatus'];
    userFeedbackReview =
        json['userFeedbackReview'] != null
            ? new UserFeedbackReview.fromJson(json['userFeedbackReview'])
            : null;
    expertReview =
        json['expertReview'] != null
            ? new ExpertReview.fromJson(json['expertReview'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['feedbackStatus'] = this.feedbackStatus;
    if (this.userFeedbackReview != null) {
      data['userFeedbackReview'] = this.userFeedbackReview!.toJson();
    }
    if (this.expertReview != null) {
      data['expertReview'] = this.expertReview!.toJson();
    }
    return data;
  }
}

class UserFeedbackReview {
  String? message;
  Null? submittedAt;

  UserFeedbackReview({this.message, this.submittedAt});

  UserFeedbackReview.fromJson(Map<String, dynamic> json) {
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

class ExpertReview {
  String? result;
  int? score;
  String? remarks;
  List<CompletedAnnotatedImages>? annotatedImages;
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
    if (json['annotatedImages'] != null) {
      annotatedImages = <CompletedAnnotatedImages>[];
      json['annotatedImages'].forEach((v) {
        annotatedImages!.add(new CompletedAnnotatedImages.fromJson(v));
      });
    }
    reviewedAt = json['reviewedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['score'] = this.score;
    data['remarks'] = this.remarks;
    if (this.annotatedImages != null) {
      data['annotatedImages'] =
          this.annotatedImages!.map((v) => v.toJson()).toList();
    }
    data['reviewedAt'] = this.reviewedAt;
    return data;
  }
}

class CompletedAnnotatedImages {
  String? downloadUrl;
  String? s3Key;
  String? uploadedAt;
  String? sId;

  CompletedAnnotatedImages({
    this.downloadUrl,
    this.s3Key,
    this.uploadedAt,
    this.sId,
  });

  CompletedAnnotatedImages.fromJson(Map<String, dynamic> json) {
    downloadUrl = json['downloadUrl'];
    s3Key = json['s3Key'];
    uploadedAt = json['uploadedAt'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['downloadUrl'] = this.downloadUrl;
    data['s3Key'] = this.s3Key;
    data['uploadedAt'] = this.uploadedAt;
    data['_id'] = this.sId;
    return data;
  }
}

class Summary {
  int? totalSubmitted;
  int? evaluatedCount;
  int? publishedCount;
  int? popularCount;

  Summary({
    this.totalSubmitted,
    this.evaluatedCount,
    this.publishedCount,
    this.popularCount,
  });

  Summary.fromJson(Map<String, dynamic> json) {
    totalSubmitted = json['totalSubmitted'];
    evaluatedCount = json['evaluatedCount'];
    publishedCount = json['publishedCount'];
    popularCount = json['popularCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalSubmitted'] = this.totalSubmitted;
    data['evaluatedCount'] = this.evaluatedCount;
    data['publishedCount'] = this.publishedCount;
    data['popularCount'] = this.popularCount;
    return data;
  }
}
