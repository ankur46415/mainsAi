import 'package:mains/app_imports.dart';

class WatchIntroOfCourses extends StatefulWidget {
  final String? bookId;
  const WatchIntroOfCourses({super.key, this.bookId});

  @override
  State<WatchIntroOfCourses> createState() => _WatchIntroOfCoursesState();
}

class _WatchIntroOfCoursesState extends State<WatchIntroOfCourses>
    with SingleTickerProviderStateMixin {
  late WatchIntroController controller;
  late TabController _tabController;
  final Color primaryColor = Colors.redAccent;
  final Color secondaryColor = Colors.red.shade100;

  @override
  void initState() {
    super.initState();
    controller = Get.put(WatchIntroController(widget.bookId));
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CustomAppBar(title: "Watch Video"),

      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: LoadingWidget());
          }

          if (controller.courseData.isEmpty && controller.faculty.isEmpty) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/forbidden-sign.png",
                    height: Get.width * 0.3,
                  ),
                  SizedBox(height: Get.width * 0.04),
                  Text(
                    "No Course Video Available",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: Get.width * 0.45,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          (controller.courseData.isNotEmpty &&
                                  controller.courseData.first.coverImageUrl !=
                                      null &&
                                  controller
                                      .courseData
                                      .first
                                      .coverImageUrl!
                                      .isNotEmpty)
                              ? NetworkImage(
                                controller.courseData.first.coverImageUrl!,
                              )
                              : const AssetImage(
                                    "assets/images/thumbnails.jpeg",
                                  )
                                  as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                    color: secondaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: primaryColor,
                  dividerColor: Colors.transparent,
                  indicatorColor: Colors.transparent,
                  unselectedLabelColor: Colors.grey.shade600,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                  ),
                  labelStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  tabs: const [
                    Tab(text: ' Overview '),
                    Tab(text: ' Details '),
                    Tab(text: ' Faculty '),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    /// Overview
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Course Overview",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.courseData.first.overview ??
                                "No overview available",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Details
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Course Details",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.courseData.first.details ??
                                "No details available",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Faculty
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Faculty",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Column(
                            children:
                                controller.faculty.map((f) {
                                  return Container(
                                    padding: const EdgeInsets.all(12),
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.redAccent.withOpacity(
                                          0.5,
                                        ),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            f.facultyImageUrl != null
                                                ? CircleAvatar(
                                                  radius: 50,
                                                  backgroundImage: NetworkImage(
                                                    f.facultyImageUrl!,
                                                  ),
                                                )
                                                : const CircleAvatar(
                                                  radius: 50,
                                                  child: Icon(Icons.person),
                                                ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                f.name ?? '',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Divider(
                                          color: Colors.red.withOpacity(0.5),
                                        ),
                                        Text(
                                          f.about ?? '',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
      floatingActionButton: Obx(() {
        if (controller.courseData.isEmpty && controller.faculty.isEmpty) {
          return SizedBox.shrink(); // Hides the button
        } else {
          return FloatingActionButton.extended(
            onPressed: () {
              Get.to(
                LectureDetailesOfCourses(
                  bookId: widget.bookId,
                  lectureId: controller.courseData.first.sId.toString(),
                ),
              );
            },
            backgroundColor: primaryColor,
            icon: const Icon(Icons.play_arrow, color: Colors.white),
            label: Text(
              controller.hasSavedVideoPosition.value
                  ? "Continue Watching"
                  : "Watch Video",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          );
        }
      }),
    );
  }
}
