import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackController extends GetxController {
  final RxInt _rating = 3.obs;
  final RxString _comments = ''.obs;

  int get rating => _rating.value;
  String get comments => _comments.value;

  void setRating(int value) => _rating.value = value;
  void setComments(String value) => _comments.value = value;
 
  void submitFeedback() {
    if (comments.isNotEmpty) {
      Get.snackbar(
        'Thank you!',
        'We appreciate your feedback',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(16),
        titleText: Text(
          'Thank you!',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        messageText: Text(
          'We appreciate your feedback',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
      );
    } else {
      Get.snackbar(
        'Oops!',
        'Please share your thoughts',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(16),
        titleText: Text(
          'Oops!',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        messageText: Text(
          'Please share your thoughts',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
      );
    }
  }
}

class FeedbackBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FeedbackController());
  }
}

class FeedbackForm extends StatelessWidget {
  final FeedbackController _controller = Get.put(FeedbackController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.deepPurple),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderSection(),
            SizedBox(height: 32),
            _RatingSection(controller: _controller),
            SizedBox(height: 32),
            _CommentSection(controller: _controller),
            SizedBox(height: 40),
            _SubmitButton(controller: _controller),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.feedback_outlined, size: 60, color: Colors.deepPurple),
        SizedBox(height: 16),
        Text(
          'Share Your Experience',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple[800],
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Your feedback helps us improve our service',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class _RatingSection extends StatelessWidget {
  final FeedbackController controller;

  const _RatingSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How would you rate us?',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16),
        Obx(
              () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () => controller.setRating(index + 1),
                child: Icon(
                  index < controller.rating ? Icons.star : Icons.star_border,
                  size: 40,
                  color: Colors.amber,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _CommentSection extends StatelessWidget {
  final FeedbackController controller;

  const _CommentSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your comments',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12),
        TextFormField(
          maxLines: 5,
          style: TextStyle(fontFamily: 'Poppins'),
          decoration: InputDecoration(
            hintText: 'What did you like or how can we improve?',
            hintStyle: TextStyle(fontFamily: 'Poppins'),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(16),
          ),
          onChanged: (value) => controller.setComments(value),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final FeedbackController controller;

  const _SubmitButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),


        onPressed: controller.submitFeedback,
        child: Text(
          'Submit Feedback',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}