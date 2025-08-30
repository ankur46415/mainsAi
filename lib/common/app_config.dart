class AppConfig {
  // App Information
  static const String appName = 'Mains';
  static const String appId = 'com.mains.ai'; // Replace with your actual app ID
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=';
  
  // API Configuration
  static const String baseUrl = 'https://your-api-domain.com'; // Replace with your API domain
  static const String versionCheckEndpoint = '/api/app-version';
  
  // Update Configuration
  static const bool enableAutoUpdateCheck = true;
  static const Duration updateCheckDelay = Duration(seconds: 2);
  static const Duration updateCheckInterval = Duration(days: 1);
  
  // Force Update Configuration
  static const bool enableForceUpdate = false; // Set to true to force updates
  static const String minimumRequiredVersion = '1.0.0'; // Minimum version required
  
  // Update Dialog Configuration
  static const String updateDialogTitle = 'Update Available';
  static const String updateDialogBody = 'A new version of Mains is available. Would you like to update now?';
  static const String updateButtonText = 'Update Now';
  static const String laterButtonText = 'Later';
  static const String ignoreButtonText = 'Ignore';
}
