import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../main_analysis/main_analytics_controller.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:share_plus/share_plus.dart';

class ModelAnswerPage extends StatefulWidget {
  const ModelAnswerPage({super.key});

  @override
  State<ModelAnswerPage> createState() => _ModelAnswerPageState();
}

class _ModelAnswerPageState extends State<ModelAnswerPage> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainAnalyticsController>();
    final modalAnswer =
        controller.answerAnalysis.value?.data?.answer?.question?.modalAnswer ??
        'No model answer available';
    final pdfList =
        controller
            .answerAnalysis
            .value
            ?.data
            ?.answer
            ?.question
            ?.modalAnswerPdf ??
        [];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Keep TabBar pinned/sticky by not placing it inside scrollable content
              Material(
                color: Colors.white,
                elevation: 1,
                child: SizedBox(
                  height: 40,
                  child: TabBar(
                    indicatorColor: Colors.blueAccent,
                    labelColor: Colors.blueAccent,
                    unselectedLabelColor: Colors.grey[600],
                    isScrollable: false, // 👈 full width equally divide
                    tabs: [
                      Tab(
                        iconMargin: EdgeInsets.zero,
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center, // 👈 center inside tab
                          children: [
                            Icon(
                              Icons.picture_as_pdf,
                              color: Colors.red[600],
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            const Text('PDF', style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                      Tab(
                        iconMargin: EdgeInsets.zero,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.text_snippet_outlined, size: 18),
                            SizedBox(width: 4),
                            Text('Text', style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // PDF TAB: show available PDFs as buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child:
                          pdfList.isEmpty
                              ? Center(
                                child: Text(
                                  'No PDF available',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              )
                              : Center(
                                child: Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: List.generate(pdfList.length, (i) {
                                    final url = pdfList[i].url ?? '';
                                    final label = 'PDF ${i + 1}';
                                    final fileName = () {
                                      try {
                                        final p = Uri.parse(url).pathSegments;
                                        final last = p.isNotEmpty ? p.last : '';
                                        return last.split('?').first;
                                      } catch (_) {
                                        return '';
                                      }
                                    }();

                                    return Tooltip(
                                      message:
                                          fileName.isEmpty ? label : fileName,
                                      child: InkWell(
                                        onTap: () {
                                          if (url.isNotEmpty) {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder:
                                                    (_) => _PdfViewerPage(
                                                      title: label,
                                                      url: url,
                                                    ),
                                              ),
                                            );
                                          }
                                        },
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          constraints: const BoxConstraints(
                                            minWidth: 160,
                                            maxWidth: 240,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.06,
                                                ),
                                                blurRadius: 8,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                            border: Border.all(
                                              color: Colors.red.shade200,
                                              width: 1.2,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: Colors.red.shade50,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.picture_as_pdf,
                                                  color: Colors.red[600],
                                                  size: 18,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      label,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.poppins(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                    ),
                                                    if (fileName.isNotEmpty)
                                                      Text(
                                                        fileName,
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        style:
                                                            GoogleFonts.poppins(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors
                                                                      .grey[600],
                                                            ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                    ),

                    // TEXT TAB (existing content)
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 3,
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(25),
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
                                        Icons.article,
                                        color: Colors.blue[800],
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      'Model Answer',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue[800],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                const Divider(height: 1, color: Colors.grey),
                                const SizedBox(height: 20),
                                Text.rich(
                                  TextSpan(
                                    children: _buildFormattedText(modalAnswer),
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      height: 1.6,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 25),

                          // Tips Card
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colors.green[50]!, Colors.teal[50]!],
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.green[100],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.lightbulb,
                                        color: Colors.green[800],
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      'Pro Tip',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green[800],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  'Compare your answer with the model answer to identify areas for improvement. Pay attention to the structure, key points, and supporting arguments.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    height: 1.5,
                                    color: Colors.green[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
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
    );
  }

  List<TextSpan> _buildFormattedText(String text) {
    final List<TextSpan> spans = [];
    final lines = text.split('\n');

    for (var line in lines) {
      if (line.trim().startsWith('**') && line.trim().endsWith('**')) {
        // Bold heading text

        spans.add(
          TextSpan(
            text: line.trim().substring(2, line.trim().length - 2) + '\n',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        );
      } else if (line.trim().startsWith('- ')) {
        // Bullet point
        spans.add(
          const TextSpan(
            text: '   • ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        );
        spans.add(TextSpan(text: line.trim().substring(2) + '\n'));
      } else {
        // Normal text
        spans.add(TextSpan(text: line.trim() + '\n'));
      }
    }

    return spans;
  }
}

class _PdfViewerPage extends StatelessWidget {
  final String title;
  final String url;
  const _PdfViewerPage({super.key, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            tooltip: 'Share',
            icon: const Icon(Icons.share_rounded),
            onPressed: () async {
              await _sharePdf(context);
            },
          ),
        ],
      ),
      body: SfPdfViewer.network(url),
    );
  }

  Future<void> _sharePdf(BuildContext context) async {
    try {
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        Get.snackbar(
          'Share',
          'Failed to fetch PDF (${response.statusCode})',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      String fileName = '';
      try {
        fileName =
            uri.pathSegments.isNotEmpty
                ? uri.pathSegments.last
                : 'document.pdf';
        fileName = fileName.split('?').first;
        if (!fileName.toLowerCase().endsWith('.pdf')) {
          fileName = '$fileName.pdf';
        }
      } catch (_) {
        fileName = 'document.pdf';
      }

      final dir = await getTemporaryDirectory();
      final filePath = p.join(dir.path, fileName);
      final file = await File(filePath).writeAsBytes(response.bodyBytes);
      await Share.shareXFiles([XFile(file.path)], text: title);
    } catch (e) {
      Get.snackbar(
        'Share',
        'Error: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
