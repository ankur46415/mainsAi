class DashBoardData {
  bool? success;
  Data? data;
  Meta? meta;

  DashBoardData({this.success, this.data, this.meta});

  DashBoardData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) data['data'] = this.data!.toJson();
    if (meta != null) data['meta'] = meta!.toJson();
    return data;
  }
}

class Data {
  List<Highlighted>? highlighted;
  List<Trending>? trending;
  List<Recent>? recent;
  List<Categories>? categories;
  int? totalBooks;

  Data({
    this.highlighted,
    this.trending,
    this.recent,
    this.categories,
    this.totalBooks,
  });

  Data.fromJson(Map<String, dynamic> json) {
    if (json['highlighted'] != null) {
      highlighted =
          (json['highlighted'] as List)
              .map((v) => Highlighted.fromJson(v))
              .toList();
    }
    if (json['trending'] != null) {
      trending =
          (json['trending'] as List).map((v) => Trending.fromJson(v)).toList();
    }
    if (json['recent'] != null) {
      recent = (json['recent'] as List).map((v) => Recent.fromJson(v)).toList();
    }
    if (json['categories'] != null) {
      categories =
          (json['categories'] as List)
              .map((v) => Categories.fromJson(v))
              .toList();
    }
    totalBooks = json['totalBooks'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (highlighted != null) {
      data['highlighted'] = highlighted!.map((v) => v.toJson()).toList();
    }
    if (trending != null) {
      data['trending'] = trending!.map((v) => v.toJson()).toList();
    }
    if (recent != null) {
      data['recent'] = recent!.map((v) => v.toJson()).toList();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    data['totalBooks'] = totalBooks;
    return data;
  }
}

class Highlighted {
  String? bookId;
  String? title;
  String? category;
  String? subCategory;
  String? image;
  String? image_url;
  bool? highlight;
  bool? trending;
  String? author;
  String? publisher;
  String? description;
  num? rating;
  int? viewCount;
  String? examName;
  String? paperName;
  String? subjectName;

  Highlighted({
    this.bookId,
    this.title,
    this.category,
    this.subCategory,
    this.image,
    this.image_url,
    this.highlight,
    this.trending,
    this.author,
    this.publisher,
    this.description,
    this.rating,
    this.viewCount,
    this.examName,
    this.paperName,
    this.subjectName,
  });

  Highlighted.fromJson(Map<String, dynamic> json) {
    bookId = json['book_id'];
    title = json['title'];
    category = json['category'];
    subCategory = json['sub_category'];
    image = json['image'];
    image_url = json['image_url'];
    highlight = json['highlight'];
    trending = json['trending'];
    author = json['author'];
    publisher = json['publisher'];
    description = json['description'];
    rating = json['rating'];
    viewCount = json['viewCount'];
    examName = json['exam_name'];
    paperName = json['paper_name'];
    subjectName = json['subject_name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['book_id'] = bookId;
    data['title'] = title;
    data['category'] = category;
    data['sub_category'] = subCategory;
    data['image'] = image;
    data['image_url'] = image_url;
    data['highlight'] = highlight;
    data['trending'] = trending;
    data['author'] = author;
    data['publisher'] = publisher;
    data['description'] = description;
    data['rating'] = rating;
    data['viewCount'] = viewCount;
    data['exam_name'] = examName;
    data['paper_name'] = paperName;
    data['subject_name'] = subjectName;
    return data;
  }
}

class Trending {
  String? bookId;
  String? title;
  String? category;
  String? subCategory;
  String? image;
  String? image_url;
  bool? highlight;
  bool? trending;
  String? author;
  String? publisher;
  String? description;
  num? rating;
  int? viewCount;
  String? examName;
  String? paperName;
  String? subjectName;

  Trending({
    this.bookId,
    this.title,
    this.category,
    this.subCategory,
    this.image,
    this.image_url,
    this.highlight,
    this.trending,
    this.author,
    this.publisher,
    this.description,
    this.rating,
    this.viewCount,
    this.examName,
    this.paperName,
    this.subjectName,
  });

  Trending.fromJson(Map<String, dynamic> json) {
    bookId = json['book_id'];
    title = json['title'];
    category = json['category'];
    subCategory = json['sub_category'];
    image = json['image'];
    image_url = json['image_url'];
    highlight = json['highlight'];
    trending = json['trending'];
    author = json['author'];
    publisher = json['publisher'];
    description = json['description'];
    rating = json['rating'];
    viewCount = json['viewCount'];
    examName = json['exam_name'];
    paperName = json['paper_name'];
    subjectName = json['subject_name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['book_id'] = bookId;
    data['title'] = title;
    data['category'] = category;
    data['sub_category'] = subCategory;
    data['image'] = image;
    data['image_url'] = image_url;
    data['highlight'] = highlight;
    data['trending'] = trending;
    data['author'] = author;
    data['publisher'] = publisher;
    data['description'] = description;
    data['rating'] = rating;
    data['viewCount'] = viewCount;
    data['exam_name'] = examName;
    data['paper_name'] = paperName;
    data['subject_name'] = subjectName;
    return data;
  }
}

class Recent {
  String? bookId;
  String? title;
  String? category;
  String? subCategory;
  String? image;
  bool? highlight;
  bool? trending;
  String? author;
  String? publisher;
  String? description;
  num? rating;
  int? viewCount;
  String? examName;
  String? paperName;
  String? subjectName;

  Recent({
    this.bookId,
    this.title,
    this.category,
    this.subCategory,
    this.image,
    this.highlight,
    this.trending,
    this.author,
    this.publisher,
    this.description,
    this.rating,
    this.viewCount,
    this.examName,
    this.paperName,
    this.subjectName,
  });

  Recent.fromJson(Map<String, dynamic> json) {
    bookId = json['book_id'];
    title = json['title'];
    category = json['category'];
    subCategory = json['sub_category'];
    image = json['image'];
    highlight = json['highlight'];
    trending = json['trending'];
    author = json['author'];
    publisher = json['publisher'];
    description = json['description'];
    rating =
        (json['rating'] is int)
            ? (json['rating'] as int).toDouble()
            : json['rating'];
    viewCount = json['viewCount'];
    examName = json['exam_name'];
    paperName = json['paper_name'];
    subjectName = json['subject_name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['book_id'] = bookId;
    data['title'] = title;
    data['category'] = category;
    data['sub_category'] = subCategory;
    data['image'] = image;
    data['highlight'] = highlight;
    data['trending'] = trending;
    data['author'] = author;
    data['publisher'] = publisher;
    data['description'] = description;
    data['rating'] = rating;
    data['viewCount'] = viewCount;
    data['exam_name'] = examName;
    data['paper_name'] = paperName;
    data['subject_name'] = subjectName;
    return data;
  }
}

class Categories {
  String? category;
  List<SubCategories>? subCategories;
  int? totalBooks;

  Categories({this.category, this.subCategories, this.totalBooks});

  Categories.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    if (json['sub_categories'] != null) {
      subCategories =
          (json['sub_categories'] as List)
              .map((v) => SubCategories.fromJson(v))
              .toList();
    }
    totalBooks = json['total_books'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['category'] = category;
    if (subCategories != null) {
      data['sub_categories'] = subCategories!.map((v) => v.toJson()).toList();
    }
    data['total_books'] = totalBooks;
    return data;
  }
}

class SubCategories {
  String? name;
  int? count;
  List<Book>? books;

  SubCategories({this.name, this.count, this.books});

  SubCategories.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    count = json['count'];
    if (json['books'] != null) {
      books = <Book>[];
      json['books'].forEach((v) {
        books!.add(Book.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['count'] = count;
    if (books != null) {
      data['books'] = books!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Book {
  String? bookId;
  String? title;
  String? category;
  String? subCategory;
  String? image;
  String? image_url;
  bool? highlight;
  bool? trending;
  String? author;
  String? publisher;
  String? description;

  int? viewCount;
  String? examName;
  String? paperName;
  String? subjectName;

  Book({
    this.bookId,
    this.title,
    this.category,
    this.subCategory,
    this.image,
    this.image_url,
    this.highlight,
    this.trending,
    this.author,
    this.publisher,
    this.description,

    this.viewCount,
    this.examName,
    this.paperName,
    this.subjectName,
  });

  Book.fromJson(Map<String, dynamic> json) {
    bookId = json['book_id'];
    title = json['title'];
    category = json['category'];
    subCategory = json['sub_category'];
    image = json['image'];
    image_url = json['image_url'];
    highlight = json['highlight'];
    trending = json['trending'];
    author = json['author'];
    publisher = json['publisher'];
    description = json['description'];

    viewCount = json['viewCount'];
    examName = json['exam_name'];
    paperName = json['paper_name'];
    subjectName = json['subject_name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['book_id'] = bookId;
    data['title'] = title;
    data['category'] = category;
    data['sub_category'] = subCategory;
    data['image'] = image;
    data['image_url'] = image_url;
    data['highlight'] = highlight;
    data['trending'] = trending;
    data['author'] = author;
    data['publisher'] = publisher;
    data['description'] = description;

    data['viewCount'] = viewCount;
    data['exam_name'] = examName;
    data['paper_name'] = paperName;
    data['subject_name'] = subjectName;
    return data;
  }
}

class Meta {
  String? clientId;
  String? timestamp;
  FiltersApplied? filtersApplied;

  Meta({this.clientId, this.timestamp, this.filtersApplied});

  Meta.fromJson(Map<String, dynamic> json) {
    clientId = json['clientId'];
    timestamp = json['timestamp'];
    filtersApplied =
        json['filters_applied'] != null
            ? FiltersApplied.fromJson(json['filters_applied'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['clientId'] = clientId;
    data['timestamp'] = timestamp;
    if (filtersApplied != null) {
      data['filters_applied'] = filtersApplied!.toJson();
    }
    return data;
  }
}

class FiltersApplied {
  FiltersApplied();

  FiltersApplied.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() => {};
}
