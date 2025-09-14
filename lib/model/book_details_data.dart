class BookDetailsData {
  bool? success;
  int? responseCode;
  BookDetails? data;

  BookDetailsData({this.success, this.responseCode, this.data});

  factory BookDetailsData.fromJson(Map<String, dynamic> json) {
    return BookDetailsData(
      success: json['success'],
      responseCode: json['responseCode'],
      data: json['data'] != null ? BookDetails.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['responseCode'] = responseCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class BookDetails {
  String? id;
  String? title;
  String? description;
  String? author;
  String? publisher;
  String? language;
  num? rating;
  int? ratingCount;
  String? mainCategory;
  String? subCategory;
  String? effectiveSubCategory;
  String? fullCategory;
  String? tag;
  String? coverImage;
  String? cover_image_url;
  bool? isPublic;
  String? createdAt;
  String? updatedAt;
  bool? isOwnBook;
  String? examName;
  String? summary;
  String? paperName;
  String? subjectName;
  bool? is_added_to_my_books;
  bool? isVideoAvailable;
  bool? isPaid;
  List<Chapter>? chapters;
  List<Review>? reviews;
  List<IndexChapter>? index;
  AiGuidelines? aiGuidelines;
  bool? bookEmbedded;
  bool? chatAvailable;

  BookDetails({
    this.id,
    this.title,
    this.description,
    this.author,
    this.publisher,
    this.language,
    this.rating,
    this.ratingCount,
    this.isVideoAvailable,
    this.isPaid,
    this.mainCategory,
    this.subCategory,
    this.effectiveSubCategory,
    this.fullCategory,
    this.tag,
    this.coverImage,
    this.cover_image_url,
    this.is_added_to_my_books,
    this.isPublic,
    this.createdAt,
    this.updatedAt,
    this.isOwnBook,
    this.examName,
    this.paperName,
    this.summary,
    this.subjectName,
    this.chapters,
    this.reviews,
    this.index,
    this.aiGuidelines,
    this.bookEmbedded,
    this.chatAvailable,
  });

  factory BookDetails.fromJson(Map<String, dynamic> json) {
    return BookDetails(
      id: json['book_id'],
      title: json['title'],
      description: json['description'],
      author: json['author'],
      publisher: json['publisher'],
      language: json['language'],
      isVideoAvailable: json['isVideoAvailable'],
      isPaid: json['isPaid'],
      rating: json['rating']?.toDouble(),
      ratingCount: json['rating_count'],
      mainCategory: json['mainCategory'],
      subCategory: json['subCategory'],
      effectiveSubCategory: json['effectiveSubCategory'],
      fullCategory: json['fullCategory'],
      tag: json['tag'],
      coverImage: json['coverImage'],
      is_added_to_my_books: json['is_added_to_my_books'],
      cover_image_url: json['cover_image_url'],
      isPublic: json['isPublic'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      isOwnBook: json['isOwnBook'],
      examName: json['exam_name'],
      paperName: json['paper_name'],
      summary: json['summary'],
      subjectName: json['subject_name'],

      bookEmbedded: json['bookEmbedded'],
      chatAvailable: json['chatAvailable'],
      chapters:
          json['chapters'] != null
              ? List<Chapter>.from(
                json['chapters'].map((x) => Chapter.fromJson(x)),
              )
              : null,
      reviews:
          json['reviews'] != null
              ? List<Review>.from(
                json['reviews'].map((x) => Review.fromJson(x)),
              )
              : null,

      index:
          json['index'] != null
              ? List<IndexChapter>.from(
                json['index'].map((x) => IndexChapter.fromJson(x)),
              )
              : null,
      aiGuidelines:
          json['aiGuidelines'] != null
              ? AiGuidelines.fromJson(json['aiGuidelines'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['book_id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['author'] = author;
    data['publisher'] = publisher;
    data['language'] = language;
    data['isVideoAvailable'] = isVideoAvailable;
    data['isPaid'] = isPaid;
    data['rating'] = rating;
    data['rating_count'] = ratingCount;
    data['mainCategory'] = mainCategory;
    data['is_added_to_my_books'] = is_added_to_my_books;
    data['subCategory'] = subCategory;
    data['effectiveSubCategory'] = effectiveSubCategory;
    data['fullCategory'] = fullCategory;
    data['tag'] = tag;
    data['coverImage'] = coverImage;
    data['cover_image_url'] = cover_image_url;
    data['isPublic'] = isPublic;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['isOwnBook'] = isOwnBook;
    data['exam_name'] = examName;
    data['summary'] = summary;
    data['paper_name'] = paperName;
    data['subject_name'] = subjectName;
    data['bookEmbedded'] = bookEmbedded;
    data['chatAvailable'] = chatAvailable;
    if (chapters != null) {
      data['chapters'] = chapters!.map((x) => x.toJson()).toList();
    }
    if (reviews != null) {
      data['reviews'] = reviews!.map((x) => x.toJson()).toList();
    }
    if (index != null) {
      data['index'] = index!.map((x) => x.toJson()).toList();
    }
    if (this.aiGuidelines != null) {
      data['aiGuidelines'] = this.aiGuidelines!.toJson();
    }
    return data;
  }
}

class AiGuidelines {
  String? message;
  String? prompt;
  List<FAQs>? fAQs;

  AiGuidelines({this.message, this.prompt, this.fAQs});

  AiGuidelines.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    prompt = json['prompt'];
    if (json['FAQs'] != null) {
      fAQs = <FAQs>[];
      json['FAQs'].forEach((v) {
        fAQs!.add(FAQs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['prompt'] = this.prompt;
    if (this.fAQs != null) {
      data['FAQs'] = this.fAQs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FAQs {
  String? question;
  String? sId;

  FAQs({this.question, this.sId});

  FAQs.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question'] = this.question;
    data['_id'] = this.sId;
    return data;
  }
}

class Chapter {
  String? id;
  String? title;
  String? subtitle;
  bool? isLocked;
  int? progress;
  List<String>? topics;

  Chapter({
    this.id,
    this.title,
    this.subtitle,
    this.isLocked,
    this.progress,
    this.topics,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      isLocked: json['isLocked'],
      progress: json['progress'],
      topics: json['topics']?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['isLocked'] = isLocked;
    data['progress'] = progress;
    data['topics'] = topics;
    return data;
  }
}

class Review {
  String? id;
  String? userName;
  num? rating;
  String? comment;
  DateTime? date;

  Review({this.id, this.userName, this.rating, this.comment, this.date});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userName: json['userName'],
      rating: json['rating'],
      comment: json['comment'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userName'] = userName;
    data['rating'] = rating;
    data['comment'] = comment;
    data['date'] = date?.toIso8601String();
    return data;
  }
}

class IndexChapter {
  String? chapterId;
  String? chapterName;
  List<Topic>? topics;

  IndexChapter({this.chapterName, this.topics, this.chapterId});

  factory IndexChapter.fromJson(Map<String, dynamic> json) {
    return IndexChapter(
      chapterName: json['chapter_name'],
      chapterId: json['chapter_id'],
      topics:
          json['topics'] != null
              ? List<Topic>.from(json['topics'].map((x) => Topic.fromJson(x)))
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapter_name': chapterName,
      'chapter_id': chapterId,
      'topics': topics?.map((x) => x.toJson()).toList(),
    };
  }
}

class Topic {
  String? topicName;
  String? topicId;

  Topic({this.topicName, this.topicId});

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(topicName: json['topic_name'], topicId: json['topic_id']);
  }

  Map<String, dynamic> toJson() {
    return {'topic_name': topicName, 'topic_id': topicId};
  }
}
