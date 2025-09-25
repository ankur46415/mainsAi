import 'package:mains/app_imports.dart';
import 'package:mains/models/workBookBookDetailes.dart';
import 'package:mains/my_mains_view/my_library/controller.dart';

class WorkBookBOOKDetailes extends GetxController {
  late SharedPreferences prefs;
  String? authToken;
  Rxn<Workbook> workbook = Rxn<Workbook>();
  Rxn<WorkBookBookDetailes> workbookDetailes = Rxn<WorkBookBookDetailes>();
  RxList<Sets> sets = <Sets>[].obs;
  RxBool isLoading = false.obs;
  var count = 0.obs;
  var error = ''.obs;
  void increment() {
    if (count.value == 0) {
      count.value = 1;
    }
  }

  var isSaved = false.obs;
  var isActionLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString(Constants.authToken);
    count.value = prefs.getInt(Constants.cartCount) ?? 0;
  }

  Future<void> fetchWorkbookDetails(
    String bookId, {
    bool showLoader = true,
  }) async {
    if (showLoader) isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');

      if (authToken == null) return;

      final String url = '${ApiUrls.workBookBookDetailes}$bookId/sets';

      await callWebApiGet(
        null,
        url,
        token: authToken,
        showLoader: false,
        hideLoader: true,
        onResponse: (response) async {
          final jsonData = json.decode(response.body);
          final details = WorkBookBookDetailes.fromJson(jsonData);
          workbook.value = details.workbook;
          workbookDetailes.value = details;
          sets.assignAll(details.sets ?? []);

          final cartCount = details.workbook?.countOfCartItems ?? 0;
          count.value = cartCount;
          await prefs.setInt(Constants.cartCount, cartCount);
        },
        onError: () {},
      );
    } catch (e) {
    } finally {
      if (showLoader) isLoading.value = false;
    }
  }

  Future<void> addToMyBooks(String bookId) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');

    if (authToken == null || authToken.isEmpty) {
      Get.offAll(() => User_Login_option());
      return;
    }

    if (bookId.isEmpty) {
      return;
    }

    isActionLoading.value = true;
    final String url = ApiUrls.addMyWorkBook;

    try {
      final body = {'workbook_id': bookId};

      await callWebApi(
        null,
        url,
        body,
        onResponse: (response) async {
          if (response.statusCode == 200) {
            isSaved.value = true;
            await fetchWorkbookDetails(bookId);
            Get.find<MyLibraryController>().loadBooks();
          } else if (response.statusCode == 401 || response.statusCode == 403) {
            await prefs.clear();
            Get.offAll(() => User_Login_option());
          } else {}
        },
        onError: () {},
        token: authToken,
        showLoader: false,
        hideLoader: false,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add book: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<bool> addWorkbookToCart(String workbookId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken') ?? '';

      if (workbookId.isEmpty) {
        print("⚠️ WorkbookId is empty.");
        return false;
      }

      const String addToCartUrl = ApiUrls.cartAdd;

      print("🔗 API URL: $addToCartUrl");
      print("📦 Request Body: {workbookId: $workbookId}");
      print("🔑 Token: $authToken");

      bool isSuccess = false;
      await callWebApi(
        null,
        addToCartUrl,
        {'workbookId': workbookId},
        token: authToken,
        showLoader: false,
        hideLoader: true,
        onResponse: (response) async {
          if (response.statusCode == 200) {
            increment();
            isSuccess = true;
            await fetchWorkbookDetails(workbookId, showLoader: false);
          } else {
            Get.snackbar(
              'Cart',
              'Failed to add to cart',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
        onError: () {},
      );
      return isSuccess;
    } catch (e) {
      print("❌ Exception: $e");
      return false;
    }
  }

  Future<void> deleteCartItem(String workbookId) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');
    final url = Uri.parse(
      'https://test.ailisher.com/api/clients/CLI147189HIGB/mobile/cart/item/$workbookId',
    );

    print("🔗 DeleteCartItem API URL: $url");
    print("🔑 Auth Token: $authToken");

    await callWebApiDelete(
      null,
      url.toString(),
      token: authToken ?? '',
      showLoader: false,
      hideLoader: true,
      onResponse: (response) async {
        print("✅ Item deleted successfully");

        /// ✅ Immediately fetch fresh details
        await fetchWorkbookDetails(workbookId, showLoader: false);
      },
      onError: () {
        error.value = 'Failed to delete item';
        print("❌ Error: ${error.value}");
      },
    );

    print("ℹ️ Loading finished (isLoading = false)");
  }
}

class WorkBookBOOKDetailesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(WorkBookBOOKDetailes());
  }
}
