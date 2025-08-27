import 'package:google_fonts/google_fonts.dart';

import '../app_imports.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;
  final Color? iconColor;
  final double? width;
  final double height;
  final double borderRadius;
  final double elevation;
  final bool isOutlined;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final double? iconSize;
  final double gap;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.iconColor,
    this.width = double.infinity,
    this.height = 48.0,
    this.borderRadius = 12.0,
    this.elevation = 2.0,
    this.isOutlined = false,
    this.padding,
    this.textStyle,
    this.iconSize,
    this.gap = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: isOutlined
          ? OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: padding,
          backgroundColor: Colors.transparent,
          foregroundColor: backgroundColor,
          side: BorderSide(color: backgroundColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: elevation,
        ),
        child: _buildContent(),
      )
          : ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: padding,
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: elevation,
          shadowColor: backgroundColor.withOpacity(0.3),
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null)
          Icon(
            icon,
            size: iconSize ?? height * 0.5,
            color: iconColor ?? textColor,
          ),
        if (icon != null) SizedBox(width: gap),
        Text(
          text,
          style: textStyle ??
              GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
        ),
      ],
    );
  }
}