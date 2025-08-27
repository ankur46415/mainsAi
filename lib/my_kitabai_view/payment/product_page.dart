// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:mains/my_kitabai_view/payment/payment_service.dart';

// class Product {
//   final String name;
//   final double price;
//   bool selected;

//   Product({required this.name, required this.price, this.selected = false});
// }

// class PaytmProductPage extends StatefulWidget {
//   const PaytmProductPage({super.key});

//   @override
//   State<PaytmProductPage> createState() => _PaytmProductPageState();
// }

// class _PaytmProductPageState extends State<PaytmProductPage> {
//   List<Product> products = [
//     Product(name: 'Course A', price: 499),
//     Product(name: 'Course B', price: 999),
//     Product(name: 'Course C', price: 1499),
//   ];

//   double get totalAmount =>
//       products.where((p) => p.selected).fold(0, (sum, p) => sum + p.price);

//   void _startPayment() async {
//     print('🟢 Pay Now tapped'); // 👈 Add this line

//     if (totalAmount == 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Select at least one product')),
//       );
//       return;
//     }

//     await PaytmService.startTransaction(
//       orderId: 'ORDER${DateTime.now().millisecondsSinceEpoch}',
//       customerId: 'USER123',
//       amount: totalAmount.toStringAsFixed(2),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Select Courses to Buy'),
//         backgroundColor: Colors.teal,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: products.length,
//               itemBuilder: (context, index) {
//                 final product = products[index];
//                 return CheckboxListTile(
//                   title: Text(product.name),
//                   subtitle: Text('₹${product.price.toStringAsFixed(2)}'),
//                   value: product.selected,
//                   onChanged: (value) {
//                     setState(() => product.selected = value ?? false);
//                   },
//                 );
//               },
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               border: const Border(top: BorderSide(color: Colors.black12)),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Total: ₹${totalAmount.toStringAsFixed(2)}',
//                   style: GoogleFonts.poppins(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: _startPayment,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.teal,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 24,
//                       vertical: 12,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: Text(
//                     'Pay Now',
//                     style: GoogleFonts.poppins(
//                       fontSize: 16,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ✅ Call PaytmProductPage() in main.dart to see the UI
