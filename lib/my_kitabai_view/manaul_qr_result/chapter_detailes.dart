import '../../app_imports.dart';

class ChapterDetails extends StatelessWidget {
  const ChapterDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: CustomColors.meeting,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Topic',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: CustomColors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: CustomColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded, color: CustomColors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              // Progress Card
              _buildProgressCard(context),
              const SizedBox(height: 24),

              // Chapters List
              Column(
                children: [
                  _buildChapterCard(
                    context,
                    chapterNumber: 1,
                    title: 'Integers',
                    progress: 0.65,
                    items: [
                      'Recall',
                      'Properties Of Addition And Subtraction',
                      'Multiplication Of Integers',
                      'Properties Of Multiplication Of Integers',
                      'Division Of Integers',
                      'Properties Of Division Of Integers',
                    ],
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  _buildChapterCard(
                    context,
                    chapterNumber: 2,
                    title: 'Fractions and Decimals',
                    progress: 0.30,
                    items: [
                      'Understanding Fractions',
                      'Operations on Fractions',
                      'Decimals and Their Operations',
                    ],
                    color: Colors.purple,
                  ),
                  const SizedBox(height: 16),
                  _buildChapterCard(
                    context,
                    chapterNumber: 3,
                    title: 'Data Handling',
                    progress: 0.10,
                    items: [
                      'Collection of Data',
                      'Organization of Data',
                      'Representation of Data',
                    ],
                    color: Colors.green,
                  ),
                  const SizedBox(height: 16),
                  _buildChapterCard(
                    context,
                    chapterNumber: 4,
                    title: 'Simple Equations',
                    progress: 0.0,
                    items: [
                      'Introduction to Equations',
                      'Solving Equations',
                      'Practical Problems on Equations',
                    ],
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  _buildChapterCard(
                    context,
                    chapterNumber: 5,
                    title: 'Lines and Angles',
                    progress: 0.0,
                    items: [
                      'Types of Angles',
                      'Pairs of Angles',
                      'Properties of Lines',
                    ],
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.stacked_line_chart_rounded,
                  color: Colors.blue[800],
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Course Progress',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: 0.45,
            minHeight: 8,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[400]!),
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '24% Completed',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '3/12 Chapters',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChapterCard(
    BuildContext context, {
    required int chapterNumber,
    required String title,
    required double progress,
    required List<String> items,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        collapsedBackgroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$chapterNumber',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 4),
            Text(
              '${(progress * 100).toInt()}% Completed',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        children: [
          Divider(height: 1, color: Colors.grey[200]),
          ...items.map((item) => _buildTopicItem(item, color)).toList(),
        ],
      ),
    );
  }

  Widget _buildTopicItem(String title, Color color) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.play_arrow_rounded, size: 14, color: color),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
      onTap: () {
        // Handle topic selection
      },
    );
  }
}
