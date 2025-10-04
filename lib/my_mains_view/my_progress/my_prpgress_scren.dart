import 'package:syncfusion_flutter_charts/charts.dart';

import '../../app_imports.dart';
import 'controller.dart';

class MyProgressScreen extends StatefulWidget {
  const MyProgressScreen({super.key, this.controller});

  final MyProgressController? controller;

  @override
  State<MyProgressScreen> createState() => _MyProgressScreenState();
}

class _MyProgressScreenState extends State<MyProgressScreen> {
  MyProgressController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? MyProgressController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final Color remainingColor = scheme.surfaceVariant;
    const gradientColors = [
      Color(0xFFFF6B6B),
      Color(0xFFFF8E53),
      Color(0xFFFFC107),
    ];
    return Scaffold(
      appBar: CustomAppBar(title: "My Progress"),
      body: AnimatedBuilder(
        animation: _controller!,
        builder: (context, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF2196F3),
                        Color(0xFF1976D2),
                        Color(0xFF0D47A1),
                      ],

                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF344955).withOpacity(0.1),
                        spreadRadius: 0,
                        offset: const Offset(0, 6),
                      ),
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.06),
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Progress Dashboard',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${_controller!.currentCompletion.toStringAsFixed(0)}% Complete',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          _ExamToggle(
                            selected: _controller!.selectedExam,
                            onChanged: (v) => _controller!.selectExam(v),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: _controller!.currentCompletion / 100,
                          minHeight: 10,
                          backgroundColor: Colors.white.withOpacity(0.25),
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_controller!.currentAttempts}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Attempts',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_controller!.currentAccuracy.toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Accuracy',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '80%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Target',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _CardShell(
                        title: 'Overall',
                        child: _PieChartCard(
                          slices: [
                            _ChartData(
                              'Done',
                              _controller!.overallAverageCompletion,
                              gradientColors[0],
                            ),
                            _ChartData(
                              'Remaining',
                              _controller!.overallRemaining,
                              remainingColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Get.width * 0.05),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _CardShell(
                        title: 'BPSC',
                        child: _PieChartCard(
                          slices: [
                            _ChartData(
                              'Done',
                              _controller!.overallCompletion['BPSC']!
                                  .toDouble(),
                              gradientColors[1],
                            ),
                            _ChartData(
                              'Remaining',
                              100 - _controller!.overallCompletion['BPSC']!,
                              remainingColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _CardShell(
                        title: 'UPPCS',
                        child: _PieChartCard(
                          slices: [
                            _ChartData(
                              'Done',
                              _controller!.overallCompletion['UPPCS']!
                                  .toDouble(),
                              gradientColors[2],
                            ),
                            _ChartData(
                              'Remaining',
                              100 - _controller!.overallCompletion['UPPCS']!,
                              remainingColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                // Row 2: Subject-wise bar chart with exam toggle
                _CardShell(
                  title: 'Subject-wise Performance',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: _ExamToggle(
                          selected: _controller!.selectedExam,
                          onChanged: (v) => _controller!.selectExam(v),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 220,
                        child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(
                            majorGridLines: const MajorGridLines(width: 0),
                            labelStyle: TextStyle(
                              color: scheme.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                          primaryYAxis: NumericAxis(
                            minimum: 0,
                            maximum: 100,
                            interval: 20,
                            labelStyle: TextStyle(
                              color: scheme.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                          legend: const Legend(isVisible: false),
                          series: <CartesianSeries<BarData, String>>[
                            ColumnSeries<BarData, String>(
                              dataSource: _controller!.currentSubjectWise,
                              xValueMapper: (BarData d, _) => d.label,
                              yValueMapper: (BarData d, _) => d.value,
                              color: gradientColors[1],
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6),
                              ),
                              dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
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
          );
        },
      ),
    );
  }
}

// Removed old _ProgressCard (replaced by new dashboard layout)

class _ChartData {
  final String label;
  final double value;
  final Color color;

  _ChartData(this.label, this.value, this.color);
}

class _PieChartCard extends StatelessWidget {
  final List<_ChartData> slices;
  const _PieChartCard({required this.slices});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: SfCircularChart(
        margin: EdgeInsets.zero,
        legend: const Legend(isVisible: false),
        series: <CircularSeries>[
          PieSeries<_ChartData, String>(
            dataSource: slices,
            xValueMapper: (_ChartData d, _) => d.label,
            yValueMapper: (_ChartData d, _) => d.value,
            pointColorMapper: (_ChartData d, _) => d.color,
            dataLabelMapper:
                (_ChartData d, _) =>
                    d.label == 'Remaining'
                        ? ''
                        : '${d.value.toStringAsFixed(0)}%',
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            radius: '90%',
          ),
        ],
      ),
    );
  }
}

// Removed old _KpiTile (replaced by new cards)

class _ExamToggle extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const _ExamToggle({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final items = const ['BPSC', 'UPPCS', 'MPPCS'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF344955).withOpacity(0.1),
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children:
            items.map((e) {
              final bool isSel = e == selected;
              return GestureDetector(
                onTap: () => onChanged(e),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSel ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    e,
                    style: TextStyle(
                      color: isSel ? Colors.blue[700] : Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  final String title;
  final Widget child;
  const _CardShell({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF344955).withOpacity(0.1),
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
