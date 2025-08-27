import 'package:mains/app_imports.dart';
import 'package:mains/my_kitabai_view/book_detailes_page/summery/controller.dart';

class SummarySection extends StatelessWidget {
  final String? summary;
  const SummarySection({super.key, this.summary});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SummaryController());
    final String rawSummary = summary?.trim() ?? '';
    final bool hasSummary = rawSummary.isNotEmpty;
    final int trimLength = 150;

    final String summaryText =
        hasSummary ? rawSummary : 'No summary available for this book.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Summary',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        if (!hasSummary)
          Center(
            child: Text(
              summaryText,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
            ),
          )
        else
          Obx(() {
            final isExpanded = controller.isExpanded.value;

            if (!isExpanded && rawSummary.length > trimLength) {
              return RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${rawSummary.substring(0, trimLength)}... ',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    TextSpan(
                      text: 'Read more',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                      recognizer:
                          TapGestureRecognizer()..onTap = controller.expand,
                    ),
                  ],
                ),
              );
            } else {
              return RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: rawSummary + ' ',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    TextSpan(
                      text: 'Read less',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                      recognizer:
                          TapGestureRecognizer()..onTap = controller.collapse,
                    ),
                  ],
                ),
              );
            }
          }),
      ],
    );
  }
}
