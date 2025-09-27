import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportCard extends StatelessWidget {
  const SupportCard({super.key});
  final String supportEmail = "vijay.wiz@gmail.com";
  final String supportPhone = "+918147540362";

  void _launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(scheme: 'mailto', path: email);
    try {
      await launch(emailLaunchUri.toString());
    } catch (e) {
      if (kDebugMode) {}
    }
  }

  Future<void> _dialPhoneNumber(BuildContext context, String number) async {
    final Uri uri = Uri.parse('tel:$number');

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else if (await canLaunch(uri.toString())) {
        await launch(uri.toString());
      } else {}
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error launching dialer.")));
    }
  }

  Future<void> _launchWhatsApp(BuildContext context, String number) async {
    // Remove any non-digit characters and add country code if needed
    String cleanNumber = number.replaceAll(RegExp(r'[^\d]'), '');

    // Add country code if not present (assuming India +91)
    if (!cleanNumber.startsWith('91') && cleanNumber.length == 10) {
      cleanNumber = '91$cleanNumber';
    }

    // Try direct WhatsApp intent approach
    try {
      // Method 1: Try with specific WhatsApp package
      final Uri whatsappUri = Uri.parse('https://wa.me/$cleanNumber');

      // Check if WhatsApp is installed by trying to launch with specific package
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (e) {
      // Continue to next method
    }

    // Method 2: Try with different URL format
    try {
      final Uri alternativeUri = Uri.parse(
        'https://api.whatsapp.com/send?phone=$cleanNumber',
      );
      if (await canLaunchUrl(alternativeUri)) {
        await launchUrl(alternativeUri, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (e) {
      // Continue to fallback
    }

    // Method 3: Try with web.whatsapp.com
    try {
      final Uri webUri = Uri.parse(
        'https://web.whatsapp.com/send?phone=$cleanNumber',
      );
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (e) {
      // Continue to final fallback
    }

    // Final fallback - show dialog with manual option
    _showWhatsAppFallback(context, cleanNumber);
  }

  void _showWhatsAppFallback(BuildContext context, String number) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('WhatsApp Not Available'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('WhatsApp could not be opened directly.'),
              const SizedBox(height: 16),
              const Text('Please copy this number and open WhatsApp manually:'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '+$number',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        // Copy to clipboard
                        await Clipboard.setData(
                          ClipboardData(text: '+$number'),
                        );
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Number copied to clipboard'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 231, 212, 152),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      margin: const EdgeInsets.all(12),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.08),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey.shade50],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title with icon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.help_outline,
                      color: Colors.blue.shade600,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Not Sure What Plan To Choose?",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Support contact details
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.shade100, width: 1),
                ),
                child: Column(
                  children: [
                    _buildContactItem(
                      icon: Icons.phone_in_talk_rounded,
                      text: "8147540362",
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        _launchEmail("vijay.wiz@gmail.com");
                      },
                      child: _buildContactItem(
                        icon: Icons.mail_rounded,
                        text: "vijay.wiz@gmail.com",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.shade400.withOpacity(0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _dialPhoneNumber(
                            context,
                            supportPhone,
                          ); // call directly
                        },
                        icon: const Icon(
                          Icons.call,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: Text(
                          "Call",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.shade400.withOpacity(0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // _launchWhatsApp(context, supportPhone);
                        },
                        icon: Image.asset(
                          "assets/images/whatsapp.png",
                          width: 18, // smaller width
                          height: 18, // smaller height
                        ),

                        label: Text(
                          "WhatsApp",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.blue.shade600, size: 16),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.blue.shade700,
          ),
        ),
      ],
    );
  }
}
