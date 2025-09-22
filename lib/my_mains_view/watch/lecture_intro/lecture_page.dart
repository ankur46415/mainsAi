
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mains/common/app_bar.dart';
import 'package:mains/common/loading_widget.dart';
import 'package:mains/my_mains_view/watch/lecture_intro/lecture_controller.dart';
import 'package:mains/my_mains_view/watch/video_page/play_video_page.dart';

class LectureDetailesOfCourses extends StatefulWidget {
  final String? bookId;
  final String? lectureId;
  const LectureDetailesOfCourses({super.key, this.bookId, this.lectureId});

  @override
  State<LectureDetailesOfCourses> createState() =>
      _LectureDetailesOfCoursesState();
}

class _LectureDetailesOfCoursesState extends State<LectureDetailesOfCourses> {
  late CurriculumController controller;
  @override
  void initState() {
    controller = Get.put(CurriculumController(widget.bookId, widget.lectureId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Course"),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: LoadingWidget());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Course Curriculam',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Lectures: ${controller.totalLectures.value}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Topics: ${controller.totalTopics.value}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.width * 0.02),
              Column(
                children: List.generate(
                  controller.sections.length,
                  (index) => _buildSectionCard(index),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionCard(int index) {
    return Obx(
      () => Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        color: Colors.white,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            key: Key(index.toString()),
            initiallyExpanded: controller.sections[index]['isExpanded'].value,
            onExpansionChanged: (expanded) {
              controller.toggleExpansion(index);
            },
            tilePadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            title: Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  controller.sections[index]['title']
                                      .split('-')[0]
                                      .trim() +
                                  ' ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            trailing: Obx(
              () => Padding(
                padding: EdgeInsets.only(left: Get.width * 0.02),
                child: Icon(
                  controller.sections[index]['isExpanded'].value
                      ? Icons.remove_circle_outline
                      : Icons.add_circle_outline,
                  color: Colors.redAccent,
                ),
              ),
            ),
            children: [
              Divider(
                height: 0,
                indent: 16,
                endIndent: 16,
                color: Colors.redAccent,
              ),
              ...List<Widget>.generate(
                controller.sections[index]['topics'].length,
                (topicIndex) => ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 0,
                  ),
                  leading: Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${topicIndex + 1}',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  title: Text(
                    controller.sections[index]['topics'][topicIndex],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Icon(
                    Icons.play_circle_outline,
                    color: Colors.redAccent.withOpacity(0.6),
                    size: 20,
                  ),
                  onTap: () {
                    final lecture = controller.lectures[index];
                    final topics = lecture.topics ?? [];
                    Get.to(
                      PlayVideoPage(topics: topics, initialIndex: topicIndex),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
