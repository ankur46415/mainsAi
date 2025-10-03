import 'package:flutter/material.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'app_config.dart';

class AppUpdateChecker {
  static Future<void> checkForUpdates(BuildContext context) async {
    try {
      final newVersion = NewVersionPlus(
        androidId: AppConfig.appId, // com.mainsapp
      );

      final status = await newVersion.getVersionStatus();
      
      if (status != null && status.canUpdate) {
        newVersion.showUpdateDialog(
          context: context,
          versionStatus: status,
          dialogTitle: AppConfig.updateDialogTitle,
          dialogText: AppConfig.updateDialogBody,
          updateButtonText: AppConfig.updateButtonText,
          dismissButtonText: AppConfig.laterButtonText,
        );
      }
    } catch (e) {
      // Handle error silently
      debugPrint('Update check failed: $e');
    }
  }
}
