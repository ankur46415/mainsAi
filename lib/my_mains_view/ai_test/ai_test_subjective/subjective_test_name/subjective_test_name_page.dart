import 'package:mains/app_imports.dart';
import 'package:mains/my_mains_view/ai_test/ai_test_subjective/subjective_test_name/test_analytics.dart';
import 'package:mains/my_mains_view/ai_test/ai_test_subjective/subjective_test_name/controller.dart';
import 'package:mains/my_mains_view/workBook/work_book_detailes/count_down.dart';

class SubjectiveTestNamePage extends StatefulWidget {
  const SubjectiveTestNamePage({super.key});

  @override
  State<SubjectiveTestNamePage> createState() => _SubjectiveTestNamePageState();
}

class _SubjectiveTestNamePageState extends State<SubjectiveTestNamePage> {
  final GlobalKey<SlideActionState> key = GlobalKey();
  late SubjectiveTestController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SubjectiveTestController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.checkIfLongDescription(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.hasError.value) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(title: 'Test Details'),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Error Loading Test',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.errorMessage.value,
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(title: "Test Details"),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFFC107),
                          Color.fromARGB(255, 236, 87, 87),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (controller.testData.imageUrl != null &&
                            controller.testData.imageUrl!.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: controller.testData.imageUrl!,
                              height: Get.width * 0.6,
                              width: double.infinity,
                              fit: BoxFit.fill,
                              placeholder:
                                  (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                              errorWidget:
                                  (context, url, error) => const Icon(
                                    Icons.menu_book_rounded,
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        const SizedBox(height: 12),
                        Text(
                          controller.testData.name ?? "Untitled Test",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Duration: ${controller.testData.estimatedTime ?? 'N/A'}  |  Category: ${controller.testData.category ?? 'N/A'}",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 22,
                                    color: Colors.green[300],
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Scheduled : " +
                                        (controller.testData.startsAt != null
                                            ? controller.formatDateTime(
                                              controller.testData.startsAt,
                                            )
                                            : '-'),
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),
                              Builder(
                                builder: (context) {
                                  final DateTime? starts =
                                      controller.testData.startsAt != null
                                          ? DateTime.tryParse(
                                            controller.testData.startsAt!,
                                          )
                                          : null;
                                  final DateTime? ends =
                                      controller.testData.endsAt != null
                                          ? DateTime.tryParse(
                                            controller.testData.endsAt!,
                                          )
                                          : null;
                                  return CountdownDisplay(
                                    startsAt: starts,
                                    endsAt: ends,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (controller.testData.description != null &&
                            controller.testData.description!.isNotEmpty) ...[
                          Obx(
                            () => Text(
                              controller.testData.description!,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                              maxLines: controller.isExpanded.value ? null : 3,
                              overflow:
                                  controller.isExpanded.value
                                      ? TextOverflow.visible
                                      : TextOverflow.ellipsis,
                            ),
                          ),
                          Obx(
                            () =>
                                controller.isLongDescription.value
                                    ? GestureDetector(
                                      onTap: () {
                                        controller.toggleDescriptionExpansion();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          controller.isExpanded.value
                                              ? "See less"
                                              : "See more",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            color: Colors.yellow,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    )
                                    : const SizedBox.shrink(),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (controller.testData.userTestStatus?.attempted ==
                      true) ...[
                    TestAnalyticsCard(testId: controller.testData.testId),
                    SizedBox(height: Get.width * 0.05),
                  ] else if (controller.testData.instructions != null &&
                      controller.testData.instructions!.isNotEmpty) ...[
                    Text(
                      "Instructions",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text(
                        controller.testData.instructions!,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    SizedBox(height: Get.width * 0.05),
                  ],
                  if (controller.testData.userTestStatus?.attempted !=
                      true) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          controller.startTest(context);
                        },
                        icon: const Icon(Icons.play_arrow, color: Colors.white),
                        label: Text(
                          "Let's Start",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Color(0xFFFFC107),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
