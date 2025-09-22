import 'package:mains/app_imports.dart';
import 'package:mains/models/ai_test_subjective.dart';
import 'package:mains/my_mains_view/ai_test/ai_test_subjective/subjective_test_name/test_analytics.dart';

class SubjectiveTestNamePage extends StatefulWidget {
  const SubjectiveTestNamePage({super.key});

  @override
  State<SubjectiveTestNamePage> createState() => _SubjectiveTestNamePageState();
}

class _SubjectiveTestNamePageState extends State<SubjectiveTestNamePage> {
  final GlobalKey<SlideActionState> key = GlobalKey();
  late Test testData;
  bool hasError = false;
  String errorMessage = '';
  bool _isExpanded = false;
  bool _isLongDescription = false;

  @override
  void initState() {
    super.initState();
    _initializeTestData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfLongDescription();
    });
  }

  void _initializeTestData() {
    try {
      final arguments = Get.arguments;

      if (arguments == null) {
        _handleError('No test data provided');
        return;
      }

      if (arguments is Test) {
        testData = arguments;
      } else {
        _handleError('Invalid test data format');
        return;
      }

      if (testData.testId == null || testData.testId!.isEmpty) {
        _handleError('Test ID is missing');
        return;
      }

      if (testData.name == null || testData.name!.isEmpty) {
        _handleError('Test name is missing');
        return;
      }
    } catch (e) {
      _handleError('Error initializing test data: $e');
    }
  }

  void _handleError(String message) {
    setState(() {
      hasError = true;
      errorMessage = message;
    });
  }

  void _checkIfLongDescription() {
    final buildCtx = this.context; // explicitly BuildContext use
    if (testData.description != null && testData.description!.isNotEmpty) {
      final textSpan = TextSpan(
        text: testData.description!,
        style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70),
      );

      final tp = TextPainter(
        text: textSpan,
        maxLines: 3,
        textDirection: TextDirection.ltr,
      );

      tp.layout(maxWidth: MediaQuery.of(buildCtx).size.width - 40);
      setState(() {
        _isLongDescription = tp.didExceedMaxLines;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (hasError) {
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
                  errorMessage,
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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [CustomColors.primaryColor, Colors.red.shade200],
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
                      if (testData.imageUrl != null &&
                          testData.imageUrl!.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: testData.imageUrl!,
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
                        testData.name ?? "Untitled Test",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Duration: ${testData.estimatedTime ?? 'N/A'}  |  Category: ${testData.category ?? 'N/A'}",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      if (testData.description != null &&
                          testData.description!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          testData.description!,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                          maxLines: _isExpanded ? null : 3,
                          overflow:
                              _isExpanded
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                        ),
                        if (_isLongDescription)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                _isExpanded ? "See less" : "See more",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.yellow,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                if (testData.userTestStatus?.attempted == true) ...[
                  TestAnalyticsCard(testId: testData.testId),
                  SizedBox(height: Get.width * 0.05),
                ] else if (testData.instructions != null &&
                    testData.instructions!.isNotEmpty) ...[
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
                      testData.instructions!,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  SizedBox(height: Get.width * 0.05),
                ],
                if (testData.userTestStatus?.attempted != true) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        try {
                          Get.toNamed(
                            AppRoutes.subjectiveDescription,
                            arguments: testData,
                          );
                        } catch (e) {
                          Get.snackbar(
                            'Error',
                            'Failed to navigate to test: $e',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
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
                        backgroundColor: CustomColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
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
  }
}
