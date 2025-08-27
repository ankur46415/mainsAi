class RagChatForBook {
  bool? success;
  String? answer;
  int? confidence;
  int? sources;
  String? method;
  String? bookId;
  String? bookTitle;
  String? modelUsed;
  int? tokensUsed;
  Timing? timing;

  RagChatForBook(
      {this.success,
      this.answer,
      this.confidence,
      this.sources,
      this.method,
      this.bookId,
      this.bookTitle,
      this.modelUsed,
      this.tokensUsed,
      this.timing});

  RagChatForBook.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    answer = json['answer'];
    confidence = json['confidence'];
    sources = json['sources'];
    method = json['method'];
    bookId = json['bookId'];
    bookTitle = json['bookTitle'];
    modelUsed = json['modelUsed'];
    tokensUsed = json['tokensUsed'];
    timing =
        json['timing'] != null ? new Timing.fromJson(json['timing']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['answer'] = this.answer;
    data['confidence'] = this.confidence;
    data['sources'] = this.sources;
    data['method'] = this.method;
    data['bookId'] = this.bookId;
    data['bookTitle'] = this.bookTitle;
    data['modelUsed'] = this.modelUsed;
    data['tokensUsed'] = this.tokensUsed;
    if (this.timing != null) {
      data['timing'] = this.timing!.toJson();
    }
    return data;
  }
}

class Timing {
  String? retrieval;
  String? processing;
  String? generation;
  String? aiProcessing;
  String? totalResponse;

  Timing(
      {this.retrieval,
      this.processing,
      this.generation,
      this.aiProcessing,
      this.totalResponse});

  Timing.fromJson(Map<String, dynamic> json) {
    retrieval = json['retrieval'];
    processing = json['processing'];
    generation = json['generation'];
    aiProcessing = json['aiProcessing'];
    totalResponse = json['totalResponse'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['retrieval'] = this.retrieval;
    data['processing'] = this.processing;
    data['generation'] = this.generation;
    data['aiProcessing'] = this.aiProcessing;
    data['totalResponse'] = this.totalResponse;
    return data;
  }
}
