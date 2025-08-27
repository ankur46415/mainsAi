import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LoadingWidget extends StatelessWidget {
  final String message;
  final Color textColor;
  final double imageHeight;

  const LoadingWidget({
    super.key,
    this.message = "",
    this.textColor = Colors.red,
    this.imageHeight = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Lottie.asset(
                'assets/lottie/book_loading.json',
                fit: BoxFit.contain,
                delegates: LottieDelegates(
                  values: [
                    ValueDelegate.color(const ['**'], value: Colors.red),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
