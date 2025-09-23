import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'app_config.dart';
import 'api_services.dart';

class AppUpdateChecker {
  static Future<void> checkForUpdates(BuildContext context) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      String? latestVersion = await _getLatestVersion();

      if (latestVersion != null &&
          _shouldUpdate(currentVersion, latestVersion)) {
        _showUpdateDialog(context, latestVersion);
      }
    } catch (e) {}
  }

  static Future<String?> _getLatestVersion() async {
    try {
      final String url = '${AppConfig.baseUrl}${AppConfig.versionCheckEndpoint}';
      String? latest;
      await callWebApiGet(
        null,
        url,
        showLoader: false,
        hideLoader: true,
        onResponse: (response) {
          final data = json.decode(response.body);
          latest = data['latest_version'];
        },
        onError: () {},
      );
      return latest;
    } catch (e) {
      return null;
    }
  }

  static bool _shouldUpdate(String currentVersion, String latestVersion) {
    List<int> current = currentVersion.split('.').map(int.parse).toList();
    List<int> latest = latestVersion.split('.').map(int.parse).toList();

    for (int i = 0; i < 3; i++) {
      if (latest[i] > current[i]) return true;
      if (latest[i] < current[i]) return false;
    }
    return false;
  }

  static void _showUpdateDialog(BuildContext context, String latestVersion) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.system_update, color: Colors.blue, size: 28),
            const SizedBox(width: 12),
            Text(
              AppConfig.updateDialogTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppConfig.updateDialogBody,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              'Latest version: $latestVersion',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text(
              'Update now to get the latest features and improvements.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              AppConfig.laterButtonText,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _openPlayStore();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              AppConfig.updateButtonText,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  static void _openPlayStore() async {
    final url = '${AppConfig.playStoreUrl}${AppConfig.appId}';
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {}
    } catch (e) {}
  }
}
