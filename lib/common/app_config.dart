class AppConfig {
  static const String appName = 'Mains';
  static const String appId = 'com.mains.ai';
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=';

  static const String baseUrl = 'https://your-api-domain.com';
  static const String versionCheckEndpoint = '/api/app-version';

  static const bool enableAutoUpdateCheck = true;
  static const Duration updateCheckDelay = Duration(seconds: 2);
  static const Duration updateCheckInterval = Duration(days: 1);

  static const bool enableForceUpdate = false;
  static const String minimumRequiredVersion = '1.0.0';

  static const String updateDialogTitle = 'Update Available';
  static const String updateDialogBody =
      'A new version of Mains is available. Would you like to update now?';
  static const String updateButtonText = 'Update Now';
  static const String laterButtonText = 'Later';
  static const String ignoreButtonText = 'Ignore';
}
