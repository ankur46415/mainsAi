// import 'dart:io';
// import 'package:crop_your_image/crop_your_image.dart';
// import 'package:flutter/material.dart';

// class CropImagePage extends StatefulWidget {
//   final File image;
//   const CropImagePage({super.key, required this.image});

//   @override
//   State<CropImagePage> createState() => _CropImagePageState();
// }

// class _CropImagePageState extends State<CropImagePage> {
//   final _cropController = CropController();
//   bool _cropping = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text('Crop Image'),
//         backgroundColor: Colors.black,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.check, color: Colors.white),
//             onPressed: () {
//               setState(() => _cropping = true);
//               _cropController.crop();
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: _cropping
//             ? const CircularProgressIndicator()
//             : Crop(
//                 controller: _cropController,
//                 image: widget.image.readAsBytesSync(),
//                 onCropped: (result) {
//                   switch (result) {
//                     case CropSuccess(:final croppedImage):
//                       Navigator.pop(context, File.fromRawPath(croppedImage));
//                     case CropFailure(:final cause):
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Crop failed: $cause')),
//                       );
//                       setState(() => _cropping = false);
//                   }
//                 },
//                 withCircleUi: false,
//                 cornerDotBuilder: (size, edgeAlignment) =>
//                     const DotControl(color: Colors.white),
//                 initialSize: 0.8,
//               ),
//       ),
//     );
//   }
// }
