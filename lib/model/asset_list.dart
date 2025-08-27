class AssetListGet {
  bool? success;
  String? qrCodeType;
  Book? book;
  List<Chapters>? chapters;
  List<Summaries>? summaries;
  List<dynamic>? videos;
  List<dynamic>? pyqs;
  SubjectiveQuestionSets? subjectiveQuestionSets;
  ObjectiveQuestionSets? objectiveQuestionSets;

  AssetListGet({
    this.success,
    this.qrCodeType,
    this.book,
    this.chapters,
    this.summaries,
    this.videos,
    this.pyqs,
    this.subjectiveQuestionSets,
    this.objectiveQuestionSets,
  });

  AssetListGet.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    qrCodeType = json['qrCodeType'];
    book = json['book'] != null ? Book.fromJson(json['book']) : null;

    if (json['chapters'] != null) {
      chapters = List<Chapters>.from(
        json['chapters'].map((x) => Chapters.fromJson(x)),
      );
    }

    if (json['summaries'] != null) {
      summaries = List<Summaries>.from(
        json['summaries'].map((x) => Summaries.fromJson(x)),
      );
    }

    videos = json['videos'] != null ? List<dynamic>.from(json['videos']) : [];
    pyqs = json['pyqs'] != null ? List<dynamic>.from(json['pyqs']) : [];

    subjectiveQuestionSets =
        json['subjectiveQuestionSets'] != null
            ? SubjectiveQuestionSets.fromJson(json['subjectiveQuestionSets'])
            : null;

    objectiveQuestionSets =
        json['objectiveQuestionSets'] != null
            ? ObjectiveQuestionSets.fromJson(json['objectiveQuestionSets'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['qrCodeType'] = qrCodeType;
    if (book != null) data['book'] = book!.toJson();
    if (chapters != null) {
      data['chapters'] = chapters!.map((e) => e.toJson()).toList();
    }
    if (summaries != null) {
      data['summaries'] = summaries!.map((e) => e.toJson()).toList();
    }
    data['videos'] = videos;
    data['pyqs'] = pyqs;

    if (subjectiveQuestionSets != null) {
      data['subjectiveQuestionSets'] = subjectiveQuestionSets!.toJson();
    }

    if (objectiveQuestionSets != null) {
      data['objectiveQuestionSets'] = objectiveQuestionSets!.toJson();
    }

    return data;
  }
}

class Book {
  String? id;
  String? title;
  String? description;
  String? coverImage;

  Book({this.id, this.title, this.description, this.coverImage});

  Book.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    coverImage = json['coverImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['coverImage'] = this.coverImage;
    return data;
  }
}

class Chapters {
  String? sId;
  String? title;
  String? description;
  int? order;

  Chapters({this.sId, this.title, this.description, this.order});

  Chapters.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['order'] = this.order;
    return data;
  }
}

