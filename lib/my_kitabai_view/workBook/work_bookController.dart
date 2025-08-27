import 'package:mains/app_imports.dart';

class WorkBookcontroller extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController animationController;
  late Rx<Animation<double>> animation;
  RxBool isExpanded = false.obs;
  late SharedPreferences prefs;
  String? authToken;
  RxList<WorkBookHighlighted> highlightedBooks = <WorkBookHighlighted>[].obs;
  RxList<WorkBookTrending> trendingBooks = <WorkBookTrending>[].obs;
  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString(Constants.authToken);
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    animation =
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ).obs;
    fetchWorkbookData();
  }

  var expandedCategories = <String, String>{}.obs;

  void updateSelection(String category, String subCategory) {
    expandedCategories[category] = subCategory;
  }

  void toggleExpansion() {
    isExpanded.value = !isExpanded.value;
    if (isExpanded.value) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }

  Animation<double> getStaggeredAnimation(int index) {
    final delay = index * 100;
    return CurvedAnimation(
      parent: animationController,
      curve: Interval(
        delay / animationController.duration!.inMilliseconds,
        1.0,
        curve: Curves.easeOut,
      ),
    );
  }

  var isLoading = true.obs;
  var workbooks = <Workbooks>[].obs;

  Future<void> fetchWorkbookData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');
      await callWebApiGet(
        null,
        ApiUrls.workBookData,
        token: authToken ?? '',
        onResponse: (response) {
          if (response.statusCode == 200) {
            final decodedJson = json.decode(response.body);
            final data = WorkBookResponse.fromJson(decodedJson);
            workbooks.value = data.workbooks ?? [];
            // Parse Highlighted
            if (decodedJson['highlighted'] != null) {
              highlightedBooks.value = List<WorkBookHighlighted>.from(
                decodedJson['highlighted'].map(
                  (e) => WorkBookHighlighted.fromJson(e),
                ),
              );
            }

            // Parse Trending
            if (decodedJson['trending'] != null) {
              trendingBooks.value = List<WorkBookTrending>.from(
                decodedJson['trending'].map(
                  (e) => WorkBookTrending.fromJson(e),
                ),
              );
            }
          } else {
            Get.snackbar('Error', 'Failed to load data');
          }
          isLoading.value = false;
        },
        onError: () {
          Get.snackbar('Error', 'Something went wrong');
          isLoading.value = false;
        },
        showLoader: false,
        hideLoader: false,
      );
    } catch (e, stack) {
      Get.snackbar('Error', 'Something went wrong');
      isLoading.value = false;
      print(e);
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}

class WorkBookBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(WorkBookcontroller());
  }
}
