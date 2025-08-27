// my_library_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mains/model/my_workBook_List.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../common/shred_pref.dart';
import '../../model/book_model.dart';
import '../../common/api_urls.dart';
import '../logIn_flow/logIn_page_screen/User_Login_option.dart';
import '../../common/api_services.dart';

class MyLibraryController extends GetxController {
  final searchController = TextEditingController();
  final isBooksLoaded = false.obs;
  final userName = ''.obs;
  final books = <Book>[].obs;
  final MyWorkBookLists = <Workbooks>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;
  late SharedPreferences prefs;
  String? authToken;

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString(Constants.authToken);
    userName.value = "My Books";
    getworkbooks();
  }

  Future<void> loadBooks() async {
    // if (!force && isBooksLoaded.value) return;

    isLoading.value = true;
    error.value = '';
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');

    final url = Uri.parse(ApiUrls.getMyFavBooks);
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    await callWebApiGet(
      null,
      ApiUrls.getMyFavBooks,
      onResponse: (response) {
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          if (jsonData['success'] == true && jsonData['data'] != null) {
            final List<dynamic> booksData = jsonData['data']['books'] ?? [];
            books.value =
                booksData.map((bookJson) => Book.fromJson(bookJson)).toList();
            isBooksLoaded.value = true;
          } else {
            error.value = jsonData['message'] ?? 'Failed to load books';
          }
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          SharedPreferences.getInstance().then((prefs) async {
            await prefs.clear();
            Get.offAll(() => User_Login_option());
          });
        } else {
          error.value = 'Failed to load books: \\${response.statusCode}';
        }
        isLoading.value = false;
      },
      onError: () {
        error.value = 'Error loading books';
        isLoading.value = false;
      },
      token: authToken ?? '',
      showLoader: false,
      hideLoader: false,
    );
  }

  Future<void> deleteBook(String bookId) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');

    final url = Uri.parse(ApiUrls.removeMyFavBooks);

    await callWebApi(
      null,
      ApiUrls.removeMyFavBooks,
      {"book_id": bookId},
      onResponse: (response) {
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          if (jsonData['success'] == true) {
            books.removeWhere((book) => book.bookId == bookId);
          } else {
            throw Exception();
          }
        } else {
          throw Exception();
        }
      },
      onError: () {
        throw Exception('Error deleting book');
      },
      token: authToken ?? '',
      showLoader: false,
      hideLoader: false,
    );
  }

  void onSearchChanged(String value) {
    if (value.isEmpty) {
      loadBooks();
      return;
    }

    final searchLower = value.toLowerCase();
    final filteredBooks =
        books
            .where(
              (book) =>
                  book.title?.toLowerCase().contains(searchLower) == true ||
                  book.author?.toLowerCase().contains(searchLower) == true ||
                  book.subject?.toLowerCase().contains(searchLower) == true ||
                  book.paper?.toLowerCase().contains(searchLower) == true ||
                  book.exam?.toLowerCase().contains(searchLower) == true,
            )
            .toList();

    books.value = filteredBooks;
  }

  void onNotificationTap() {
    Get.toNamed('/notifications');
  }

  void onBookTap(Book book) {
    Get.toNamed('/book-details', arguments: book);
  }

  void clearData() {
    books.clear();
    isBooksLoaded.value = false;
    error.value = '';
    // Optionally reset other state if needed
  }

  Future<void> getworkbooks() async {
    print("🚀 Starting getworkbooks()");

    isLoading.value = true;
    error.value = '';

    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');
    print("🔑 Retrieved Auth Token: $authToken");

    await callWebApiGet(
      null,
      ApiUrls.getMyWorkBookLibrary,
      onResponse: (response) {
        print("📥 Response Status: ${response.statusCode}");
        print("📦 Raw Body: ${response.body}");

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          print("🧩 Decoded JSON: $jsonData");

          if (jsonData['success'] == true && jsonData['data'] != null) {
            final myWorkBookList = MyWorkBookList.fromJson(jsonData);
            final workbooks =
                myWorkBookList.data ?? []; // ✅ Updated: no `.workbooks`

            print("✅ Total Workbooks Fetched: ${workbooks.length}");
            for (var book in workbooks) {
              print(
                "📚 Title: ${book.title}, ID: ${book.workbookId}, Author: ${book.author}",
              );
            }

            MyWorkBookLists.value = workbooks;
            isBooksLoaded.value = true;
          } else {
            error.value = jsonData['message'] ?? 'Failed to load books';
          }
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          print("🔒 Unauthorized. Token may be expired. Logging out...");
          SharedPreferences.getInstance().then((prefs) async {
            await prefs.clear();
            Get.offAll(() => User_Login_option());
          });
        } else {
          error.value = 'Failed to load books: ${response.statusCode}';
        }

        isLoading.value = false;
      },
      onError: () {
        error.value = 'Error loading books';
        isLoading.value = false;
      },
      token: authToken ?? '',
      showLoader: false,
      hideLoader: false,
    );
  }

  Future<void> deletWorkeBook(String bookId) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');

    final url = ApiUrls.dleteMyWorkBookLibrary; // Use the correct URL

    print("🗑️ Starting delete for workbookId: $bookId");

    await callWebApi(
      null,
      url, // use `url` here
      {"workbook_id": bookId},
      onResponse: (response) {
        print("📥 Response Status: ${response.statusCode}");
        print("📦 Response Body: ${response.body}");

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          if (jsonData['success'] == true) {
            print("✅ Workbook deleted successfully.");
            MyWorkBookLists.removeWhere((book) => book.workbookId == bookId);
          } else {
            print("❌ Deletion failed: ${jsonData['message']}");
            throw Exception("Failed to delete workbook.");
          }
        } else {
          print("❌ Server error: ${response.statusCode}");
          throw Exception("Server returned error.");
        }
      },
      onError: () {
        print("❌ Network or parsing error occurred.");
        throw Exception('Error deleting book');
      },
      token: authToken ?? '',
      showLoader: false,
      hideLoader: false,
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

class MyLibraryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MyLibraryController());
  }
}
