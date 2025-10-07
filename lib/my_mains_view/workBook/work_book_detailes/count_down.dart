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
  late String controllerTag;

  @override
  void initState() {
    super.initState();
    controllerTag = UniqueKey().toString();
    controller = Get.put(CountdownChipController(), tag: controllerTag);
    controller.initializeCountdown(widget.startsAt, widget.endsAt);
  }

  @override
  void dispose() {
    Get.delete<CountdownChipController>(tag: controllerTag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Text(
        controller.label.value,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
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
  late String controllerTag;

  @override
  void initState() {
    super.initState();
    controllerTag = UniqueKey().toString();
    controller = Get.put(CountdownDisplayController(), tag: controllerTag);
    controller.initializeCountdown(widget.startsAt, widget.endsAt);
  }

  @override
  void dispose() {
    Get.delete<CountdownDisplayController>(tag: controllerTag);
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

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _timeBlockWithLabel(days.toString(), "D"),
            _separator(),
            _timeBlockWithLabel(controller.twoDigits(hours), "H"),
            _separator(),
            _timeBlockWithLabel(controller.twoDigits(minutes), "M"),
            _separator(),
            _timeBlockWithLabel(controller.twoDigits(seconds), "S"),
          ],
        ),
      );
    });
  }

  Widget _separator() {
    return Container(
      width: 1,
      height: 20,
      color: Colors.grey[300],
      margin: const EdgeInsets.symmetric(horizontal: 3),
    );
  }

  Widget _timeBlockWithLabel(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 7,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
