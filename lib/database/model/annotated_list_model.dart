class AnnotatedList {
  final int? id;
  final String questionId;
  final List<String> annotatedImagePaths;
  final DateTime createdAt;
  final bool isCompleted;

  AnnotatedList({
    this.id,
    required this.questionId,
    required this.annotatedImagePaths,
    required this.createdAt,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'questionId': questionId,
      'annotatedImagePaths': annotatedImagePaths.join(','), // Store as comma-separated string
      'createdAt': createdAt.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory AnnotatedList.fromMap(Map<String, dynamic> map) {
    return AnnotatedList(
      id: map['id'],
      questionId: map['questionId'],
      annotatedImagePaths: (map['annotatedImagePaths'] as String).split(','),
      createdAt: DateTime.parse(map['createdAt']),
      isCompleted: map['isCompleted'] == 1,
    );
  }
} 