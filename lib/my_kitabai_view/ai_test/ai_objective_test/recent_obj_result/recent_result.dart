// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:mains/my_kitabai_view/ai_test/ai_objective_test/recent_obj_result/controller.dart';

// class ObjectiveRecentResult extends StatefulWidget {
//   const ObjectiveRecentResult({super.key});

//   @override
//   State<ObjectiveRecentResult> createState() => _ObjectiveRecentResultState();
// }

// class _ObjectiveRecentResultState extends State<ObjectiveRecentResult> {
//   final RecentResultObj controller = Get.put(RecentResultObj());

//   @override
//   void initState() {
//     super.initState();
//     controller.fetchResult(controller.testId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Obx(
//           () => Text(
//             controller.testName.value.isNotEmpty
//                 ? controller.testName.value
//                 : "Recent Result",
//             style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//           ),
//         ),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

       

//         return Column(
//           children: [
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16),
//               color: Colors.blue[50],
//               child: Text(
//                 "Total Time: ${controller.totalTime.value}",
//                 style: GoogleFonts.poppins(
//                   fontWeight: FontWeight.w500,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: ListView.separated(
//                 padding: const EdgeInsets.all(16),
//                 itemCount: controller.userAnswers.length,
//                 separatorBuilder: (_, __) => const SizedBox(height: 12),
//                 itemBuilder: (context, index) {
//                   final questionId = controller.userAnswers.keys.elementAt(
//                     index,
//                   );
//                   final userAnswer = controller.userAnswers[questionId];

//                   return Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 6,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Q${index + 1}: $questionId",
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 14,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text("Your Answer: ${userAnswer ?? '–'}"),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }
