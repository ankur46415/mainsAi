import '../../app_imports.dart';
import 'package:http/http.dart' as http;
import 'package:mains/models/home_page_adds.dart' as adds_model;

class HomeScreenController extends GetxController {
  late SharedPreferences prefs;
  String? authToken;
  RxString searchQuery = ''.obs;
  RxList<Book> filteredBooks = <Book>[].obs;
  RxList<Highlighted> highlightedBooks = <Highlighted>[].obs;
  RxList<Trending> trendingBooks = <Trending>[].obs;
  RxList<Recent> recentBooks = <Recent>[].obs;
  RxList<Categories> categories = <Categories>[].obs;
  RxInt totalBooks = 0.obs;
  RxBool isLoading = false.obs;
  RxBool hasLoaded = false.obs;
  RxString selectedCategory = 'All'.obs;
  RxString selectedSubCategory = ''.obs;
  RxMap<String, List<adds_model.Data>> adsByLocation =
      <String, List<adds_model.Data>>{}.obs;
  RxMap<String, String> expandedCategories = <String, String>{}.obs;
  bool forceRefresh = false;
  bool _isDashboardLoaded = false;
  RxList<Reels> reels = <Reels>[].obs;

  RxMap<String, int> currentPage = <String, int>{}.obs;
  RxMap<String, bool> hasMore = <String, bool>{}.obs;
  var homePageAdds = adds_model.HomePageAdds().obs;
  @override
  void onInit() async {
    super.onInit();
    try {
      await _initializePreferences();
      if (!_isDashboardLoaded) {
        isLoading.value = true;
        Future.microtask(() async {
          await dashBoardData();
          initializeFirstSubcategories();
        });
      }
    } catch (e) {}
  }

