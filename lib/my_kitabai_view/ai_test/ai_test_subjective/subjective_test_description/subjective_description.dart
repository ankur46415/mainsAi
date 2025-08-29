import 'package:mains/app_imports.dart';
import 'package:mains/model/ai_test_subjective.dart';

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
              // Red header card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [CustomColors.primaryColor, Colors.redAccent],
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
                    Text(
                      testData.name.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMetaTile(
                          "Time",
                          "${testData.estimatedTime ?? ''} Min",
                        ),

                        _buildMetaTile(
                          "Questions",
                          "${testData.userTestStatus?.totalQuestions ?? 0}",
                        ),
                        _buildMetaTile(
                          "Marks",
                          testData.testMaximumMarks.toString(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Description Section
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
                child: Text(
                  testData.instructions.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 14.5,
                    height: 1.5,
                    color: Colors.grey[800],
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
          onTap:
              (testData.userTestStatus?.totalQuestions ?? 0) > 0
                  ? () => Get.toNamed(
                    AppRoutes.subjectiveTestAllquestions,
                    arguments: testData.testId,
                  )
                  : null, // disables tap if totalQuestions == 0
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color:
                  (testData.userTestStatus?.totalQuestions ?? 0) > 0
                      ? CustomColors.primaryColor
                      : Colors.grey.shade400, // greyed out if 0
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: ((testData.userTestStatus?.totalQuestions ?? 0) > 0
                          ? CustomColors.primaryColor
                          : Colors.grey.shade400)
                      .withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              "Start Test Now",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
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
