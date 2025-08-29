import 'package:mains/app_imports.dart';
import 'main_test_controller.dart';
class MainTestForAiTest extends StatefulWidget {
  const MainTestForAiTest({super.key});

  @override
  State<MainTestForAiTest> createState() => _MainTestForAiTestState();
}

class _MainTestForAiTestState extends State<MainTestForAiTest> {
  late String testId;
  late AiTestItem testData;
  bool hasError = false;
  String errorMessage = '';
  bool _showQuestionsList = false;
  String _filterStatus = 'All';

  @override
  void initState() {
    super.initState();
    _initializeTestData();
  }

  void _initializeTestData() {
    try {
      final arguments = Get.arguments;

      if (arguments == null) {
        _handleError('❌ No test data provided');
        return;
      }

      if (arguments is AiTestItem) {
        testData = arguments;
        testId = testData.testId;
      } else if (arguments is String) {
        testId = arguments;
      } else if (arguments is Map<String, dynamic>) {
        if (arguments.containsKey('testId') &&
            arguments.containsKey('testData')) {
          testId = arguments['testId'] as String;
          testData = arguments['testData'] as AiTestItem;
        } else if (arguments.containsKey('testId')) {
          testId = arguments['testId'] as String;
        } else if (arguments.containsKey('testData')) {
          testData = arguments['testData'] as AiTestItem;
          testId = testData.testId;
        } else {
          _handleError('❌ Invalid test data format: ${arguments.runtimeType}');
          return;
        }
      } else {
        _handleError('❌ Invalid test data format: ${arguments.runtimeType}');
        return;
      }

      if (testId.isEmpty) {
        _handleError('❌ Test ID is missing or empty');
        return;
      }
    } catch (e) {
      _handleError('❌ Error initializing test data: $e');
    }
  }

  void _handleError(String message) {
    setState(() {
      hasError = true;
      errorMessage = message;
    });
  }

  Future<bool> _onWillPop() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(
              "Exit Test?",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text(
              "Are you sure you want to leave this test? Your progress may be lost.",
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(
                  "Cancel",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(ctx).pop(true);
                  final c = Get.find<MainTestForAiTestController>();
                  await c.submitAnswersToApi();
                },
                child: Text(
                  "Exit",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: CustomAppBar(title: ""),
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
        ),
      );
    }

