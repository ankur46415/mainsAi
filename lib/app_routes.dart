import 'package:mains/app_imports.dart';
import 'package:mains/my_kitabai_view/TestScreens/workBookPage/user_questions/question_answer_page.dart/question_answer_page.dart';
import 'package:mains/my_kitabai_view/ai_test/ai_test_subjective/subjective_test_answer/binding.dart';
import 'package:mains/my_kitabai_view/ai_test/ai_test_subjective/subjective_test_answer/sync_upload_answer/sync_sub_answer.dart';
import 'package:mains/my_kitabai_view/ai_test/start_test/objective_test_description.dart';
import 'package:mains/my_kitabai_view/evaluators/list_of_submissions.dart';
import 'package:mains/my_kitabai_view/help/help_screen.dart';
import 'package:mains/my_kitabai_view/manaul_qr_result/chapter_detailes.dart';
import 'package:mains/my_kitabai_view/plans/all_plan_screen.dart';
import 'package:mains/my_kitabai_view/plans/make_paymnet/make_payment.dart';
import 'package:mains/my_kitabai_view/plans/specific_course_plans/specific_course%20plans.dart';
import 'package:mains/my_kitabai_view/watch/video_page/play_video_controller.dart';
import 'package:mains/my_kitabai_view/yt_reel/binding.dart';
import 'package:mains/my_kitabai_view/yt_reel/yt_reel.dart';

import 'my_kitabai_view/creidt/history/payment_history.dart';

class AppRoutes {
  static const String introScreen = '/intoScreen';
  static const String login = '/login';
  static const String home = '/';
  static const String myBooks = '/mybooks';
  static const String ai = '/ai';
  static const String test = '/test';
  static const String settings = '/settings';
  static const String voiceScreen = '/voiceScreen';
  static const String bookDetails = '/book-details';
  static const String analytics = '/analytics';
  static const String getAsset = '/getAsset';
  static const String allWorkbookquestions = '/allWorkbookquestions';
  static const String workBookDetailesPage = '/workBookDetailesPage';
  static const String questionView = '/questionView';
  static const String assetResult = '/assetResult';
  static const String subjectiveSetDetail = '/subjectiveSetDetail';
  static const String questionAnswer = '/questionAnswer';
  static const String starttestpage = '/starttestpage';
  static const String mainTestForAiTest = '/mainTestForAiTest';
  static const String resultOfAitest = '/resultOfAitest';
  static const String subjectiveDescription = '/subjectiveDescription';
  static const String subjectiveTestNamePage = '/subjectiveTestNamePage';
  static const String subjectiveTestAllquestions =
      '/subjectiveTestAllquestions';
  static const String subTestAnswrUpload = '/subTestAnswrUpload';
  static const String syncSubAnswer = '/syncSubAnswer';
  static const String briefOfQuestion = '/briefOfQuestion';
  static const String aiCoursesMain = '/aiCoursesMain';
  static const String aiCourseVideoSubject = '/aiCourseVideoSubject';
  static const String playVideoAiCourses = '/playVideoAiCourses';
  static const String onjTestDescription = '/onjTestDescription';
  static const String mainScanner = '/mainScanner';
  static const String chapterDetails = '/chapterDetails';
  static const String helpScreen = '/helpScreen';
  static const String feedback = '/feedback';
  static const String listOfSubmissions = '/listOfSubmissions';
  static const String mainNav = '/mainNav';
  static const String payHistory = '/payHistory';
  static const String reels = '/reels';
  static const String plans = '/plans';
  static const String specificCourse = '/specificCourse';
  static const String makePayment = '/makePayment';
  static const String questionAnswerPage = '/questionAnswerPage';
}

