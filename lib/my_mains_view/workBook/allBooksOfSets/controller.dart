import 'package:http/http.dart' as http;
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

     

      final url = Uri.parse(
        '${ApiUrls.workBookAllQuestiones}$bookId/sets/$sid/questions',
      );


      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );

     
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final parsed = AllQuestionsOfSets.fromJson(data);
        questions.assignAll(parsed.questions ?? []);
      } else {
        Get.snackbar('Error', 'Failed to load questions');
      }
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
