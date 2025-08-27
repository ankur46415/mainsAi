class Book {
  final String? id;
  final String? mybookId;
  final String? bookId;
  final String? title;
  final String? author;
  final String? publisher;
  final String? description;
  final String? coverImage;
  final String? coverImageUrl;
  final dynamic rating;
  final dynamic ratingCount;
  final String? conversations;
  final String? users;
  final String? summary;
  final String? mainCategory;
  final String? subCategory;
  final String? exam;
  final String? paper;
  final String? subject;
  final List<String>? tags;
  final dynamic viewCount;
  final String? addedAt;
  final String? lastAccessedAt;
  final String? personalNote;
  final dynamic priority;
  final bool? isPublic;
  final String? createdAt;
  final String? updatedAt;
  final bool? isOwnBook;

  Book({
    this.id,
    this.mybookId,
    this.bookId,
    this.title,
    this.author,
    this.publisher,
    this.description,
    this.coverImage,
    this.coverImageUrl,
    this.rating,
    this.ratingCount,
    this.conversations,
    this.users,
    this.summary,
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
    this.priority,
    this.isPublic,
    this.createdAt,
    this.updatedAt,
    this.isOwnBook,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id']?.toString(),
      mybookId: json['mybook_id']?.toString(),
      bookId: json['book_id']?.toString(),
      title: json['title']?.toString(),
      author: json['author']?.toString(),
      publisher: json['publisher']?.toString(),
      description: json['description']?.toString(),
      coverImage: json['cover_image']?.toString(),
      coverImageUrl: json['cover_image_url']?.toString(),
      rating: json['rating'],
      ratingCount: json['rating_count'],
      conversations: json['conversations']?.toString(),
      users: json['users']?.toString(),
      summary: json['summary']?.toString(),
      mainCategory: json['main_category']?.toString(),
      subCategory: json['sub_category']?.toString(),
      exam: json['exam']?.toString(),
      paper: json['paper']?.toString(),
      subject: json['subject']?.toString(),
      tags: json['tags']?.cast<String>(),
      viewCount: json['view_count'],
      addedAt: json['added_at']?.toString(),
      lastAccessedAt: json['last_accessed_at']?.toString(),
      personalNote: json['personal_note']?.toString(),
      priority: json['priority'],
      isPublic: json['is_public'],
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      isOwnBook: json['is_own_book'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mybook_id': mybookId,
      'book_id': bookId,
      'title': title,
      'author': author,
      'publisher': publisher,
      'description': description,
      'cover_image': coverImage,
      'cover_image_url': coverImageUrl,
      'rating': rating,
      'rating_count': ratingCount,
      'conversations': conversations,
      'users': users,
      'summary': summary,
      'main_category': mainCategory,
      'sub_category': subCategory,
      'exam': exam,
      'paper': paper,
      'subject': subject,
      'tags': tags,
      'view_count': viewCount,
      'added_at': addedAt,
      'last_accessed_at': lastAccessedAt,
      'personal_note': personalNote,
      'priority': priority,
      'is_public': isPublic,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_own_book': isOwnBook,
    };
  }
}

class BookListResponse {
  final bool success;
  final String? message;
  final int? responseCode;
  final BookListData? data;

  BookListResponse({
    required this.success,
    this.message,
    this.responseCode,
    this.data,
  });

  factory BookListResponse.fromJson(Map<String, dynamic> json) {
    return BookListResponse(
      success: json['success'] ?? false,
      message: json['message'],
      responseCode: json['responseCode'],
      data: json['data'] != null ? BookListData.fromJson(json['data']) : null,
    );
  }
}

class BookListData {
  final List<Book> books;
  final Pagination? pagination;

  BookListData({
    required this.books,
    this.pagination,
  });

  factory BookListData.fromJson(Map<String, dynamic> json) {
    return BookListData(
      books: (json['books'] as List?)?.map((v) => Book.fromJson(v)).toList() ?? [],
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
    );
  }
}

class Pagination {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasNext;
  final bool hasPrev;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.hasNext,
    required this.hasPrev,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'] ?? json['currentPage'] ?? 1,
      totalPages: json['total_pages'] ?? json['totalPages'] ?? 1,
      totalItems: json['total_books'] ?? json['totalBooks'] ?? json['totalAnswers'] ?? 0,
      hasNext: json['has_next'] ?? json['hasNext'] ?? json['hasNextPage'] ?? false,
      hasPrev: json['has_prev'] ?? json['hasPrev'] ?? json['hasPrevPage'] ?? false,
    );
  }
}

// Add a class to handle pagination data
class PaginationData {
  final int currentPage;
  final int totalPages;
  final int totalBooks;
  final int booksPerPage;
  final bool hasNext;
  final bool hasPrev;

  PaginationData({
    required this.currentPage,
    required this.totalPages,
    required this.totalBooks,
    required this.booksPerPage,
    required this.hasNext,
    required this.hasPrev,
  });

  factory PaginationData.fromJson(Map<String, dynamic> json) {
    return PaginationData(
      currentPage: json['current_page'] ?? 1,
      totalPages: json['total_pages'] ?? 1,
      totalBooks: json['total_books'] ?? 0,
      booksPerPage: json['books_per_page'] ?? 20,
      hasNext: json['has_next'] ?? false,
      hasPrev: json['has_prev'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'total_pages': totalPages,
      'total_books': totalBooks,
      'books_per_page': booksPerPage,
      'has_next': hasNext,
      'has_prev': hasPrev,
    };
  }
}

// Add a class to handle the complete API response
class BooksResponse {
  final bool success;
  final String message;
  final List<Book> books;
  final PaginationData pagination;

  BooksResponse({
    required this.success,
    required this.message,
    required this.books,
    required this.pagination,
  });

  factory BooksResponse.fromJson(Map<String, dynamic> json) {
    return BooksResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      books: (json['data']['books'] as List?)
          ?.map((book) => Book.fromJson(book))
          .toList() ?? [],
      pagination: PaginationData.fromJson(json['data']['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': {
        'books': books.map((book) => book.toJson()).toList(),
        'pagination': pagination.toJson(),
      },
    };
  }
} 