// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import '../../../common/shred_pref.dart';
// import '../../../common/api_urls.dart';
// import '../../../model/book_details_data.dart';
// import '../../logIn_flow/logIn_page_screen/User_Login_option.dart';
// import '../../my_library/controller.dart';
// import '../../../common/api_services.dart';

// class BookingDetailesController extends GetxController {
//   RxBool isAdded = false.obs;
//   RxBool isLoading = false.obs;

//   Rx<BookDetailsData?> bookDetails = Rx<BookDetailsData?>(null);
//   String? authToken;
//   late SharedPreferences prefs;
//   final rotationValue = 0.0.obs;
//   final Rx<AiGuidelines?> aiGuidelines = Rx<AiGuidelines?>(null);
//   @override
//   void onInit() async {
//     super.onInit();
//     prefs = await SharedPreferences.getInstance();
//     authToken = prefs.getString(Constants.authToken);
//   }

//   var isSaved = false.obs;
//   var isActionLoading = false.obs;

//   Future<void> fetchBookDetails(String bookId, {bool showLoader = true}) async {
//     final prefs = await SharedPreferences.getInstance();
//     final authToken = prefs.getString('authToken');
//     if (bookId.isEmpty) {
//       return;
//     }

//     if (showLoader) isLoading.value = true;
//     final String url = '${ApiUrls.getBookDetails}$bookId';

//     await callWebApiGet(
//       null,
//       url,
//       onResponse: (response) {
//         if (response.statusCode == 200) {
//           final jsonData = json.decode(response.body);
//           if (jsonData['data'] != null) {
//             bookDetails.value = BookDetailsData.fromJson(jsonData);
//             aiGuidelines.value = bookDetails.value?.data?.aiGuidelines;

//             if (bookDetails.value?.data?.index != null) {
//               for (var chapter in bookDetails.value!.data!.index!) {}
//             }

//             if (bookDetails.value?.data?.isOwnBook == true) {
//               isAdded.value = true;
//             }
//           } else {
//             Get.snackbar(
//               'Error',
//               'Invalid book details received',
//               snackPosition: SnackPosition.BOTTOM,
//             );
//           }
//         } else {}
//       },
//       onError: () {},
//       token: authToken ?? '',
//       showLoader: false,
//       hideLoader: false,
//     );
//   }

//   Future<void> fetchBookStatus(String bookId) async {
//     final prefs = await SharedPreferences.getInstance();
//     final authToken = prefs.getString('authToken');
//     if (bookId.isEmpty) {
//       return;
//     }

//     isLoading.value = true;
//     final String url = '${ApiUrls.checkBook}$bookId';

//     try {
//       final response = await callWebApiGet(
//         null,
//         url,
//         onResponse: (response) async {
//           if (response.statusCode == 200) {
//             final jsonData = json.decode(response.body);
//             if (jsonData['success'] == true && jsonData['data'] != null) {
//               isSaved.value = jsonData['data']['is_saved'] ?? false;
//             } else if (response.statusCode == 401 ||
//                 response.statusCode == 403) {
//               final prefs = await SharedPreferences.getInstance();
//               await prefs.clear();
//               Get.offAll(() => User_Login_option());
//             }
//           } else if (response.statusCode == 401 || response.statusCode == 403) {
//             SharedPreferences.getInstance().then((prefs) async {
//               await prefs.clear();
//               Get.offAll(() => User_Login_option());
//             });
//           } else {}
//         },
//         onError: () {},
//         token: authToken ?? '',
//         showLoader: false,
//         hideLoader: false,
//       );
//     } catch (e) {
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> addToMyBooks(String bookId) async {
//     if (bookId.isEmpty) {
//       return;
//     }

//     isActionLoading.value = true;
//     final String url = ApiUrls.addMyBooks;

//     try {
//       final body = jsonEncode({'book_id': bookId});

//       await callWebApi(
//         null,
//         url,
//         {'book_id': bookId},
//         onResponse: (response) async {
//           if (response.statusCode == 200) {
//             isSaved.value = true;
//             fetchBookDetails(bookId, showLoader: false);
//             Get.find<MyLibraryController>().loadBooks();
//           } else if (response.statusCode == 401 || response.statusCode == 403) {
//             SharedPreferences.getInstance().then((prefs) async {
//               await prefs.clear();
//               Get.offAll(() => User_Login_option());
//             });
//           } else {
//             Get.snackbar(
//               'Error',
//               'Failed to add book: \\${response.statusCode}',
//               snackPosition: SnackPosition.BOTTOM,
//             );
//           }
//         },
//         onError: () {},
//         token: authToken ?? '',
//         showLoader: false,
//         hideLoader: false,
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to add book: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isActionLoading.value = false;
//     }
//   }

//   @override
//   void onClose() {
//     // Clean up any resources if needed
//     super.onClose();
//   }
// }

// class BookingDetailesBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.put(BookingDetailesController());
//   }
// }