    return GetBuilder<MainTestForAiTestController>(
      init: MainTestForAiTestController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.grey[100],
              drawer: Drawer(
                backgroundColor: Colors.white,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Obx(() {
                  final stats = controller.getAnswerStats();
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 40, bottom: 20),
                        color: Colors.red,
                        child: Center(
                          child: Text(
                            'Test Summary',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _fixedSizeBox(
                                  _legendBox(
                                    'Attempted',
                                    Colors.green,
                                    stats['Attempted'] ?? 0,
                                    isSelected: _filterStatus == 'Attempted',
                                    onTap: () {
                                      setState(() {
                                        _filterStatus =
                                            _filterStatus == 'Attempted'
                                                ? 'All'
                                                : 'Attempted';
                                      });
                                    },
                                  ),
                                ),

                                _fixedSizeBox(
                                  _legendBox(
                                    'Not attempted',
                                    Colors.orange,
                                    stats['Not_attempted'] ?? 0,
                                    isSelected:
                                        _filterStatus == 'Not_attempted',
                                    onTap: () {
                                      setState(() {
                                        _filterStatus =
                                            _filterStatus == 'Not_attempted'
                                                ? 'All'
                                                : 'Not_attempted';
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _fixedSizeBox(
                                  _legendBox(
                                    'Review',
                                    Colors.blue,
                                    stats['Review'] ?? 0,
                                    isSelected: _filterStatus == 'Review',
                                    onTap: () {
                                      setState(() {
                                        _filterStatus =
                                            _filterStatus == 'Review'
                                                ? 'All'
                                                : 'Review';
                                      });
                                    },
                                  ),
                                ),
                                _fixedSizeBox(
                                  _legendBox(
                                    'Unseen',
                                    Colors.grey,
                                    stats['Unseen'] ?? 0,
                                    isSelected: _filterStatus == 'Unseen',
                                    onTap: () {
                                      setState(() {
                                        _filterStatus =
                                            _filterStatus == 'Unseen'
                                                ? 'All'
                                                : 'Unseen';
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(thickness: 1, color: Colors.grey[300]),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showQuestionsList = !_showQuestionsList;
                                });
                              },
                              child: Icon(
                                _showQuestionsList
                                    ? Icons.list_alt
                                    : Icons.grid_view,
                                color: Colors.red[700],
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            if (_filterStatus != 'All')
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _filterStatus = 'All';
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.red),
                                  ),
                                  child: Text(
                                    'Clear filter',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Divider(thickness: 1, color: Colors.grey[300]),
                      Expanded(
                        child: Obx(() {
                          if (controller.isLoading.value) {
                            return Center(
                              child: Lottie.asset(
                                'assets/lottie/book_loading.json',
                                height: 200,
                                width: 200,
                                delegates: LottieDelegates(
                                  values: [
                                    ValueDelegate.color([
                                      '**',
                                    ], value: Colors.red),
                                  ],
                                ),
                              ),
                            );
                          }

                          final allIndices = List<int>.generate(
                            controller.questions.length,
                            (i) => i,
                          );
                          final filteredIndices =
                              _filterStatus == 'All'
                                  ? allIndices
                                  : allIndices
                                      .where(
                                        (i) =>
                                            controller.getQuestionStatus(i) ==
                                            _filterStatus,
                                      )
                                      .toList();

                          if (_showQuestionsList) {
                            return ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              itemCount: filteredIndices.length,
                              separatorBuilder:
                                  (_, __) => Divider(
                                    thickness: 1,
                                    color: Colors.grey[300],
                                  ),
                              itemBuilder: (ctx, index) {
                                final actualIndex = filteredIndices[index];
                                final q = controller.questions[actualIndex];
                                final String questionText =
                                    (q['question'] ?? '').toString();
                                final String status = controller
                                    .getQuestionStatus(actualIndex);
                                final Color statusColor = getStatusColor(
                                  status,
                                );
                                return ListTile(
                                  dense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    controller.jumpToQuestion(actualIndex);
                                  },
                                  leading: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: statusColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  title: Text(
                                    questionText,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: statusColor.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            color: statusColor,
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          status,
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            color: statusColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${actualIndex + 1}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }

                          return SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: List.generate(
                                  filteredIndices.length,
                                  (visibleIdx) {
                                    final index = filteredIndices[visibleIdx];
                                    String status = controller
                                        .getQuestionStatus(index);
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        controller.jumpToQuestion(index);
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: getStatusColor(status),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.1,
                                              ),
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${index + 1}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                }),
              ),
              appBar: AppBar(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                title: Obx(() {
                  if (controller.timeRemaining.value <= 0 &&
                      controller.isLoading.value) {
                    return Row(
                      children: [
                        Icon(Icons.timer, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          '',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  }

                  Color timeColor = Colors.white;
                  if (controller.timeRemaining.value <= 60) {
                    timeColor = Colors.red[300]!;
                  } else if (controller.timeRemaining.value <= 300) {
                    timeColor = Colors.white;
                  }

                  return Row(
                    children: [
                      Icon(Icons.timer, color: timeColor),
                      SizedBox(width: 8),
                      Text(
                        controller.getFormattedTime(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: timeColor,
                        ),
                      ),
                    ],
                  );
                }),
                backgroundColor: CustomColors.primaryColor,
                elevation: 4,
                actions: [
                  Obx(() {
                    if (controller.questions.isEmpty) return SizedBox();

                    return GestureDetector(
                      onTap: () {
                        controller.submitTest(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: Get.width * 0.03),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Submit Test",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
              body: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 100),
                      child: Lottie.asset(
                        'assets/lottie/book_loading.json',
                        height: 200,
                        width: 200,
                        delegates: LottieDelegates(
                          values: [
                            ValueDelegate.color(['**'], value: Colors.red),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                if (controller.questions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          "No Test Questions Available",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          label: Text("Go Back"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return PageView.builder(
                  controller: controller.pageController,
                  itemCount: controller.questions.length,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    controller.currentQuestionIndex.value = index;
                    controller.markSeen(index);
                  },
                  itemBuilder: (context, index) {
                    final question = controller.questions[index];

                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 6,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red[100],
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            'Question ${index + 1}/${controller.questions.length}',
                                            style: GoogleFonts.poppins(
                                              color: Colors.red[800],
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Obx(() {
                                          String status = controller
                                              .getQuestionStatus(index);
                                          return Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: getStatusColor(
                                                status,
                                              ).withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: getStatusColor(status),
                                                width: 1,
                                              ),
                                            ),
                                            child: Text(
                                              status.replaceAll('_', ' '),
                                              style: GoogleFonts.poppins(
                                                color: getStatusColor(status),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          );
                                        }),
                                      ],
                                    ),

                                    SizedBox(height: 16),
                                    Text(
                                      question['question'],
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Spacer(),
                                        InkWell(
                                          onTap: () {
                                            controller.selectedAnswers[index] =
                                                null;
                                            controller.selectedAnswers
                                                .refresh();
                                            controller.questionStatuses[index] =
                                                'Not_attempted';
                                            controller.questionStatuses
                                                .refresh();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.orange.withOpacity(
                                                0.1,
                                              ),
                                              border: Border.all(
                                                color: Colors.orange,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              'Clear',
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.orange,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Obx(() {
                                      final selectedOption =
                                          controller.selectedAnswers[index];
                                      return ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: 4,
                                        itemBuilder: (context, i) {
                                          return Card(
                                            color: Colors.white,
                                            margin: EdgeInsets.only(bottom: 12),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              side: BorderSide(
                                                color:
                                                    selectedOption == i
                                                        ? Colors.red[700]!
                                                        : Colors.grey[300]!,
                                                width: 1.5,
                                              ),
                                            ),
                                            child: RadioListTile<int>(
                                              title: Text(
                                                question['options'][i],
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              value: i,
                                              groupValue: selectedOption,
                                              onChanged: (value) {
                                                controller
                                                        .selectedAnswers[index] =
                                                    value;
                                                controller.selectedAnswers
                                                    .refresh();
                                              },
                                              activeColor: Colors.red[700],
                                              contentPadding: EdgeInsets.only(
                                                right: 16,
                                              ),
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
                                            ),
                                          );
                                        },
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (index > 0)
                                OutlinedButton.icon(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.red,
                                  ),
                                  label: Text(
                                    'Previous',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red[700],
                                    side: BorderSide(color: Colors.red[700]!),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                  onPressed: controller.prevQuestion,
                                ),
                              Spacer(),
                              ElevatedButton.icon(
                                icon: Icon(
                                  index == controller.questions.length - 1
                                      ? Icons.send
                                      : Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  index == controller.questions.length - 1
                                      ? "Submit"
                                      : "Next",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red[700],
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  if (index < controller.questions.length - 1) {
                                    controller.nextQuestion();
                                  } else {
                                    controller.submitTest(context);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        );
      },
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Attempted':
        return Colors.green;
      case 'Not_attempted':
        return Colors.orange;
      case 'Review':
        return Colors.blue;
      case 'Unseen':
      default:
        return Colors.grey;
    }
  }

  Widget _fixedSizeBox(Widget child) {
    return SizedBox(
      width: Get.width * 0.3,
      height: Get.width * 0.2,
      child: child,
    );
  }

  Widget _legendBox(
    String label,
    Color color,
    int count, {
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    final bg = isSelected ? color.withOpacity(0.18) : color.withOpacity(0.1);
    final borderColor = isSelected ? color : color.withOpacity(0.3);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: isSelected ? 1.5 : 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$count',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Flexible(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