  Future<void> _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString(Constants.authToken);
    if (authToken == null) {
      isLoading.value = false;
    }
  }

  Future<void> fetchHomePageAdds() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');

    try {
      isLoading.value = true;

      final url = ApiUrls.marketing;
      await callWebApiGet(
        null,
        url,
        token: authToken ?? '',
        showLoader: false,
        hideLoader: true,
        onResponse: (response) {
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            homePageAdds.value = adds_model.HomePageAdds.fromJson(data);
            _buildAdsByLocation();
          }
        },
        onError: () {},
      );
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  void _buildAdsByLocation() {
    adsByLocation.clear();
    final list = homePageAdds.value.data ?? [];
    for (final ad in list) {
      final key = (ad.location ?? 'default').toLowerCase();
      final existing = adsByLocation[key] ?? <adds_model.Data>[];
      existing.add(ad);
      adsByLocation[key] = existing;
    }
    adsByLocation.refresh();
  }

  Future<void> dashBoardData({bool forceRefresh = false}) async {
    if (_isDashboardLoaded && !forceRefresh) return;

    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');
    if (authToken == null) return;

    const String url = ApiUrls.getDashboard;

    try {
      isLoading.value = true;

      await callWebApiGet(
        null,
        '$url?page=1',
        onResponse: (response) async {
          if (response.statusCode == 200) {
            final Map<String, dynamic> jsonMap = json.decode(response.body);
            _isDashboardLoaded = true;
            highlightedBooks.clear();
            trendingBooks.clear();
            recentBooks.clear();
            categories.clear();
            reels.clear();

            final data = jsonMap['data'];
            if (data != null) {
              if (data['highlighted'] is List) {
                highlightedBooks.addAll(
                  (data['highlighted'] as List)
                      .map((item) => Highlighted.fromJson(item))
                      .toList(),
                );
              }
              if (data['trending'] is List) {
                trendingBooks.addAll(
                  (data['trending'] as List)
                      .map((item) => Trending.fromJson(item))
                      .toList(),
                );
              }
              if (data['recent'] is List) {
                recentBooks.addAll(
                  (data['recent'] as List)
                      .map((item) => Recent.fromJson(item))
                      .toList(),
                );
              }
              if (data['categories'] is List) {
                categories.addAll(
                  (data['categories'] as List)
                      .map((item) => Categories.fromJson(item))
                      .toList(),
                );
              }
              if (data['reels'] is List) {
                reels.addAll(
                  (data['reels'] as List)
                      .map((item) => Reels.fromJson(item))
                      .toList(),
                );
              }
              totalBooks.value = data['totalBooks'] ?? 0;

              for (var category in categories) {
                for (var subCategory in category.subCategories ?? []) {
                  final key = '${category.category}_${subCategory.name}';
                  currentPage[key] = 1;
                  hasMore[key] = true;
                }
              }
            }
            hasLoaded.value = true;
          } else if (response.statusCode == 401) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.clear();

            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.offAll(() => User_Login_option());
            });

            return;
          } else {
            return;
          }
        },
        onError: () {},
        token: authToken,
        showLoader: false,
        hideLoader: false,
      );
    } catch (e) {
      isLoading.value = false;
    } finally {
      isLoading.value = false;
      initializeFirstSubcategories();
    }
  }

  Future<void> loadMoreBooks(String category, String subCategory) async {
    final key = '${category}_$subCategory';
    if ((hasMore[key] == false) || isLoading.value) return;

    isLoading.value = true;
    final nextPage = (currentPage[key] ?? 1) + 1;

    try {
      await callWebApiGet(
        null,
        '${ApiUrls.getDashboard}?page=$nextPage',
        token: authToken ?? '',
        showLoader: false,
        hideLoader: false,
        onResponse: (response) {
          if (response.statusCode == 200) {
            final Map<String, dynamic> jsonMap = json.decode(response.body);
            final data = jsonMap['data'];
            if (data != null && data['categories'] is List) {
              final newCategories =
                  (data['categories'] as List)
                      .map((item) => Categories.fromJson(item))
                      .toList();

              final categoryObj = newCategories.firstWhereOrNull(
                (cat) => cat.category == category,
              );
              final subCategoryObj = categoryObj?.subCategories
                  ?.firstWhereOrNull((subCat) => subCat.name == subCategory);

              if (subCategoryObj?.books != null &&
                  subCategoryObj!.books!.isNotEmpty) {
                final existingCategory = categories.firstWhereOrNull(
                  (cat) => cat.category == category,
                );
                final existingSubCategory = existingCategory?.subCategories
                    ?.firstWhereOrNull((subCat) => subCat.name == subCategory);

                if (existingSubCategory != null) {
                  existingSubCategory.books = [
                    ...(existingSubCategory.books ?? []),
                    ...subCategoryObj.books!,
                  ];
                  categories.refresh();
                  currentPage[key] = nextPage;
                  hasMore[key] = subCategoryObj.books!.length >= 5;
                }
              } else {
                hasMore[key] = false;
              }
            }
          } else {
            hasMore[key] = false;
          }
        },
        onError: () {
          hasMore[key] = false;
        },
      );
    } catch (e) {
      hasMore[key] = false;
    } finally {
      isLoading.value = false;
    }
  }

  List<Book>? getBooksForSubCategory(String category, String subCategory) {
    final categoryObj = categories.firstWhereOrNull(
      (cat) => cat.category == category,
    );

    if (categoryObj == null) return null;

    final subCategoryObj = categoryObj.subCategories?.firstWhereOrNull(
      (subCat) => subCat.name == subCategory,
    );

    return subCategoryObj?.books;
  }

  List<Book> getAllBooksForCategory(String category) {
    final categoryObj = categories.firstWhereOrNull(
      (cat) => cat.category == category,
    );

    if (categoryObj == null) return [];

    List<Book> allBooks = [];
    for (var subCat in categoryObj.subCategories ?? []) {
      if (subCat.books != null) {
        allBooks.addAll(subCat.books!);
      }
    }
    return allBooks;
  }

  List<SubCategories> getSubCategories(String category) {
    final categoryObj = categories.firstWhereOrNull(
      (cat) => cat.category == category,
    );
    return categoryObj?.subCategories ?? [];
  }

  void initializeFirstSubcategories() {
    expandedCategories.clear();

    for (var category in categories) {
      if (category.category != null &&
          category.subCategories != null &&
          category.subCategories!.isNotEmpty &&
          category.subCategories!.first.name != null) {
        expandedCategories[category.category!] =
            category.subCategories!.first.name!;
      }
    }

    if (categories.isNotEmpty && categories.first.category != null) {
      selectedCategory.value = categories.first.category!;
      if (categories.first.subCategories != null &&
          categories.first.subCategories!.isNotEmpty &&
          categories.first.subCategories!.first.name != null) {
        selectedSubCategory.value = categories.first.subCategories!.first.name!;
      }
    }

    expandedCategories.refresh();
  }

  void updateSelection(String category, String subCategory) {
    if (selectedCategory.value == category &&
        selectedSubCategory.value == subCategory) {
      selectedSubCategory.value = '';
      expandedCategories.remove(category);
    } else {
      selectedCategory.value = category;
      selectedSubCategory.value = subCategory;
      expandedCategories[category] = subCategory;
    }
    expandedCategories.refresh();
  }

  void updateFilteredBooks(String category) {
    final books = getAllBooksForCategory(category);
    if (searchQuery.value.isEmpty) {
      filteredBooks.value = books;
    } else {
      filteredBooks.value =
          books.where((book) {
            final paperName = book.paperName?.toLowerCase() ?? '';
            final subjectName = book.subjectName?.toLowerCase() ?? '';
            final examName = book.examName?.toLowerCase() ?? '';
            final searchLower = searchQuery.value.toLowerCase();
            return paperName.contains(searchLower) ||
                subjectName.contains(searchLower) ||
                examName.contains(searchLower);
          }).toList();
    }
  }
}

class HomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeScreenController());
  }
}
