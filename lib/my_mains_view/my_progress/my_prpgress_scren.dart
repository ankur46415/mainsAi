import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyProgressScreen extends StatefulWidget {
  const MyProgressScreen({super.key});

  @override
  State<MyProgressScreen> createState() => _MyProgressScreenState();
}

class _MyProgressScreenState extends State<MyProgressScreen> {
  final List<_ChartData> data = [
    _ChartData('BPSC', 35, Colors.blue),
    _ChartData('UPPCS', 45, Colors.orange),
    _ChartData('MPPCS', 20, Colors.green),
  ];

  String selectedExam = 'BPSC';
  final Map<String, double> overallCompletion = {
    'BPSC': 72,
    'UPPCS': 58,
    'MPPCS': 41,
  };
  final Map<String, double> accuracy = {'BPSC': 68, 'UPPCS': 61, 'MPPCS': 54};
  final Map<String, int> attempts = {'BPSC': 24, 'UPPCS': 17, 'MPPCS': 9};
  final Map<String, List<_BarData>> subjectWise = {
    'BPSC': [
      _BarData('GS1', 65),
      _BarData('GS2', 72),
      _BarData('GS3', 58),
      _BarData('GS4', 80),
    ],
    'UPPCS': [
      _BarData('GS1', 52),
      _BarData('GS2', 60),
      _BarData('GS3', 47),
      _BarData('GS4', 71),
    ],
    'MPPCS': [
      _BarData('GS1', 40),
      _BarData('GS2', 46),
      _BarData('GS3', 38),
      _BarData('GS4', 55),
    ],
  };

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
      appBar: AppBar(title: const Text("UPSC Progress"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // Top hero progress card (blue gradient)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF6B6B),
                    Color(0xFFFF8E53),
                    Color(0xFFFFC107),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  // Deep drop shadow for 3D lift
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 24,
                    spreadRadius: 2,
                    offset: const Offset(0, 12),
                  ),
                  // Subtle top highlight for beveled feel
                  BoxShadow(
                    color: Colors.white.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, -2),
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
                          '${overallCompletion[selectedExam]?.toStringAsFixed(0)}% Complete',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      _ExamToggle(
                        selected: selectedExam,
                        onChanged: (v) => setState(() => selectedExam = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (overallCompletion[selectedExam] ?? 0) / 100,
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
                            '${attempts[selectedExam]}',
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
                            '${accuracy[selectedExam]?.toStringAsFixed(0)}%',
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
                          (overallCompletion['BPSC']! +
                                  overallCompletion['UPPCS']! +
                                  overallCompletion['MPPCS']!) /
                              3,
                          gradientColors[0],
                        ),
                        _ChartData(
                          'Remaining',
                          100 -
                              ((overallCompletion['BPSC']! +
                                      overallCompletion['UPPCS']! +
                                      overallCompletion['MPPCS']!) /
                                  3),
                          remainingColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Expanded(
                //   child: _CardShell(
                //     title: 'Overall',
                //     child: _PieChartCard(
                //       slices: [
                //         _ChartData(
                //           'Done',
                //           (overallCompletion['BPSC']! +
                //                   overallCompletion['UPPCS']! +
                //                   overallCompletion['MPPCS']!) /
                //               3,
                //           gradientColors[0],
                //         ),
                //         _ChartData(
                //           'Remaining',
                //           100 -
                //               ((overallCompletion['BPSC']! +
                //                       overallCompletion['UPPCS']! +
                //                       overallCompletion['MPPCS']!) /
                //                   3),
                //           remainingColor,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(width: 12),
                Expanded(
                  child: _CardShell(
                    title: 'BPSC',
                    child: _PieChartCard(
                      slices: [
                        _ChartData(
                          'Done',
                          overallCompletion['BPSC']!.toDouble(),
                          gradientColors[1],
                        ),
                        _ChartData(
                          'Remaining',
                          100 - overallCompletion['BPSC']!,
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
                          overallCompletion['UPPCS']!.toDouble(),
                          gradientColors[2],
                        ),
                        _ChartData(
                          'Remaining',
                          100 - overallCompletion['UPPCS']!,
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
                      selected: selectedExam,
                      onChanged: (v) => setState(() => selectedExam = v),
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
                      series: <CartesianSeries<_BarData, String>>[
                        ColumnSeries<_BarData, String>(
                          dataSource: subjectWise[selectedExam] ?? [],
                          xValueMapper: (_BarData d, _) => d.label,
                          yValueMapper: (_BarData d, _) => d.value,
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

class _BarData {
  final String label;
  final double value;
  _BarData(this.label, this.value);
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
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
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
                      color: isSel ? Colors.blue[700] : Colors.white,
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
        gradient: LinearGradient(
          colors: [scheme.surface, scheme.surfaceVariant.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          // Primary drop shadow for depth
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 18,
            spreadRadius: 1,
            offset: const Offset(0, 10),
          ),
          // Soft top-left highlight for 3D bevel
          BoxShadow(
            color: Colors.white.withOpacity(0.70),
            blurRadius: 6,
            offset: const Offset(-2, -2),
          ),
        ],
        border: Border.all(color: scheme.outlineVariant.withOpacity(0.6)),
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

// Removed old _chip helper
