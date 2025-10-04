import 'package:mains/my_mains_view/ai_test/start_test/countdown_controller.dart';
import '../../../app_imports.dart';

class TestCountdownChip extends StatefulWidget {
  final dynamic startsAt;
  final dynamic endsAt;
  const TestCountdownChip({super.key, this.startsAt, this.endsAt});

  @override
  State<TestCountdownChip> createState() => _TestCountdownChipState();
}

class _TestCountdownChipState extends State<TestCountdownChip> {
  late TestCountdownChipController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TestCountdownChipController());
    controller.initializeCountdown(widget.startsAt, widget.endsAt);
  }

  @override
  void dispose() {
    Get.delete<TestCountdownChipController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isNeutral =
          controller.label.value == 'Available' ||
          controller.label.value == 'Closed';
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isNeutral ? Colors.grey[300] : Colors.blue[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          controller.label.value,
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      );
    });
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
  late TestCountdownDisplayController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TestCountdownDisplayController());
    controller.initializeCountdown(widget.startsAt, widget.endsAt);
  }

  @override
  void dispose() {
    Get.delete<TestCountdownDisplayController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final days = controller.remaining.value.inDays;
      final hours = controller.remaining.value.inHours % 24;
      final minutes = controller.remaining.value.inMinutes % 60;
      final seconds = controller.remaining.value.inSeconds % 60;

      if (controller.label.value == 'Available' ||
          controller.label.value == 'Closed') {
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
            controller.label.value,
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
                _timeBlock(controller.twoDigits(hours)),
                _colon(),
                _timeBlock(controller.twoDigits(minutes)),
                _colon(),
                _timeBlock(controller.twoDigits(seconds)),
              ],
            ),
          ),
        ],
      );
    });
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
