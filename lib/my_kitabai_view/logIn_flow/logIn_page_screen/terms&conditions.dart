import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndConditionsCheckbox extends StatefulWidget {
  final bool value;
  final Function(bool) onAccepted;

  const TermsAndConditionsCheckbox({
    super.key,
    required this.value,
    required this.onAccepted,
  });

  @override
  State<TermsAndConditionsCheckbox> createState() =>
      _TermsAndConditionsCheckboxState();
}

class _TermsAndConditionsCheckboxState
    extends State<TermsAndConditionsCheckbox> {
  Future<void> _openTermsPdfAndCheck() async {
    final Uri url = Uri.parse("https://mobishaala.com/assets/files/pp.pdf");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
      widget.onAccepted(true);
    } else {
      Get.snackbar("Error", "Could not open Terms & Conditions PDF");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: widget.value,
          onChanged: (val) {
            widget.onAccepted(val ?? false);
          },
        ),
        GestureDetector(
          onTap: _openTermsPdfAndCheck,
          child: Text(
            "I accept the Terms & Conditions",
            style: const TextStyle(
              fontSize: 14,
              decoration: TextDecoration.underline,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
