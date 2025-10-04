import 'dart:async';
import 'package:mains/app_imports.dart';

class CountdownChipController extends GetxController {
  late DateTime? _start;
  late DateTime? _end;
  late Timer _timer;
  var diff = Rxn<Duration>();
  var label = ''.obs;

  void initializeCountdown(dynamic startsAt, dynamic endsAt) {
    _start = startsAt != null ? DateTime.tryParse(startsAt.toString()) : null;
    _end = endsAt != null ? DateTime.tryParse(endsAt.toString()) : null;
    
    // Use WidgetsBinding to ensure we're not in the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateCountdown();
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => _updateCountdown(),
      );
    });
  }

  void _updateCountdown() {
    final now = DateTime.now();
    if (_start != null && now.isBefore(_start!)) {
      diff.value = _start!.difference(now);
      label.value = 'Starts in: ' + _formatDuration(diff.value!);
    } else if (_start != null &&
        (now.isAtSameMomentAs(_start!) || now.isAfter(_start!))) {
      // Test has Available
      if (_end != null && now.isBefore(_end!)) {
        diff.value = null;
        label.value = 'Available';
      } else {
        diff.value = null;
        label.value = 'Closed';
      }
    } else {
      // No start provided; fallback to end if available
      if (_end != null && now.isBefore(_end!)) {
        diff.value = null;
        label.value = 'Available';
      } else {
        diff.value = null;
        label.value = 'Closed';
      }
    }
  }

  String _formatDuration(Duration d) {
    if (d.inDays > 0) {
      return '${d.inDays}d ${d.inHours % 24}h ${d.inMinutes % 60}m';
    } else if (d.inHours > 0) {
      return '${d.inHours}h ${d.inMinutes % 60}m ${d.inSeconds % 60}s';
    } else {
      return '${d.inMinutes}m ${d.inSeconds % 60}s';
    }
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}

class CountdownDisplayController extends GetxController {
  late Timer _timer;
  var remaining = Duration.zero.obs;
  var label = 'Coming Soon'.obs;
  DateTime? _startsAt;

  void initializeCountdown(DateTime? startsAt, DateTime? endsAt) {
    _startsAt = startsAt;
    // Note: endsAt parameter is kept for future use but not currently used
    
    // Use WidgetsBinding to ensure we're not in the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      remaining.value = _calcRemaining();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        remaining.value = _calcRemaining();
      });
    });
  }

  Duration _calcRemaining() {
    final now = DateTime.now();

    if (_startsAt != null && now.isBefore(_startsAt!)) {
      label.value = 'Starts in';
      return _startsAt!.difference(now);
    } else {
      label.value = 'Available';
      return Duration.zero;
    }
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
