class EvaluationResponse {
  final bool success;
  final Data? data;

  EvaluationResponse({required this.success, this.data});

  factory EvaluationResponse.fromJson(Map<String, dynamic> json) {
    return EvaluationResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }
}

class Data {
  final String evaluationId;
  final String submissionId;
  final String questionId;
  final String userId;
  final int attemptNumber;
  final List<String> extractedTexts;
  final GeminiAnalysis geminiAnalysis;
  final String status;
  final DateTime evaluatedAt;
  final Question question;
  final Metadata metadata;
  final Submission submission;
  final User user;
  final AttemptInfo attemptInfo;

  Data({
    required this.evaluationId,
    required this.submissionId,
    required this.questionId,
    required this.userId,
    required this.attemptNumber,
    required this.extractedTexts,
    required this.geminiAnalysis,
    required this.status,
    required this.evaluatedAt,
    required this.question,
    required this.metadata,
    required this.submission,
    required this.user,
    required this.attemptInfo,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      evaluationId: json['evaluationId'] ?? '',
      submissionId: json['submissionId'] ?? '',
      questionId: json['questionId'] ?? '',
      userId: json['userId'] ?? '',
      attemptNumber: json['attemptNumber'] ?? 0,
      extractedTexts: List<String>.from(json['extractedTexts'] ?? []),
      geminiAnalysis: GeminiAnalysis.fromJson(json['geminiAnalysis'] ?? {}),
      status: json['status'] ?? '',
      evaluatedAt: DateTime.parse(json['evaluatedAt']),
      question: Question.fromJson(json['question'] ?? {}),
      metadata: Metadata.fromJson(json['metadata'] ?? {}),
      submission: Submission.fromJson(json['submission'] ?? {}),
      user: User.fromJson(json['user'] ?? {}),
      attemptInfo: AttemptInfo.fromJson(json['attemptInfo'] ?? {}),
    );
  }
}

class GeminiAnalysis {
  final int accuracy;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> suggestions;

  GeminiAnalysis({
    required this.accuracy,
    required this.strengths,
    required this.weaknesses,
    required this.suggestions,
  });

  factory GeminiAnalysis.fromJson(Map<String, dynamic> json) {
    return GeminiAnalysis(
      accuracy: json['accuracy'] ?? 0,
      strengths: List<String>.from(json['strengths'] ?? []),
      weaknesses: List<String>.from(json['weaknesses'] ?? []),
      suggestions: List<String>.from(json['suggestions'] ?? []),
    );
  }
}

class Question {
  final String title;
  final String description;
  final Metadata metadata;

  Question({
    required this.title,
    required this.description,
    required this.metadata,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      metadata: Metadata.fromJson(json['metadata'] ?? {}),
    );
  }
}

class Metadata {
  final QualityParameters qualityParameters;
  final List<String> keywords;
  final String difficultyLevel;
  final int wordLimit;
  final int estimatedTime;
  final int maximumMarks;

  Metadata({
    required this.qualityParameters,
    required this.keywords,
    required this.difficultyLevel,
    required this.wordLimit,
    required this.estimatedTime,
    required this.maximumMarks,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      qualityParameters: QualityParameters.fromJson(json['qualityParameters'] ?? {}),
      keywords: List<String>.from(json['keywords'] ?? []),
      difficultyLevel: json['difficultyLevel'] ?? '',
      wordLimit: json['wordLimit'] ?? 0,
      estimatedTime: json['estimatedTime'] ?? 0,
      maximumMarks: json['maximumMarks'] ?? 0,
    );
  }
}

class QualityParameters {
  final Body body;
  final bool intro;
  final bool conclusion;
  final List<dynamic> customParams;

  QualityParameters({
    required this.body,
    required this.intro,
    required this.conclusion,
    required this.customParams,
  });

  factory QualityParameters.fromJson(Map<String, dynamic> json) {
    return QualityParameters(
      body: Body.fromJson(json['body'] ?? {}),
      intro: json['intro'] ?? false,
      conclusion: json['conclusion'] ?? false,
      customParams: json['customParams'] ?? [],
    );
  }
}

class Body {
  final bool enabled;
  final bool features;
  final bool examples;
  final bool facts;
  final bool diagram;

  Body({
    required this.enabled,
    required this.features,
    required this.examples,
    required this.facts,
    required this.diagram,
  });

  factory Body.fromJson(Map<String, dynamic> json) {
    return Body(
      enabled: json['enabled'] ?? false,
      features: json['features'] ?? false,
      examples: json['examples'] ?? false,
      facts: json['facts'] ?? false,
      diagram: json['diagram'] ?? false,
    );
  }
}

class Submission {
  final int attemptNumber;
  final DateTime submittedAt;
  final List<AnswerImage> answerImages;
  final String textAnswer;

  Submission({
    required this.attemptNumber,
    required this.submittedAt,
    required this.answerImages,
    required this.textAnswer,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      attemptNumber: json['attemptNumber'] ?? 0,
      submittedAt: DateTime.parse(json['submittedAt']),
      answerImages: (json['answerImages'] as List<dynamic>?)
          ?.map((e) => AnswerImage.fromJson(e))
          .toList() ??
          [],
      textAnswer: json['textAnswer'] ?? '',
    );
  }
}

class AnswerImage {
  final String imageUrl;
  final String cloudinaryPublicId;
  final String originalName;
  final DateTime uploadedAt;
  final String id;

  AnswerImage({
    required this.imageUrl,
    required this.cloudinaryPublicId,
    required this.originalName,
    required this.uploadedAt,
    required this.id,
  });

  factory AnswerImage.fromJson(Map<String, dynamic> json) {
    return AnswerImage(
      imageUrl: json['imageUrl'] ?? '',
      cloudinaryPublicId: json['cloudinaryPublicId'] ?? '',
      originalName: json['originalName'] ?? '',
      uploadedAt: DateTime.parse(json['uploadedAt']),
      id: json['_id'] ?? '',
    );
  }
}

class User {
  final String mobile;
  final String clientId;

  User({
    required this.mobile,
    required this.clientId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      mobile: json['mobile'] ?? '',
      clientId: json['clientId'] ?? '',
    );
  }
}

class AttemptInfo {
  final int currentAttempt;
  final int totalAttempts;

  AttemptInfo({
    required this.currentAttempt,
    required this.totalAttempts,
  });

  factory AttemptInfo.fromJson(Map<String, dynamic> json) {
    return AttemptInfo(
      currentAttempt: json['currentAttempt'] ?? 0,
      totalAttempts: json['totalAttempts'] ?? 0,
    );
  }
}
