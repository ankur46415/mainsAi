class Annotation {
  final int? id;
  final String questionId;
  final String imagePath;
  final List<int> imageData;
  final DateTime createdAt;

  Annotation({
    this.id,
    required this.questionId,
    required this.imagePath,
    required this.imageData,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'questionId': questionId,
    'imagePath': imagePath,
    'imageData': imageData,
    'createdAt': createdAt.toIso8601String(),
  };


  factory Annotation.fromMap(Map<String, dynamic> map) => Annotation(
    id: map['id'],
    questionId: map['questionId'],
    imagePath: map['imagePath'],
    imageData: List<int>.from(map['imageData']), // Assumes it’s stored as List<int>
    createdAt: DateTime.parse(map['createdAt']),
  );
}

