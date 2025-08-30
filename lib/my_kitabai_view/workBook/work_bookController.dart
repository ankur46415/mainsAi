import 'package:http/http.dart' as http;
import 'package:mains/app_imports.dart';
import 'package:mains/model/home_page_adds.dart' as adds_model;
import 'package:mains/model/reel_App.dart' as reel;

class WorkBookcontroller extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController animationController;
  late Rx<Animation<double>> animation;
  RxBool isExpanded = false.obs;
  late SharedPreferences prefs;
  String? authToken;
  RxList<WorkBookHighlighted> highlightedBooks = <WorkBookHighlighted>[].obs;
  RxList<WorkBookTrending> trendingBooks = <WorkBookTrending>[].obs;
  RxMap<String, List<adds_model.Data>> adsByLocation =
      <String, List<adds_model.Data>>{}.obs;

  var reels = <reel.Data>[].obs;

  var isLoading = true.obs;
  var workbooks = <Workbooks>[].obs;
  var homePageAdds = adds_model.HomePageAdds().obs;
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
    fetchHomePageAdds();
    fetchPopularReels();
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

  Future<void> fetchPopularReels() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');

      await callWebApiGet(
        null,
        ApiUrls.reelsPopular,
        token: authToken ?? '',
        onResponse: (response) {
          if (response.statusCode == 200) {
            final decodedJson = json.decode(response.body);
            final reelResponse = reel.ReelForApp.fromJson(decodedJson);

            reels.value = reelResponse.data ?? [];
          } else {}
          isLoading.value = false;
        },
        onError: () {
          isLoading.value = false;
        },
        showLoader: false,
        hideLoader: false,
      );
    } catch (e, stack) {
      isLoading.value = false;
    }
  }

  Future<void> fetchHomePageAdds() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');
    print("🔑 Auth Token: $authToken");

    try {
      isLoading.value = true;

      final url = ApiUrls.marketing;

      await callWebApiGet(
        null,
        url,
        token: authToken ?? "",
        onResponse: (response) {
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            homePageAdds.value = adds_model.HomePageAdds.fromJson(data);

            _buildAdsByLocation();
          } else {}
        },
        onError: (error) {},
      );
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
