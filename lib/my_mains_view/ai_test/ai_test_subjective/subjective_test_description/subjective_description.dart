import 'package:mains/app_imports.dart';
import 'package:mains/models/ai_test_subjective.dart';

class SubjTestDescription extends StatefulWidget {
  const SubjTestDescription({super.key});

  @override
  State<SubjTestDescription> createState() => _SubjTestDescriptionState();
}

class _SubjTestDescriptionState extends State<SubjTestDescription> {
  late SubjectiveTestDescriptionController controller;
  final GlobalKey<SlideActionState> key = GlobalKey();
  late Test testData;

  @override
  void initState() {
    controller = Get.put(SubjectiveTestDescriptionController());
    super.initState();
    testData = Get.arguments as Test;
    controller.initializeWithTestData(testData);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check test status when returning to this screen
    controller.checkTestStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(title: "Test Details"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFFC107),
                      Color.fromARGB(255, 236, 87, 87),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.shade200,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        controller.testName.value,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () =>
                              _buildMetaTile("Time", controller.duration.value),
                        ),

                        Obx(
                          () => _buildMetaTile(
                            "Questions",
                            controller.questionCount.value,
                          ),
                        ),
                        Obx(
                          () => _buildMetaTile(
                            "Marks",
                            controller.maxMarks.value,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              Text(
                "Test Instructions",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.red.shade100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Obx(
                  () => Text(
                    controller.description.value,
                    style: GoogleFonts.poppins(
                      fontSize: 14.5,
                      height: 1.5,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.width * 0.2),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GestureDetector(
          onTap: () {
            if (controller.questionCount.value.isNotEmpty &&
                int.tryParse(controller.questionCount.value) != null &&
                int.parse(controller.questionCount.value) > 0) {
              Get.toNamed(
                AppRoutes.subjectiveTestAllquestions,
                arguments: controller.testId.value,
              );
            }
          },
          child: Obx(() {
            final hasQuestions = controller.questionCount.value.isNotEmpty && 
                int.tryParse(controller.questionCount.value) != null &&
                int.parse(controller.questionCount.value) > 0;
            final buttonColor = hasQuestions ? CustomColors.dayStart : Colors.grey.shade400;
            
            return Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: buttonColor.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                controller.getButtonText(),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildMetaTile(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }
}
