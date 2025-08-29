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

  var reels = <reel.Data>[].obs;

  var isLoading = true.obs;
  var workbooks = <Workbooks>[].obs;
  var homePageAdds = adds_model.HomePageAdds().obs;

  Future<void> fetchPopularReels() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');

      await callWebApiGet(
        null, // tickerProvider (not needed here)
        ApiUrls.reelsPopular,
        token: authToken ?? '',
        onResponse: (response) {
          if (response.statusCode == 200) {
            final decodedJson = json.decode(response.body);

            // Parse API response into model
            final reelResponse = reel.ReelForApp.fromJson(decodedJson);

            reels.value = reelResponse.data ?? [];
            print("✅ Reels fetched: ${reels.length}");
          } else {
            Get.snackbar("Error", "Failed to load reels");
            print("❌ Failed: ${response.statusCode} ${response.body}");
          }
          isLoading.value = false;
        },
        onError: () {
          Get.snackbar("Error", "Something went wrong");
          isLoading.value = false;
        },
        showLoader: false,
        hideLoader: false,
      );
    } catch (e, stack) {
      Get.snackbar("Error", "Something went wrong");
      isLoading.value = false;
      print("❌ Exception: $e");
      print("📌 Stacktrace: $stack");
    }
  }

  Future<void> fetchHomePageAdds() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken'); // stored token
    print("🔑 Auth Token: $authToken");

    try {
      isLoading.value = true;
      print("📡 Fetching HomePageAdds...");

      final url = ApiUrls.marketing; // 👈 central API URL
      print("🌍 Request URL: $url");

      await callWebApiGet(
        null, // tickerProvider agar use nahi karna hai to null de do
        url,
        token: authToken ?? "",
        onResponse: (response) {
          print("📨 Response Status for add: ${response.statusCode}");
          print("📨 Response Body: ${response.body}");

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            homePageAdds.value = adds_model.HomePageAdds.fromJson(data);
            print(
              "✅ Data parsed successfully. Found: ${homePageAdds.value.data?.length ?? 0} ads",
            );
            _buildAdsByLocation();
          } else {
            Get.snackbar(
              "Error",
              "Failed to load data: ${response.statusCode}",
            );
            print("❌ Failed with status code ${response.statusCode}");
          }
        },
        onError: (error) {
          Get.snackbar("Error", "Something went wrong: $error");
          print("🔥 Exception caught: $error");
        },
      );
    } finally {
      isLoading.value = false;
      print("⏹️ Fetch finished");
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
