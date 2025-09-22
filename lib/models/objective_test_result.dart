class TestResultResponse {
  final bool success;
  final TestResultData data;

  TestResultResponse({required this.success, required this.data});

  factory TestResultResponse.fromJson(Map<String, dynamic> json) {
    return TestResultResponse(
      success: json['success'] ?? false,
      data: TestResultData.fromJson(json['data']),
    );
  }
}

class TestResultData {
  final String id;
  final String userId;
  final TestMeta testId;
  final String clientId;
  final String startTime;
  final String status;
  final String submittedAt;
  final String createdAt;
  final String updatedAt;
  final int answeredQuestions;
  final Map<String, dynamic> userAnswers;
  final String completionTime;
  final int correctAnswers;
  final int score;
  final int totalQuestions;
  final LevelBreakdown levelBreakdown;
  final List<Question> questions;

  TestResultData({
    required this.id,
    required this.userId,
    required this.testId,
    required this.clientId,
    required this.startTime,
    required this.status,
    required this.submittedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.answeredQuestions,
    required this.userAnswers,
    required this.completionTime,
    required this.correctAnswers,
    required this.score,
    required this.totalQuestions,
    required this.levelBreakdown,
    required this.questions,
  });

  factory TestResultData.fromJson(Map<String, dynamic> json) {
    return TestResultData(
      id: json['_id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      testId: TestMeta.fromJson(json['testId'] ?? {}),
      clientId: json['clientId']?.toString() ?? '',
      startTime: json['startTime']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      submittedAt: json['submittedAt']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
      answeredQuestions: json['answeredQuestions'] ?? 0,
      userAnswers: Map<String, dynamic>.from(json['userAnswers'] ?? {}),
      completionTime: json['completionTime']?.toString() ?? '',
      correctAnswers: json['correctAnswers'] ?? 0,
      score: json['score'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      levelBreakdown: LevelBreakdown.fromJson(json['levelBreakdown'] ?? {}),
      questions: (json['questions'] as List? ?? [])
          .map((q) => Question.fromJson(q))
          .toList(),
    );
  }
}

class TestMeta {
  final String id;
  final String name;
  final String category;
  final String subcategory;

  TestMeta({
    required this.id,
    required this.name,
    required this.category,
    required this.subcategory,
  });

  factory TestMeta.fromJson(Map<String, dynamic> json) {
    return TestMeta(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      subcategory: json['subcategory']?.toString() ?? '',
    );
  }
}

class LevelBreakdown {
  final LevelData L1;
  final LevelData L2;
  final LevelData L3;

  LevelBreakdown({required this.L1, required this.L2, required this.L3});

  factory LevelBreakdown.fromJson(Map<String, dynamic> json) {
    return LevelBreakdown(
      L1: LevelData.fromJson(json['L1'] ?? {}),
      L2: LevelData.fromJson(json['L2'] ?? {}),
      L3: LevelData.fromJson(json['L3'] ?? {}),
    );
  }
}

class LevelData {
  final int total;
  final int correct;
  final int score;

  LevelData({required this.total, required this.correct, required this.score});

  factory LevelData.fromJson(Map<String, dynamic> json) {
    return LevelData(
      total: json['total'] ?? 0,
      correct: json['correct'] ?? 0,
      score: json['score'] ?? 0,
    );
  }
}

class Question {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String difficulty;
  final int estimatedTime;
  final int positiveMarks;
  final int negativeMarks;
  final String test;
  final Solution solution;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.difficulty,
    required this.estimatedTime,
    required this.positiveMarks,
    required this.negativeMarks,
    required this.test,
    required this.solution,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'] ?? 0,
      difficulty: json['difficulty']?.toString() ?? '',
      estimatedTime: json['estimatedTime'] ?? 0,
      positiveMarks: json['positiveMarks'] ?? 0,
      negativeMarks: json['negativeMarks'] ?? 0,
      test: json['test']?.toString() ?? '',
      solution: Solution.fromJson(json['solution'] ?? {}),
    );
  }
}

class Solution {
  final String type;
  final String text;
  final VideoSolution video;
  final ImageSolution image;

  Solution({
    required this.type,
    required this.text,
    required this.video,
    required this.image,
  });

  factory Solution.fromJson(Map<String, dynamic> json) {
    return Solution(
      type: json['type']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      video: VideoSolution.fromJson(json['video'] ?? {}),
      image: ImageSolution.fromJson(json['image'] ?? {}),
    );
  }
}

class VideoSolution {
  final String url;
  final String title;
  final String description;
  final int duration;

  VideoSolution({
    required this.url,
    required this.title,
    required this.description,
    required this.duration,
  });

  factory VideoSolution.fromJson(Map<String, dynamic> json) {
    return VideoSolution(
      url: json['url']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      duration: json['duration'] ?? 0,
    );
  }
}

class ImageSolution {
  final String url;
  final String caption;

  ImageSolution({required this.url, required this.caption});

  factory ImageSolution.fromJson(Map<String, dynamic> json) {
    return ImageSolution(
      url: json['url']?.toString() ?? '',
      caption: json['caption']?.toString() ?? '',
    );
  }
}
