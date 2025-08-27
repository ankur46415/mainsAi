import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final bool readOnly;
  final String? hintText;
  final String? labelText;
  final int maxLines;
  final TextStyle? style;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({
    Key? key,
    this.controller,
    this.initialValue,
    this.readOnly = false,
    this.hintText,
    this.labelText,
    this.maxLines = 1,
    this.style,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      readOnly: readOnly,
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        hintText: hintText,
        // Remove label text completely
        labelText: null,
        hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
        // Remove labelStyle since no label
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: Colors.grey.shade300), // Same as enabled
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      style: style ??
          GoogleFonts.poppins(fontSize: 14, color: Colors.grey[800]),
    );
  }
}