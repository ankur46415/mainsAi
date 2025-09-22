// import 'package:mains/app_imports.dart';

// class UserQuestionsPage extends StatefulWidget {
//   const UserQuestionsPage({super.key});

//   @override
//   State<UserQuestionsPage> createState() => _UserQuestionsPageState();
// }

// class _UserQuestionsPageState extends State<UserQuestionsPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: InkWell(
//           onTap: () {
//             Get.toNamed(AppRoutes.questionAnswerPage);
//           },
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),

//               gradient: LinearGradient(
//                 colors: [Color(0xFFFFC107), Color.fromARGB(255, 236, 87, 87)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),

//             child: const Text(
//               '+ Add Questions',
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
