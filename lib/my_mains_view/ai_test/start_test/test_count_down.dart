import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TestCountdownChip extends StatefulWidget {
  final dynamic startsAt;
  final dynamic endsAt;
  const TestCountdownChip({super.key, this.startsAt, this.endsAt});

  @override
  State<TestCountdownChip> createState() => _TestCountdownChipState();
}

class _TestCountdownChipState extends State<TestCountdownChip> {
  late DateTime? _start;
  late DateTime? _end;
  late Timer _timer;
  Duration? _diff;
  String _label = '';

  @override
  void initState() {
    super.initState();
    _start =
        widget.startsAt != null
            ? DateTime.tryParse(widget.startsAt.toString())
            : null;
    _end =
        widget.endsAt != null
            ? DateTime.tryParse(widget.endsAt.toString())
            : null;
    _updateCountdown();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateCountdown(),
    );
  }

  void _updateCountdown() {
    final now = DateTime.now();
    if (_start != null && now.isBefore(_start!)) {
      _diff = _start!.difference(now);
      _label = 'Starts in: ' + _formatDuration(_diff!);
    } else if (_start != null &&
        (now.isAtSameMomentAs(_start!) || now.isAfter(_start!))) {
      // Test has Available
      if (_end != null && now.isBefore(_end!)) {
        _diff = null;
        _label = 'Available';
      } else {
        _diff = null;
        _label = 'Closed';
      }
    } else {
      // No start provided; fallback to end if available
      if (_end != null && now.isBefore(_end!)) {
        _diff = null;
        _label = 'Available';
      } else {
        _diff = null;
        _label = 'Closed';
      }
    }
    if (mounted) setState(() {});
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
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNeutral = _label == 'Available' || _label == 'Closed';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isNeutral ? Colors.grey[300] : Colors.blue[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _label,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class TestCountdownDisplay extends StatefulWidget {
  final DateTime? startsAt;
  final DateTime? endsAt;

  const TestCountdownDisplay({super.key, this.startsAt, this.endsAt});

  @override
  State<TestCountdownDisplay> createState() => _TestCountdownDisplayState();
}

class _TestCountdownDisplayState extends State<TestCountdownDisplay> {
  late Timer _timer;
  late Duration _remaining;
  String _label = 'Coming Soon';

  @override
  void initState() {
    super.initState();
    _remaining = _calcRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _remaining = _calcRemaining());
      }
    });
  }

  Duration _calcRemaining() {
    final now = DateTime.now();

    if (widget.startsAt != null && now.isBefore(widget.startsAt!)) {
      _label = 'Starts in';
      return widget.startsAt!.difference(now);
    } else {
      _label = 'Available';
      return Duration.zero;
    }
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _remaining.inDays;
    final hours = _remaining.inHours % 24;
    final minutes = _remaining.inMinutes % 60;
    final seconds = _remaining.inSeconds % 60;

    if (_label == 'Available' || _label == 'Closed') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          _label,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.green,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _timeBlock(days.toString().padLeft(2, '0')),
              _colon(),
              _timeBlock(_two(hours)),
              _colon(),
              _timeBlock(_two(minutes)),
              _colon(),
              _timeBlock(_two(seconds)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _colon() {
    return Text(
      ":",
      style: GoogleFonts.poppins(
        fontSize: 9,
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _timeBlock(String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
