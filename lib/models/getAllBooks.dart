class GetAllBooks {
  bool? success;
  int? responseCode;
  Data? data;

  GetAllBooks({this.success, this.responseCode, this.data});

  GetAllBooks.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    responseCode = json['responseCode'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['responseCode'] = this.responseCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Books>? books;
  Pagination? pagination;

  Data({this.books, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['books'] != null) {
      books = <Books>[];
      json['books'].forEach((v) {
        books!.add(new Books.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.books != null) {
      data['books'] = this.books!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Books {
  String? id;
  String? title;
  String? description;
  String? author;
  String? publisher;
  String? language;
  double? rating;
  int? ratingCount;
  String? mainCategory;
  String? subCategory;
  String? effectiveSubCategory;
  String? fullCategory;
  List<String>? tags;
  String? coverImage;
  bool? isPublic;
  String? createdAt;
  String? updatedAt;
  bool? isOwnBook;

  Books(
      {this.id,
        this.title,
        this.description,
        this.author,
        this.publisher,
        this.language,
        this.rating,
        this.ratingCount,
        this.mainCategory,
        this.subCategory,
        this.effectiveSubCategory,
        this.fullCategory,
        this.tags,
        this.coverImage,
        this.isPublic,
        this.createdAt,
        this.updatedAt,
        this.isOwnBook});

  Books.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    author = json['author'];
    publisher = json['publisher'];
    language = json['language'];
    rating = json['rating'];
    ratingCount = json['ratingCount'];
    mainCategory = json['mainCategory'];
    subCategory = json['subCategory'];
    effectiveSubCategory = json['effectiveSubCategory'];
    fullCategory = json['fullCategory'];
    tags = json['tags'].cast<String>();
    coverImage = json['coverImage'];
    isPublic = json['isPublic'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isOwnBook = json['isOwnBook'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['author'] = this.author;
    data['publisher'] = this.publisher;
    data['language'] = this.language;
    data['rating'] = this.rating;
    data['ratingCount'] = this.ratingCount;
    data['mainCategory'] = this.mainCategory;
    data['subCategory'] = this.subCategory;
    data['effectiveSubCategory'] = this.effectiveSubCategory;
    data['fullCategory'] = this.fullCategory;
    data['tags'] = this.tags;
    data['coverImage'] = this.coverImage;
    data['isPublic'] = this.isPublic;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['isOwnBook'] = this.isOwnBook;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? totalBooks;
  bool? hasNext;
  bool? hasPrev;

  Pagination(
      {this.currentPage,
        this.totalPages,
        this.totalBooks,
        this.hasNext,
        this.hasPrev});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    totalBooks = json['totalBooks'];
    hasNext = json['hasNext'];
    hasPrev = json['hasPrev'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentPage'] = this.currentPage;
    data['totalPages'] = this.totalPages;
    data['totalBooks'] = this.totalBooks;
    data['hasNext'] = this.hasNext;
    data['hasPrev'] = this.hasPrev;
    return data;
  }
}
