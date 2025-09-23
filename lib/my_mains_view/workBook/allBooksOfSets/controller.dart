import 'package:mains/app_imports.dart';
import 'package:mains/models/allQuestionsOfSets.dart';

class SetsOfQuestions extends GetxController {
  late String sid;
  late String bookId;

  var isLoading = false.obs;
  var questions = <Questions>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  void initialize({required String sid, required String bookId}) {
    this.sid = sid;
    this.bookId = bookId;
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');

      final String url =
          '${ApiUrls.workBookAllQuestiones}$bookId/sets/$sid/questions';

      await callWebApiGet(
        null,
        url,
        token: authToken ?? '',
        showLoader: false,
        hideLoader: true,
        onResponse: (response) {
          final data = json.decode(response.body);
          final parsed = AllQuestionsOfSets.fromJson(data);
          questions.assignAll(parsed.questions ?? []);
        },
        onError: () {
          Get.snackbar('Error', 'Failed to load questions');
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }
}

class SetsOfQuestionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SetsOfQuestions());
  }
}
