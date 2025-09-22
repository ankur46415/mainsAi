import 'package:http/http.dart' as http;
import 'package:mains/app_imports.dart';

class CurriculumController extends GetxController {
  String? authToken;
  late SharedPreferences prefs;
  final String? bookId;
  final String? lectureId;
  var isLoading = false.obs;
  var lectures = <Lecture>[].obs;
  var topics = <Topics>[].obs;

  final RxList<Map<String, dynamic>> sections = <Map<String, dynamic>>[].obs;

  CurriculumController(this.bookId, this.lectureId);

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString(Constants.authToken);
    getTopics();
  }

  Future<void> getTopics() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');



    if (bookId == null || lectureId == null) {
      return;
    }

    isLoading.value = true;

    final url = '${ApiUrls.courseDetaile}$bookId/course/$lectureId/topic';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

     

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final parsed = CourseLectureModel.fromJson(data);

        lectures.value = parsed.lectures ?? [];

        final allTopics = <Topics>[];
        for (var lecture in lectures) {
          if (lecture.topics != null) {
            allTopics.addAll(lecture.topics!);
          }
        }

        topics.value = allTopics;
        buildSectionsFromLectures();

      
      } else {
        Get.snackbar("Error", "Failed to load topics: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }

  var totalLectures = 0.obs;
  var totalTopics = 0.obs;
  void toggleExpansion(int index) {
    sections[index]['isExpanded'].value = !sections[index]['isExpanded'].value;
  }

  void buildSectionsFromLectures() {
    sections.clear();

    totalLectures.value = lectures.length;
    totalTopics.value = 0;

    for (var i = 0; i < lectures.length; i++) {
      final lecture = lectures[i];
      final lectureTopics =
          lecture.topics?.map((t) => t.topicName ?? '').toList() ?? [];

      totalTopics.value += lectureTopics.length;

      sections.add({
        'title': lecture.lectureName?.toString() ?? "Untitled",
        'topics': lectureTopics,
        'isExpanded': false.obs,
      });
    }

  }
}

class CurriculumBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments as Map<String, dynamic>?;
    Get.put(CurriculumController(
      args?['bookId'],
      args?['lectureId'],
    ));
  }
}
