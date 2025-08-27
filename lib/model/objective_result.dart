class ObjectiveTestResultCurrent {
  final TestInfo testInfo;
  final AttemptStats attemptStats;
  final List<AttemptHistory> attemptHistory;
  final List<Question> questions;

  ObjectiveTestResultCurrent({
    required this.testInfo,
    required this.attemptStats,
    required this.attemptHistory,
    required this.questions,
  });

  factory ObjectiveTestResultCurrent.fromJson(Map<String, dynamic> json) {
    return ObjectiveTestResultCurrent(
      testInfo: TestInfo.fromJson(json['testInfo'] ?? {}),
      attemptStats: AttemptStats.fromJson(json['attemptStats'] ?? {}),
      attemptHistory: (json['attemptHistory'] as List?)?.map((e) => AttemptHistory.fromJson(e)).toList() ?? [],
      questions: (json['questions'] as List?)?.map((e) => Question.fromJson(e)).toList() ?? [],
    );
  }
}

class TestInfo {
  final String id, name, category, subcategory, description, estimatedTime;

  TestInfo({
    required this.id,
    required this.name,
    required this.category,
    required this.subcategory,
    required this.description,
    required this.estimatedTime,
  });

  factory TestInfo.fromJson(Map<String, dynamic> json) {
    return TestInfo(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      subcategory: json['subcategory']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      estimatedTime: json['estimatedTime']?.toString() ?? '',
    );
  }
}

class AttemptStats {
  final int totalAttempts, maxAttempts, bestScore, averageScore, latestScore;
  final bool canTakeMoreAttempts;

  AttemptStats({
    required this.totalAttempts,
    required this.maxAttempts,
    required this.bestScore,
    required this.averageScore,
    required this.latestScore,
    required this.canTakeMoreAttempts,
  });

  factory AttemptStats.fromJson(Map<String, dynamic> json) {
    return AttemptStats(
      totalAttempts: json['totalAttempts'] ?? 0,
      maxAttempts: json['maxAttempts'] ?? 0,
      bestScore: json['bestScore'] ?? 0,
     averageScore: (json['averageScore'] is int)
          ? (json['averageScore'] as int).toDouble()
          : (json['averageScore'] ?? 0.0),
      latestScore: json['latestScore'] ?? 0,
      canTakeMoreAttempts: json['canTakeMoreAttempts'] ?? false,
    );
  }
}

class AttemptHistory {
  final int attemptNumber, score, correctAnswers, totalQuestions;
  final String completionTime, submittedAt;
  final Map<String, int> answers;
  final Map<String, dynamic> levelBreakdown;

  AttemptHistory({
    required this.attemptNumber,
    required this.score,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.completionTime,
    required this.submittedAt,
    required this.answers,
    required this.levelBreakdown,
  });

  factory AttemptHistory.fromJson(Map<String, dynamic> json) {
    return AttemptHistory(
      attemptNumber: json['attemptNumber'] ?? 0,
      score: json['score'] ?? 0,
      correctAnswers: json['correctAnswers'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      completionTime: json['completionTime']?.toString() ?? '',
      submittedAt: json['submittedAt']?.toString() ?? '',
      answers: Map<String, int>.from(json['answers'] ?? {}),
      levelBreakdown: Map<String, dynamic>.from(json['levelBreakdown'] ?? {}),
    );
  }
}

class Question {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final Solution solution;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.solution,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
      options: (json['options'] as List?)?.map((e) => e.toString()).toList() ?? [],
      correctAnswer: json['correctAnswer'] ?? 0,
      solution: Solution.fromJson(json['solution'] ?? {}),
    );
  }
}

class Solution {
  final String text;

  Solution({required this.text});

  factory Solution.fromJson(Map<String, dynamic> json) {
    return Solution(
      text: json['text']?.toString() ?? '',
    );
  }
}