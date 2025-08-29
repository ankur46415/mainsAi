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
      attemptHistory: (json['attemptHistory'] as List)
          .map((e) => AttemptHistory.fromJson(e))
          .toList(),
    );
  }
}

class TestInfo {
  final String id, name, category, subcategory, description, estimatedTime;
  final int testMaximumMarks;

  TestInfo({
    required this.id,
    required this.name,
    required this.category,
    required this.subcategory,
    required this.description,
    required this.estimatedTime,
    required this.testMaximumMarks,
  });

  factory TestInfo.fromJson(Map<String, dynamic> json) {
    return TestInfo(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      subcategory: json['subcategory']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      estimatedTime: json['estimatedTime']?.toString() ?? '',
      testMaximumMarks: json['testMaximumMarks'] is num
          ? (json['testMaximumMarks'] as num).toInt()
          : 0,
    );
  }
}

class AttemptStats {
  final int totalAttempts;
  final int maxAttempts;
  final double bestScore;    
  final double averageScore;  
  final double latestScore;  
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
      bestScore: (json['bestScore'] ?? 0).toDouble(),
      averageScore: (json['averageScore'] ?? 0).toDouble(),
      latestScore: (json['latestScore'] ?? 0).toDouble(),
      canTakeMoreAttempts: json['canTakeMoreAttempts'] ?? false,
    );
  }
}

class AttemptHistory {
  final int attemptNumber;
  final double score;           
  final int correctAnswers;
  final int totalQuestions;
  final double totalMarksEarned; 
  final String completionTime;
  final String submittedAt;
  final Map<String, dynamic> answers;
  final Map<String, dynamic> levelBreakdown;

  AttemptHistory({
    required this.attemptNumber,
    required this.score,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.totalMarksEarned,
    required this.completionTime,
    required this.submittedAt,
    required this.answers,
    required this.levelBreakdown,
  });

  factory AttemptHistory.fromJson(Map<String, dynamic> json) {
    return AttemptHistory(
      attemptNumber: json['attemptNumber'] ?? 0,
      score: (json['score'] ?? 0).toDouble(),
      correctAnswers: json['correctAnswers'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      totalMarksEarned: (json['totalMarksEarned'] ?? json['score'] ?? 0).toDouble(),
      completionTime: json['completionTime']?.toString() ?? '',
      submittedAt: json['submittedAt']?.toString() ?? '',
      answers: (json['answers'] ?? {}) as Map<String, dynamic>,
      levelBreakdown: (json['levelBreakdown'] ?? {}) as Map<String, dynamic>,
    );
  }
}
