import 'package:mains/app_imports.dart';
import 'package:mains/common/api_services.dart';

class WatchIntroController extends GetxController {
  String? authToken;
  late SharedPreferences prefs;
  final String? bookId;

  WatchIntroController(this.bookId);

  var courseData = <Course>[].obs;
  var faculty = <Faculty>[].obs;
  var isLoading = false.obs;
  var hasSavedVideoPosition = false.obs;

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString(Constants.authToken);
    if (bookId != null) {
      fetchCourseDetails();
    }
    fetchCourseDetails();
  }

  Future<void> checkForSavedVideoPositions() async {
    if (courseData.isEmpty) return;

    try {
      final courseId = courseData.first.sId;
      if (courseId == null) return;

      final url = '${ApiUrls.courseDetaile}$bookId/course/$courseId/topic';
      await callWebApiGet(
        null,
        url,
        token: authToken ?? '',
        showLoader: false,
        hideLoader: true,
        onResponse: (response) {
          final data = json.decode(response.body);
          final parsed = CourseLectureModel.fromJson(data);
          final lectures = parsed.lectures ?? [];

          final allVideoUrls = <String>[];
          for (final lecture in lectures) {
            if (lecture.topics != null) {
              for (final topic in lecture.topics!) {
                if (topic.videoUrl != null && topic.videoUrl!.isNotEmpty) {
                  allVideoUrls.add(topic.videoUrl!);
                }
              }
            }
          }

          for (final videoUrl in allVideoUrls) {
            final videoId = _extractYoutubeId(videoUrl);
            if (videoId.isNotEmpty) {
              final savedPosition = prefs.getDouble('video_$videoId');
              if (savedPosition != null && savedPosition > 0) {
                hasSavedVideoPosition.value = true;
                return;
              }
            }
          }
          hasSavedVideoPosition.value = false;
        },
        onError: () {
          hasSavedVideoPosition.value = false;
        },
      );
    } catch (e) {
      hasSavedVideoPosition.value = false;
    }
  }

  String _extractYoutubeId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return '';
    if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : '';
    } else if (uri.host.contains('youtube.com')) {
      return uri.queryParameters['v'] ?? '';
    }
    return '';
  }

  Future<void> fetchCourseDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');

    try {
      isLoading.value = true;

      final url = '${ApiUrls.courseDetaile}$bookId/course';
      await callWebApiGet(
        null,
        url,
        token: authToken ?? '',
        showLoader: false,
        hideLoader: true,
        onResponse: (response) async {
          final jsonData = json.decode(response.body);
          final courseResponse = CourseVideoDetailes.fromJson(jsonData);

          if (courseResponse.success == true && courseResponse.course != null) {
            courseData.value = courseResponse.course!;
            final allFaculty = <Faculty>[];
            for (final course in courseResponse.course!) {
              if (course.faculty != null) {
                allFaculty.addAll(course.faculty!);
              }
            }
            faculty.value = allFaculty;

            await checkForSavedVideoPositions();
          }
        },
        onError: () {},
      );
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }
}

class WatchIntroBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments as Map<String, dynamic>?;
    Get.put(WatchIntroController(args?['bookId']));
  }
}
