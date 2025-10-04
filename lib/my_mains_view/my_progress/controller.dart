import 'package:flutter/material.dart';

class MyProgressController extends ChangeNotifier {
  String _selectedExam = 'BPSC';
  
  // Progress data
  final Map<String, double> _overallCompletion = {
    'BPSC': 72,
    'UPPCS': 58,
    'MPPCS': 41,
  };
  
  final Map<String, double> _accuracy = {
    'BPSC': 68, 
    'UPPCS': 61, 
    'MPPCS': 54
  };
  
  final Map<String, int> _attempts = {
    'BPSC': 24, 
    'UPPCS': 17, 
    'MPPCS': 9
  };
  
  final Map<String, List<BarData>> _subjectWise = {
    'BPSC': [
      BarData('GS1', 65),
      BarData('GS2', 72),
      BarData('GS3', 58),
      BarData('GS4', 80),
    ],
    'UPPCS': [
      BarData('GS1', 52),
      BarData('GS2', 60),
      BarData('GS3', 47),
      BarData('GS4', 71),
    ],
    'MPPCS': [
      BarData('GS1', 40),
      BarData('GS2', 46),
      BarData('GS3', 38),
      BarData('GS4', 55),
    ],
  };

  // Getters
  String get selectedExam => _selectedExam;
  Map<String, double> get overallCompletion => _overallCompletion;
  Map<String, double> get accuracy => _accuracy;
  Map<String, int> get attempts => _attempts;
  Map<String, List<BarData>> get subjectWise => _subjectWise;
  
  // Get current exam data
  double get currentCompletion => _overallCompletion[_selectedExam] ?? 0;
  double get currentAccuracy => _accuracy[_selectedExam] ?? 0;
  int get currentAttempts => _attempts[_selectedExam] ?? 0;
  List<BarData> get currentSubjectWise => _subjectWise[_selectedExam] ?? [];

  // Methods
  void selectExam(String exam) {
    if (_selectedExam != exam) {
      _selectedExam = exam;
      notifyListeners();
    }
  }

  // Calculate overall average completion
  double get overallAverageCompletion {
    final values = _overallCompletion.values.toList();
    return values.reduce((a, b) => a + b) / values.length;
  }

  // Get remaining percentage for current exam
  double get currentRemaining => 100 - currentCompletion;

  // Get overall remaining percentage
  double get overallRemaining => 100 - overallAverageCompletion;
}

class BarData {
  final String label;
  final double value;
  
  BarData(this.label, this.value);
}
