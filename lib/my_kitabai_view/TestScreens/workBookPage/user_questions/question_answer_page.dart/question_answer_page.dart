import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mains/app_imports.dart';

class QuestionAnswerPage extends StatefulWidget {
  const QuestionAnswerPage({super.key});

  @override
  State<QuestionAnswerPage> createState() => _QuestionAnswerPageState();
}

class _QuestionAnswerPageState extends State<QuestionAnswerPage> {
  final TextEditingController _questionController = TextEditingController();
  final List<File> _selectedImages = [];

  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  Future<void> _pickFromCamera() async {
    final XFile? photo = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (photo != null) {
      setState(() {
        _selectedImages.add(File(photo.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFC107), Color.fromARGB(255, 236, 87, 87)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        title: Text(
          'Question & Answer',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // QUESTION CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.shade100, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Question",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _questionController,
                      maxLines: 6,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                      ),
                      decoration: InputDecoration(
                        hintText: "Write your question here...",
                        hintStyle: GoogleFonts.poppins(color: Colors.grey),
                        contentPadding: const EdgeInsets.all(14),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue.shade400),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: _ThemedButton(
                        icon: Icons.image_search,
                        label: "Upload Image",
                        color: CustomColors.meeting,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ANSWER IMAGES CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.image, color: Colors.orange.shade600),
                        const SizedBox(width: 8),
                        Text(
                          "Answer Images",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _selectedImages.isNotEmpty
                        ? GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemCount: _selectedImages.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    _selectedImages[index],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedImages.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: const Icon(
                                        Icons.close,
                                        size: 14,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        )
                        : Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Icon(
                                Icons.photo_camera_back_rounded,
                                size: 70,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "No Answer Images Captured",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _ThemedButton(
                            icon: Icons.photo_library,
                            label: "Gallery",
                            color: CustomColors.meeting,
                            onTap: _pickImages,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ThemedButton(
                            icon: Icons.camera_alt,
                            label: "Camera",
                            color: Colors.orange.shade600,
                            onTap: _pickFromCamera,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFC107),
                  Color.fromARGB(255, 236, 87, 87),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: FloatingActionButton.extended(
              backgroundColor: Colors.transparent, // important
              elevation: 0, // let container shadow handle elevation
              onPressed: () {
                debugPrint("✅ Submit pressed");
                // TODO: Add your submit logic
              },
              icon: const Icon(Icons.check, color: Colors.white),
              label: Text(
                "Submit",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemedButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ThemedButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: color,
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 45,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
