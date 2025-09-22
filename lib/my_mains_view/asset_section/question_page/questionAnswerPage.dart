import 'package:mains/app_imports.dart';

class Questionanswerpage extends StatefulWidget {
  @override
  State<Questionanswerpage> createState() => _QuestionanswerpageState();
}

class _QuestionanswerpageState extends State<Questionanswerpage> {
  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;

    final String question = args['question'] ?? 'No Question';
    final String answer = args['answer'] ?? 'No Answer';
    final String keywords = args['keywords'] ?? 'No Keywords';
    final int index = args['index'] ?? 0;

    final List<String> keywordList =
        keywords.isNotEmpty ? keywords.split(',') : [];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CustomAppBar(title: "Question Details"),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(
              title: "Question",
              content: question,
              gradientColors: [Colors.red.shade100, Colors.blue.shade50],
              icon: Icons.help_outline,
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              title: "Answer",
              content: answer,
              gradientColors: [Colors.redAccent.shade100, Colors.green.shade50],
              icon: Icons.lightbulb_outline,
            ),
            const SizedBox(height: 16),
            _buildKeywordCard(keywordList),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required List<Color> gradientColors,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: Colors.black54),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeywordCard(List<String> keywords) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.deepPurple.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.key, color: Colors.deepPurple),
              const SizedBox(width: 8),
              Text(
                "Keywords",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (keywords.isEmpty)
            Text(
              "No keywords available",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  keywords
                      .map(
                        (k) => Chip(
                          label: Text(
                            k.trim(),
                            style: GoogleFonts.poppins(fontSize: 12),
                          ),
                          backgroundColor: Colors.deepPurple.shade100,
                        ),
                      )
                      .toList(),
            ),
        ],
      ),
    );
  }
}
