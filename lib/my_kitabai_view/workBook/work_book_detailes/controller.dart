import 'package:mains/app_imports.dart';
import 'package:http/http.dart' as http;
import 'package:mains/model/workBookBookDetailes.dart';
import 'package:mains/my_kitabai_view/my_library/controller.dart';

class WorkBookBOOKDetailes extends GetxController {
  late SharedPreferences prefs;
  String? authToken;
  Rxn<Workbook> workbook = Rxn<Workbook>();
  Rxn<WorkBookBookDetailes> workbookDetailes = Rxn<WorkBookBookDetailes>();
  RxList<Sets> sets = <Sets>[].obs;
  RxBool isLoading = false.obs;

  var isSaved = false.obs;
  var isActionLoading = false.obs;
  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString(Constants.authToken);
  }

  Future<void> fetchWorkbookDetails(String bookId) async {
    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');

      if (authToken == null) {
        print("❌ Authentication token is missing.");
        Get.snackbar('Auth Error', 'Authentication token is missing');
        isLoading.value = false;
        return;
      }

      final url = Uri.parse('${ApiUrls.workBookBookDetailes}$bookId/sets');

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        final details = WorkBookBookDetailes.fromJson(jsonData);

        workbook.value = details.workbook;
        workbookDetailes.value = details;
        sets.assignAll(details.sets ?? []);
      } else {
        Get.snackbar('Error', 'Failed to fetch data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception: $e');
    } finally {
      isLoading.value = false;
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
}

class WorkBookBOOKDetailesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(WorkBookBOOKDetailes());
  }
}
