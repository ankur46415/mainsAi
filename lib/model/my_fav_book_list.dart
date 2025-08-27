class MyFvBookList {
  bool? success;
  String? message;
  Data? data;

  MyFvBookList({this.success, this.message, this.data});

  MyFvBookList.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
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
  String? mybookId;
  String? bookId;
  String? title;
  String? author;
  String? publisher;
  String? description;
  String? coverImage;
  String? coverImageUrl;
  num? rating;
  int? ratingCount;
  String? mainCategory;
  String? subCategory;
  String? exam;
  String? paper;
  String? subject;
  List<String>? tags;
  int? viewCount;
  String? addedAt;
  String? lastAccessedAt;
  String? personalNote;
  int? priority;

  Books(
      {this.mybookId,
        this.bookId,
        this.title,
        this.author,
        this.publisher,
        this.description,
        this.coverImage,
        this.coverImageUrl,
        this.rating,
        this.ratingCount,
        this.mainCategory,
        this.subCategory,
        this.exam,
        this.paper,
        this.subject,
        this.tags,
        this.viewCount,
        this.addedAt,
        this.lastAccessedAt,
        this.personalNote,
        this.priority});

  Books.fromJson(Map<String, dynamic> json) {
    mybookId = json['mybook_id'];
    bookId = json['book_id'];
    title = json['title'];
    author = json['author'];
    publisher = json['publisher'];
    description = json['description'];
    coverImage = json['cover_image'];
    coverImageUrl = json['cover_image_url'];
    rating = json['rating'];
    ratingCount = json['rating_count'];
    mainCategory = json['main_category'];
    subCategory = json['sub_category'];
    exam = json['exam'];
    paper = json['paper'];
    subject = json['subject'];
    tags = json['tags'].cast<String>();
    viewCount = json['view_count'];
    addedAt = json['added_at'];
    lastAccessedAt = json['last_accessed_at'];
    personalNote = json['personal_note'];
    priority = json['priority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mybook_id'] = this.mybookId;
    data['book_id'] = this.bookId;
    data['title'] = this.title;
    data['author'] = this.author;
    data['publisher'] = this.publisher;
    data['description'] = this.description;
    data['cover_image'] = this.coverImage;
    data['cover_image_url'] = this.coverImageUrl;
    data['rating'] = this.rating;
    data['rating_count'] = this.ratingCount;
    data['main_category'] = this.mainCategory;
    data['sub_category'] = this.subCategory;
    data['exam'] = this.exam;
    data['paper'] = this.paper;
    data['subject'] = this.subject;
    data['tags'] = this.tags;
    data['view_count'] = this.viewCount;
    data['added_at'] = this.addedAt;
    data['last_accessed_at'] = this.lastAccessedAt;
    data['personal_note'] = this.personalNote;
    data['priority'] = this.priority;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? totalBooks;
  int? booksPerPage;
  bool? hasNext;
  bool? hasPrev;

  Pagination(
      {this.currentPage,
        this.totalPages,
        this.totalBooks,
        this.booksPerPage,
        this.hasNext,
        this.hasPrev});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    totalPages = json['total_pages'];
    totalBooks = json['total_books'];
    booksPerPage = json['books_per_page'];
    hasNext = json['has_next'];
    hasPrev = json['has_prev'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['total_pages'] = this.totalPages;
    data['total_books'] = this.totalBooks;
    data['books_per_page'] = this.booksPerPage;
    data['has_next'] = this.hasNext;
    data['has_prev'] = this.hasPrev;
    return data;
  }
}