class Summaries {
  String? sId;
  String? content;
  String? itemType;
  String? itemId;
  String? createdBy;
  bool? isWorkbook;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Summaries({
    this.sId,
    this.content,
    this.itemType,
    this.itemId,
    this.createdBy,
    this.isWorkbook,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Summaries.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    content = json['content'];
    itemType = json['itemType'];
    itemId = json['itemId'];
    createdBy = json['createdBy'];
    isWorkbook = json['isWorkbook'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['content'] = this.content;
    data['itemType'] = this.itemType;
    data['itemId'] = this.itemId;
    data['createdBy'] = this.createdBy;
    data['isWorkbook'] = this.isWorkbook;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class SubjectiveQuestionSets {
  List<dynamic>? l1;
  List<dynamic>? l2;
  List<dynamic>? l3;

  SubjectiveQuestionSets({this.l1, this.l2, this.l3});

  SubjectiveQuestionSets.fromJson(Map<String, dynamic> json) {
    l1 = json['L1'] != null ? List<dynamic>.from(json['L1']) : [];
    l2 = json['L2'] != null ? List<dynamic>.from(json['L2']) : [];
    l3 = json['L3'] != null ? List<dynamic>.from(json['L3']) : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (l1 != null) data['L1'] = l1;
    if (l2 != null) data['L2'] = l2;
    if (l3 != null) data['L3'] = l3;
    return data;
  }
}

class ObjectiveQuestionSets {
  List<L1>? l1;
  List<L1>? l2;
  List<L1>? l3;

  ObjectiveQuestionSets({this.l1, this.l2, this.l3});

  ObjectiveQuestionSets.fromJson(Map<String, dynamic> json) {
    l1 = (json['L1'] as List?)?.map((item) => L1.fromJson(item)).toList();
    l2 = (json['L2'] as List?)?.map((item) => L1.fromJson(item)).toList();
    l3 = (json['L3'] as List?)?.map((item) => L1.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (l1 != null) data['L1'] = l1!.map((v) => v.toJson()).toList();
    if (l2 != null) data['L2'] = l2!.map((v) => v.toJson()).toList();
    if (l3 != null) data['L3'] = l3!.map((v) => v.toJson()).toList();
    return data;
  }
}

class L1 {
  String? sId;
  String? name;
  String? description;
  String? level;
  String? type;
  String? book;
  String? chapter;
  bool? isWorkbook;
  List<Questions>? questions;
  String? createdBy;
  List<String>? tags;
  bool? isActive;
  int? totalQuestions;
  String? createdAt;
  String? updatedAt;
  int? iV;

  L1({
    this.sId,
    this.name,
    this.description,
    this.level,
    this.type,
    this.book,
    this.chapter,
    this.isWorkbook,
    this.questions,
    this.createdBy,
    this.tags,
    this.isActive,
    this.totalQuestions,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  L1.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    level = json['level'];
    type = json['type'];
    book = json['book'];
    chapter = json['chapter'];
    isWorkbook = json['isWorkbook'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
      });
    }
    createdBy = json['createdBy'];
    if (json['tags'] != null) {
      tags = List<String>.from(json['tags']);
    }
    isActive = json['isActive'];
    totalQuestions = json['totalQuestions'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['level'] = this.level;
    data['type'] = this.type;
    data['book'] = this.book;
    data['chapter'] = this.chapter;
    data['isWorkbook'] = this.isWorkbook;
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    data['createdBy'] = this.createdBy;
    if (tags != null) {
      data['tags'] = this.tags;
    }
    data['isActive'] = this.isActive;
    data['totalQuestions'] = this.totalQuestions;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Questions {
  String? sId;
  String? question;
  List<String>? options;
  String? correctAnswer;
  int? correctedAnswerForOptions;
  String? difficulty;
  String? questionSet;
  String? keyWords;
  String? book;
  String? chapter;
  bool? isWorkbook;
  String? createdBy;
  bool? isActive;
  int? timesAnswered;
  int? timesCorrect;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Questions({
    this.sId,
    this.question,
    this.options,
    this.correctAnswer,
    this.keyWords,
    this.correctedAnswerForOptions,
    this.difficulty,
    this.questionSet,
    this.book,
    this.chapter,
    this.isWorkbook,
    this.createdBy,

    this.isActive,
    this.timesAnswered,
    this.timesCorrect,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Questions.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    question = json['question'];
    options = json['options'].cast<String>();
    correctAnswer = json['answer'];
    keyWords = json['keywords'];
    difficulty = json['difficulty'];
    questionSet = json['questionSet'];
    correctedAnswerForOptions = json['correctAnswer'];
    book = json['book'];
    chapter = json['chapter'];
    isWorkbook = json['isWorkbook'];
    createdBy = json['createdBy'];

    isActive = json['isActive'];
    timesAnswered = json['timesAnswered'];
    timesCorrect = json['timesCorrect'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['question'] = this.question;
    data['options'] = this.options;
    data['answer'] = this.correctAnswer;
    data['keywords'] = this.keyWords;
    data['difficulty'] = this.difficulty;
    data['correctAnswer'] = this.correctedAnswerForOptions;
    data['questionSet'] = this.questionSet;
    data['book'] = this.book;
    data['chapter'] = this.chapter;
    data['isWorkbook'] = this.isWorkbook;
    data['createdBy'] = this.createdBy;

    data['isActive'] = this.isActive;
    data['timesAnswered'] = this.timesAnswered;
    data['timesCorrect'] = this.timesCorrect;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
