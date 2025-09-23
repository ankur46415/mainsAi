import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class EmailLauncher {
  static Future<bool> launchEmail({
    required String emailAddress,
    String? subject,
    String? body,
    bool showFallbackDialog = false,
  }) async {
    debugPrint("🚀 Starting email launch process...");
    debugPrint("📧 Email: $emailAddress");
    debugPrint("📝 Subject: $subject");
    debugPrint("📄 Body: $body");
    final List<Uri> emailUris = [
      Uri.parse('mailto:$emailAddress?subject=${Uri.encodeComponent(subject ?? '')}&body=${Uri.encodeComponent(body ?? '')}'),
      
      Uri(scheme: 'mailto', path: emailAddress, query: 'subject=${Uri.encodeComponent(subject ?? '')}&body=${Uri.encodeComponent(body ?? '')}'),
      
      Uri.parse('mailto:$emailAddress'),
    ];

    for (int i = 0; i < emailUris.length; i++) {
      final Uri emailUri = emailUris[i];
      try {
        debugPrint("🟢 Trying email URI ${i + 1}: $emailUri");
        
        final bool canLaunch = await canLaunchUrl(emailUri);
        debugPrint("🟡 Can launch email URI ${i + 1}: $canLaunch");

        if (canLaunch) {
          debugPrint("✅ Attempting to launch email app...");
          final bool launched = await launchUrl(
            emailUri, 
            mode: LaunchMode.externalApplication,
          );
          
          if (launched) {
            debugPrint("✅ Email client launched successfully!");
            return true;
          } else {
            debugPrint("❌ Email client failed to launch.");
          }
        } else {
          debugPrint("❌ Cannot launch URI ${i + 1}");
        }
      } catch (e) {
        debugPrint("🔴 Exception with URI ${i + 1}: $e");
        continue;
      }
    }

    if (showFallbackDialog) {
      _showSimpleFallbackDialog(emailAddress);
    } else {
      Get.snackbar(
        'No Email App',
        'No email app found on your device. Please install Gmail or another email app.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }

    return false;
  }

  static void _showSimpleFallbackDialog(String emailAddress) {
    Get.dialog(
      AlertDialog(
        title: const Text('No Email App Found'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('No email app is configured on your device.'),
            const SizedBox(height: 8),
            Text('Email: $emailAddress'),
            const SizedBox(height: 12),
            const Text('Please install Gmail or another email app from Play Store.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              _copyEmailToClipboard(emailAddress);
            },
            child: const Text('Copy Email'),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  static void _copyEmailToClipboard(String email) {
    Clipboard.setData(ClipboardData(text: email));
    Get.snackbar(
      'Copied!',
      'Email address copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  static Future<bool> isEmailAppAvailable() async {
    debugPrint("🔍 Checking email app availability...");
    
    const String testEmail = 'test@example.com';
    final List<Uri> testUris = [
      Uri.parse('mailto:$testEmail'),
      Uri(scheme: 'mailto', path: testEmail),
    ];

    for (int i = 0; i < testUris.length; i++) {
      try {
        debugPrint("🔍 Testing URI ${i + 1}: ${testUris[i]}");
        final bool canLaunch = await canLaunchUrl(testUris[i]);
        debugPrint("🔍 Can launch test URI ${i + 1}: $canLaunch");
        
        if (canLaunch) {
          debugPrint("✅ Email app found!");
          return true;
        }
      } catch (e) {
        debugPrint("🔴 Exception testing URI ${i + 1}: $e");
        continue;
      }
    }
    
    debugPrint("❌ No email app found");
    return false;
  }

  static Future<bool> launchEmailDirect({
    required String emailAddress,
    String? subject,
    String? body,
  }) async {
    debugPrint("🚀 Attempting to launch email to: $emailAddress");
    debugPrint("📧 Subject: $subject");
    debugPrint("📝 Body: $body");
    
    return await launchEmail(
      emailAddress: emailAddress,
      subject: subject,
      body: body,
      showFallbackDialog: false,
    );
  }

  static Future<bool> launchPhoneDialer({
    required String phoneNumber,
    bool showFallbackDialog = false,
  }) async {
    debugPrint("📞 Starting phone dialer launch...");
    debugPrint("📱 Phone: $phoneNumber");

    final List<Uri> phoneUris = [
      Uri.parse('tel:$phoneNumber'),
      Uri.parse('tel:${phoneNumber.replaceAll(' ', '')}'),
      Uri(scheme: 'tel', path: phoneNumber),
    ];

    for (int i = 0; i < phoneUris.length; i++) {
      final Uri phoneUri = phoneUris[i];
      try {
        debugPrint("🟢 Trying phone URI ${i + 1}: $phoneUri");
        
        final bool canLaunch = await canLaunchUrl(phoneUri);
        debugPrint("🟡 Can launch phone URI ${i + 1}: $canLaunch");

        if (canLaunch) {
          debugPrint("✅ Attempting to launch phone dialer...");
          final bool launched = await launchUrl(
            phoneUri, 
            mode: LaunchMode.externalApplication,
          );
          
          if (launched) {
            debugPrint("✅ Phone dialer launched successfully!");
            return true;
          } else {
            debugPrint("❌ Phone dialer failed to launch.");
          }
        } else {
          debugPrint("❌ Cannot launch phone URI ${i + 1}");
        }
      } catch (e) {
        debugPrint("🔴 Exception with phone URI ${i + 1}: $e");
        continue;
      }
    }

    if (showFallbackDialog) {
      _showPhoneFallbackDialog(phoneNumber);
    } else {
      Get.snackbar(
        'No Phone Dialer',
        'No phone dialer found on your device.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }

    return false;
  }

  static void _showPhoneFallbackDialog(String phoneNumber) {
    Get.dialog(
      AlertDialog(
        title: const Text('No Phone Dialer Found'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('No phone dialer is configured on your device.'),
            const SizedBox(height: 8),
            Text('Phone: $phoneNumber'),
            const SizedBox(height: 12),
            const Text('Please use your phone\'s default dialer app.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              _copyPhoneToClipboard(phoneNumber);
            },
            child: const Text('Copy Phone'),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  static void _copyPhoneToClipboard(String phone) {
    Clipboard.setData(ClipboardData(text: phone));
    Get.snackbar(
      'Copied!',
      'Phone number copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  static Future<void> testEmailLaunch() async {
    debugPrint("🧪 Testing email launch functionality...");
    
    final isAvailable = await isEmailAppAvailable();
    debugPrint("📱 Email app available: $isAvailable");
    
    if (isAvailable) {
      final result = await launchEmailDirect(
        emailAddress: 'test@example.com',
        subject: 'Test Email',
        body: 'This is a test email.',
      );
      debugPrint("✅ Test email launch result: $result");
    } else {
      debugPrint("❌ No email app available for testing");
    }
  }

  static Future<void> testPhoneDialer() async {
    debugPrint("🧪 Testing phone dialer functionality...");
    
    final result = await launchPhoneDialer(
      phoneNumber: '+918888888888',
    );
    debugPrint("✅ Test phone dialer result: $result");
  }

  static Future<void> getEmailAppInfo() async {
    debugPrint("📋 Getting email app information...");
    
    final isAvailable = await isEmailAppAvailable();
    debugPrint("📱 Email app available: $isAvailable");
    
    if (isAvailable) {
      debugPrint("✅ Email app is detected on device");
    } else {
      debugPrint("❌ No email app detected");
      debugPrint("💡 Try installing Gmail from Play Store");
    }
  }
} 