//QuestionAnswerPage
final List<GetPage> appPages = [
  GetPage(name: AppRoutes.questionAnswerPage, page: () => QuestionAnswerPage()),
  GetPage(name: AppRoutes.introScreen, page: () => IntroMainScreen()),
  GetPage(name: AppRoutes.plans, page: () => AllPlanScreen()),
  GetPage(name: AppRoutes.makePayment, page: () => MakePayment()),
  GetPage(name: AppRoutes.specificCourse, page: () => SpecificCourse()),
  GetPage(name: AppRoutes.login, page: () => User_Login_option()),
  GetPage(name: AppRoutes.helpScreen, page: () => HelpScreen()),
  GetPage(name: AppRoutes.feedback, page: () => FeedbackForm()),
  GetPage(name: AppRoutes.listOfSubmissions, page: () => ListOfSubmissions()),
  GetPage(
    name: AppRoutes.home,
    page: () => MyHomePage(),
    binding: HomeScreenBinding(),
  ),
  GetPage(name: AppRoutes.payHistory, page: () => PaymentHistoryScreen()),
  GetPage(
    name: AppRoutes.mainNav,
    page: () => MyHomePage(),
    binding: HomeScreenBinding(),
  ),
  GetPage(
    name: AppRoutes.myBooks,
    page: () => MyLibraryView(),
    binding: MyLibraryBinding(),
  ),
  GetPage(
    name: AppRoutes.ai,
    page: () => VoiceScreen(),
    binding: VoiceBinding(),
  ),
  GetPage(
    name: AppRoutes.test,
    page: () => MainTestScreen(),
    binding: MainTestScreenBinding(),
  ),
  GetPage(name: AppRoutes.settings, page: () => ProfileScreen()),
  GetPage(
    name: AppRoutes.voiceScreen,
    page: () => VoiceScreen(initialChatMode: true),
  ),
  GetPage(
    name: AppRoutes.bookDetails,
    page: () {
      final args = Get.arguments as Map<String, dynamic>;
      return BookDetailsPage(bookId: args['bookId']);
    },
  ),

  GetPage(name: AppRoutes.analytics, page: () => MainAnalytics()),
  GetPage(name: AppRoutes.getAsset, page: () => AssetQrScanner()),
  GetPage(name: AppRoutes.chapterDetails, page: () => ChapterDetails()),

  GetPage(
    name: AppRoutes.allWorkbookquestions,
    page: () => AllWorkbookquestions(),
  ),
  GetPage(
    name: AppRoutes.workBookDetailesPage,
    page: () => WorkBookDetailesPage(),
  ),
  GetPage(
    name: AppRoutes.questionView,
    page: () {
      final args = Get.arguments as Map<String, dynamic>;
      return QuestionViewPage(
        questions: args['questions'],
        title: args['title'],
      );
    },
  ),
  GetPage(name: AppRoutes.assetResult, page: () => AssetReslut()),
  GetPage(
    name: AppRoutes.subjectiveSetDetail,
    page: () {
      final args = Get.arguments as Map<String, dynamic>;
      return SubjectiveSetDetailPage(
        setName: args['setName'],
        questions: args['questions'],
      );
    },
  ),
  GetPage(name: AppRoutes.questionAnswer, page: () => Questionanswerpage()),
  GetPage(name: AppRoutes.starttestpage, page: () => ObjectiveTestName()),
  GetPage(name: AppRoutes.mainTestForAiTest, page: () => MainTestForAiTest()),
  GetPage(name: AppRoutes.onjTestDescription, page: () => OnjTestDescription()),
  GetPage(name: AppRoutes.mainScanner, page: () => MainPageScanner()),
  GetPage(
    name: AppRoutes.subjectiveDescription,
    page: () => SubjTestDescription(),
    binding: SubjectiveTestDescriptionBinding(),
  ),
  GetPage(
    name: AppRoutes.subjectiveTestNamePage,
    page: () => SubjectiveTestNamePage(),
  ),
  GetPage(
    name: AppRoutes.subjectiveTestAllquestions,
    page: () => SubjectiveTestAllquestions(),
  ),
  GetPage(
    name: AppRoutes.subTestAnswrUpload,
    page: () => SubjectiveTestAnswerUpload(),
    binding: SubTestAnswerUploadBinding(),
  ),
  GetPage(name: AppRoutes.syncSubAnswer, page: () => SyncSubAnswer()),

  GetPage(
    name: '/playVideo',
    page: () {
      final args = Get.arguments as Map<String, dynamic>;
      return PlayVideoPage(
        topics: args['topics'],
        initialIndex: args['initialIndex'] ?? 0,
      );
    },
    binding: PlayVideoBinding(),
  ),
  GetPage(
    name: AppRoutes.reels,
    page: () => ReelsView(),
    binding: ReelsBinding(),
  ),
];
