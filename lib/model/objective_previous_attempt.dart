class ObjectiveTestResult {
  final TestInfo testInfo;
  final AttemptStats attemptStats;
  final List<AttemptHistory> attemptHistory;

  ObjectiveTestResult({
    required this.testInfo,
    required this.attemptStats,
    required this.attemptHistory,
  });

  factory ObjectiveTestResult.fromJson(Map<String, dynamic> json) {
    return ObjectiveTestResult(
      testInfo: TestInfo.fromJson(json['testInfo']),
      attemptStats: AttemptStats.fromJson(json['attemptStats']),
      attemptHistory:
          (json['attemptHistory'] as List)
              .map((e) => AttemptHistory.fromJson(e))
              .toList(),
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
  final int totalAttempts, maxAttempts, bestScore, latestScore;
  final double averageScore;
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
          : (json['averageScore'] is double)
              ? json['averageScore'] as double
              : 0.0,
      latestScore: json['latestScore'] ?? 0,
      canTakeMoreAttempts: json['canTakeMoreAttempts'] ?? false,
    );
  }
}

class AttemptHistory {
  final int attemptNumber, score, correctAnswers, totalQuestions;
  final String completionTime, submittedAt;
  final Map<String, dynamic> answers;
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
      answers: json['answers'] ?? {},
      levelBreakdown: json['levelBreakdown'] ?? {},
    );
  }
}
