import 'package:mains/my_mains_view/workBook/work_book_detailes/countdown_controller.dart';
import '../../../app_imports.dart';

class CountdownChip extends StatefulWidget {
  final dynamic startsAt;
  final dynamic endsAt;
  const CountdownChip({super.key, this.startsAt, this.endsAt});

  @override
  State<CountdownChip> createState() => _CountdownChipState();
}

class _CountdownChipState extends State<CountdownChip> {
  late CountdownChipController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(CountdownChipController());
    controller.initializeCountdown(widget.startsAt, widget.endsAt);
  }

  @override
  void dispose() {
    Get.delete<CountdownChipController>();
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

class CountdownDisplay extends StatefulWidget {
  final DateTime? startsAt;
  final DateTime? endsAt;

  const CountdownDisplay({Key? key, this.startsAt, this.endsAt})
    : super(key: key);

  @override
  State<CountdownDisplay> createState() => _CountdownDisplayState();
}

class _CountdownDisplayState extends State<CountdownDisplay> {
  late CountdownDisplayController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(CountdownDisplayController());
    controller.initializeCountdown(widget.startsAt, widget.endsAt);
  }

  @override
  void dispose() {
    Get.delete<CountdownDisplayController>();
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
            borderRadius: BorderRadius.circular(12),
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
              fontSize: 10,
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
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
