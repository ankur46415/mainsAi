// my_library_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mains/models/my_workBook_List.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../common/shred_pref.dart';
import '../../models/book_model.dart';
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
  // Track which descriptions are expanded (keys: workbookId/myWorkbookId/title-index)
  final expandedDescKeys = <String>{}.obs;

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

    // Note: headers/url prepared by API helper

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

    // final url = Uri.parse(ApiUrls.removeMyFavBooks);

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
  }

  Future<void> getworkbooks() async {

    isLoading.value = true;
    error.value = '';

    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');

    await callWebApiGet(
      null,
      ApiUrls.getMyWorkBookLibrary,
      onResponse: (response) {
     

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);

          if (jsonData['success'] == true && jsonData['data'] != null) {
            final myWorkBookList = MyWorkBookList.fromJson(jsonData);
            final workbooks =
                myWorkBookList.data ?? [];

            // Workbooks parsed; can be used for any preprocessing if needed

            MyWorkBookLists.value = workbooks;
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

    final url = ApiUrls.dleteMyWorkBookLibrary;
    await callWebApi(
      null,
      url, 
      {"workbook_id": bookId},
      onResponse: (response) {
     
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          if (jsonData['success'] == true) {
            MyWorkBookLists.removeWhere((book) => book.workbookId == bookId);
          } else {
            throw Exception("Failed to delete workbook.");
          }
        } else {
          throw Exception("Server returned error.");
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

  // UI helpers for description expand/collapse
  bool isDescExpanded(String key) => expandedDescKeys.contains(key);
  void toggleDescExpanded(String key) {
    if (expandedDescKeys.contains(key)) {
      expandedDescKeys.remove(key);
    } else {
      expandedDescKeys.add(key);
    }
    expandedDescKeys.refresh();
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
