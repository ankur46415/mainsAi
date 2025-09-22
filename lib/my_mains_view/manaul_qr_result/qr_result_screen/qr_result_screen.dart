import '../../../app_imports.dart';
import '../chapter_detailes.dart';

class QrResultScreen extends StatefulWidget {
  final String? qrresult;
  const QrResultScreen({super.key, this.qrresult});

  @override
  State<QrResultScreen> createState() => _QrResultScreenState();
}

class _QrResultScreenState extends State<QrResultScreen>
    with TickerProviderStateMixin {
  late QrResultController controller;

  int currentIndex = 0;
  bool showAnswer = false;

  final List<String> questions = [
    "Who is the current Chief Election Commissioner of India?",
    "What is the significance of the NITI Aayog?",
    "Explain the concept of 'Minimum Support Price' in India.",
    "What are the Fundamental Duties as per the Indian Constitution?",
    "What is the function of the Rajya Sabha in the Indian Parliament?",
  ];

  final List<String> answers = [
    "The current Chief Election Commissioner of India is Rajiv Kumar (as of 2024).",
    "NITI Aayog is a policy think tank of the Government of India, replacing the Planning Commission to provide strategic and technical advice.",
    "Minimum Support Price (MSP) is the price at which the government purchases crops from farmers to ensure minimum profit for the harvest.",
    "Fundamental Duties are a set of moral obligations for all citizens to help promote a spirit of patriotism and uphold the unity of India.",
    "The Rajya Sabha is the upper house of Parliament that represents the states and acts as a revising chamber for legislation.",
  ];

  void _nextQuestion() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        showAnswer = false;
      });
    }
  }

  void _prevQuestion() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        showAnswer = false;
      });
    }
  }

  void _toggleAnswer() {
    setState(() {
      showAnswer = !showAnswer;
    });
  }

  @override
  void initState() {
    controller = Get.put(QrResultController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: CustomColors.meeting,

          actions: [
            const Icon(Icons.qr_code_scanner_outlined, color: Colors.white),
            SizedBox(width: Get.width * 0.05),
          ],
          title: Center(
            child: Text(
              "Details",
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.blue.shade100,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.blue.shade50.withOpacity(0.8),
                            Colors.white,
                            Colors.blue.shade50.withOpacity(0.5),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Details",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(AppRoutes.chapterDetails);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade100,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: Colors.red,
                                      width: 1,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.1),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.red),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'i',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.2,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      Image.asset(
                                        'assets/images/click.png',
                                        height: Get.width * 0.06,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.book,
                                size: 18,
                                color: Colors.blue.shade600,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Chapter Name",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.subject,
                                size: 18,
                                color: Colors.blue.shade600,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Subject Name",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: SliverTabBarDelegate(
                  TabBar(
                    unselectedLabelStyle: GoogleFonts.poppins(
                      fontSize: Get.width * 0.034,
                      fontWeight: FontWeight.normal,
                    ),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.white,
                    indicatorColor: Colors.white,
                    labelStyle: GoogleFonts.poppins(
                      fontSize: Get.width * 0.034,
                      fontWeight: FontWeight.w600,
                    ),
                    tabs: const [
                      Tab(text: 'Notes'),
                      Tab(text: 'Video'),
                      Tab(text: 'Obj.Test'),
                      Tab(text: 'Sub.Test'),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              _buildNotesTab(),
              _buildVideoTab(),
              _buildQuizTab(),
              _buildSub_test(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          width: Get.width,
                          height: Get.width * 0.5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/images/bookb.png',
                              fit: BoxFit.cover,
                              // fit: ,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _iconWithText(Icons.thumb_up_alt_outlined, "Like"),
                            _iconWithText(Icons.share_outlined, "Share"),
                            Column(
                              children: [
                                Image.asset(
                                  "assets/images/whatsapp.png",
                                  height: Get.width * 0.08,
                                ),
                                SizedBox(height: Get.width * 0.01),
                                Text(
                                  "Enquiry",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),

                            // _iconWithText(
                            //   Icons.what,
                            //   "Enquiry",
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Exampel',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              ...List.generate(5, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${index + 1}.',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'This is the detailed note for topic ${index + 1}.',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 16),
              Text(
                'Summary',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'These notes cover fundamental topics on vectors, scalar fields, and their applications.',
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizTab() {
    final QrResultController quizController = Get.put(QrResultController());

    return Obx(() {
      final currentQuestion =
          quizController.questions[quizController.currentIndex.value];
      final questionNumber = quizController.currentIndex.value + 1;
      final totalQuestions = quizController.questions.length;
      final progressValue = questionNumber / totalQuestions;

      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress indicator
              Container(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Question $questionNumber/$totalQuestions',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        Text(
                          '${(progressValue * 100).toInt()}%',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progressValue,
                      minHeight: 4,
                      backgroundColor: Colors.blue.shade100,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blue.shade600,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                ),
              ),

              // Question card
              Card(
                elevation: 2,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(top: 16, bottom: 24),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question $questionNumber',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue.shade600,
                        ),
                      ),
                      SizedBox(height: Get.width * 0.0),
                      Text(
                        currentQuestion.question,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Answer options
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: currentQuestion.answers.length,
                  itemBuilder: (context, index) {
                    final isSelected =
                        quizController.selectedAnswerIndex.value == index;
                    final isCorrect = currentQuestion.correctIndex == index;
                    final isWrong = isSelected && !isCorrect;
                    final isAnswered = quizController.isAnswered.value;
                    final isActive = !isAnswered || isCorrect;

                    Color backgroundColor = Colors.white;
                    Color textColor = Colors.grey.shade800;
                    Color borderColor = Colors.grey.shade300;

                    if (isAnswered) {
                      if (isCorrect) {
                        backgroundColor = Colors.green.shade50;
                        borderColor = Colors.green.shade300;
                        textColor = Colors.green.shade800;
                      } else if (isWrong) {
                        backgroundColor = Colors.red.shade50;
                        borderColor = Colors.red.shade300;
                        textColor = Colors.red.shade800;
                      } else {
                        backgroundColor = Colors.grey.shade100;
                        textColor = Colors.grey.shade600;
                      }
                    }

                    if (isSelected && !isAnswered) {
                      backgroundColor = Colors.blue.shade50;
                      borderColor = Colors.blue.shade300;
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap:
                              isAnswered
                                  ? null
                                  : () => quizController.selectAnswer(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              border: Border.all(
                                color: borderColor,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                if (isSelected && !isAnswered)
                                  BoxShadow(
                                    color: Colors.blue.shade100,
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        isAnswered
                                            ? isCorrect
                                                ? Colors.green.shade100
                                                : isWrong
                                                ? Colors.red.shade100
                                                : Colors.grey.shade200
                                            : isSelected
                                            ? Colors.blue.shade100
                                            : Colors.grey.shade200,
                                    border: Border.all(
                                      color:
                                          isAnswered
                                              ? isCorrect
                                                  ? Colors.green
                                                  : isWrong
                                                  ? Colors.red
                                                  : Colors.grey.shade400
                                              : isSelected
                                              ? Colors.blue
                                              : Colors.grey.shade400,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      String.fromCharCode(
                                        65 + index,
                                      ), // A, B, C, D
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            isAnswered
                                                ? isCorrect
                                                    ? Colors.green.shade800
                                                    : isWrong
                                                    ? Colors.red.shade800
                                                    : Colors.grey.shade600
                                                : isSelected
                                                ? Colors.blue.shade800
                                                : Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    currentQuestion.answers[index],
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: textColor,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                                if (isAnswered && isCorrect)
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: Colors.green.shade600,
                                    size: 24,
                                  ),
                                if (isAnswered && isWrong)
                                  Icon(
                                    Icons.cancel_rounded,
                                    color: Colors.red.shade600,
                                    size: 24,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Navigation buttons
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (quizController.currentIndex.value > 0)
                      ElevatedButton(
                        onPressed: quizController.prevQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue.shade800,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.blue.shade400,
                              width: 1.5,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          'Previous',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    if (!quizController.isLastQuestion())
                      ElevatedButton(
                        onPressed:
                            quizController.isAnswered.value
                                ? quizController.nextQuestion
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shadowColor: Colors.blue.shade200,
                        ),
                        child: Text(
                          'Next Question',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    if (quizController.isLastQuestion())
                      ElevatedButton(
                        onPressed:
                            quizController.isAnswered.value
                                ? () {
                                  Get.dialog(
                                    AlertDialog(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      title: Text(
                                        'Quiz Completed!',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade800,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.blue.shade50,
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.emoji_events_rounded,
                                                size: 60,
                                                color: Colors.amber.shade600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                color: Colors.grey.shade700,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      'You scored ${quizController.correctAnswersCount.value} out of ${quizController.questions.length}\n',
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const TextSpan(
                                                  text: 'in this quiz.',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        Center(
                                          child: CustomButton(
                                            text: 'Finish',
                                            onPressed: () => Get.back(),
                                            backgroundColor:
                                                Colors.blue.shade600,
                                            textColor: Colors.white,
                                            width: null,
                                            height: 48,
                                            borderRadius: 12,
                                            elevation: 0, // Or set as needed
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 40,
                                              vertical: 12,
                                            ),
                                            textStyle: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shadowColor: Colors.green.shade200,
                        ),
                        child: Text(
                          'Submit Quiz',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSub_test() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.shade50, Colors.white],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(08.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue.shade50, Colors.white],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _prevQuestion,
                      icon: Icon(Icons.chevron_left, size: 32),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                        padding: EdgeInsets.all(8),
                      ),
                    ),

                    // Question Indicators - improved with animation potential
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(questions.length, (index) {
                            final isCurrent = index == currentIndex;
                            return GestureDetector(
                              onTap: () => setState(() => currentIndex = index),
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 6.0,
                                ),
                                width: isCurrent ? 42 : 36,
                                height: isCurrent ? 42 : 36,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color:
                                      isCurrent
                                          ? Colors.blue[600]
                                          : Colors.grey[200],
                                  shape: BoxShape.circle,
                                  border:
                                      isCurrent
                                          ? Border.all(
                                            color: Colors.blue[800]!,
                                            width: 2,
                                          )
                                          : null,
                                ),
                                child: Text(
                                  "${index + 1}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: isCurrent ? 16 : 14,
                                    color:
                                        isCurrent
                                            ? Colors.white
                                            : Colors.grey[700],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: _nextQuestion,
                      icon: Icon(Icons.chevron_right, size: 32),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                        padding: EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Card(
                elevation: 1,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey[100]!, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Question ${currentIndex + 1}",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue[800],
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "${currentIndex + 1}/${questions.length}",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Text(
                        questions[currentIndex],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),

                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 5,
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: _toggleAnswer,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  showAnswer
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  size: 20,
                                  color:
                                      showAnswer
                                          ? Colors.grey[700]
                                          : Colors.blue[600],
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  showAnswer ? "Hide Answer" : "Show Answer",
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: Get.width * 0.04),
                      if (showAnswer)
                        Card(
                          color: Colors.green[50],
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: Colors.green[100]!,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green[100],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "Answer",
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green[800],
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  answers[currentIndex],
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 1.5,
                                    color: Colors.green[900],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconWithText(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.black),
        SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
