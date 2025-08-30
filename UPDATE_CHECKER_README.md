# App Update Checker Setup

This implementation provides automatic app update checking for your Mains AI app. When a new version is available on the Play Store, users will see an update dialog.

## Features

- ✅ Automatic update checking on app launch
- ✅ Beautiful update dialog with "Update Now" and "Later" options
- ✅ Direct link to Play Store
- ✅ Configurable settings
- ✅ Customizable dialog text
- ✅ Force update support (optional)

## Setup Instructions

### 1. Update App Configuration

Edit `lib/common/app_config.dart` and update the following values:

```dart
class AppConfig {
  // Replace with your actual app ID from Play Store
  static const String appId = 'com.mains.ai';
  
  // Replace with your API domain
  static const String baseUrl = 'https://your-api-domain.com';
  
  // Update dialog text (optional)
  static const String updateDialogTitle = 'Update Available';
  static const String updateDialogBody = 'A new version of Mains  is available. Would you like to update now?';
}
```

### 2. Create API Endpoint

Create an API endpoint at `https://your-api-domain.com/api/app-version` that returns:

```json
{
  "latest_version": "1.0.2",
  "force_update": false,
  "minimum_version": "1.0.0",
  "update_message": "Bug fixes and performance improvements"
}
```

### 3. Update pubspec.yaml

The following dependencies are already added:
- `upgrader: ^11.5.0`
- `package_info_plus` (already in your project)
- `http` (already in your project)
- `url_launcher` (already in your project)

### 4. How It Works

1. **App Launch**: When the app starts, it waits 2 seconds then checks for updates
2. **Version Check**: Compares current app version with latest version from your API
3. **Update Dialog**: If a newer version is available, shows a beautiful dialog
4. **Play Store**: "Update Now" button opens your app on Play Store

### 5. Customization Options

#### Enable/Disable Auto Check
```dart
static const bool enableAutoUpdateCheck = true;
```

#### Change Check Interval
```dart
static const Duration updateCheckInterval = Duration(days: 1);
```

#### Force Updates
```dart
static const bool enableForceUpdate = false;
static const String minimumRequiredVersion = '1.0.0';
```

#### Custom Dialog Text
```dart
static const String updateDialogTitle = 'Update Available';
static const String updateDialogBody = 'A new version is available!';
static const String updateButtonText = 'Update Now';
static const String laterButtonText = 'Later';
```

### 6. API Response Format

Your API should return a JSON response like this:

```json
{
  "latest_version": "1.0.2",
  "force_update": false,
  "minimum_version": "1.0.0",
  "update_message": "Bug fixes and performance improvements",
  "download_url": "https://play.google.com/store/apps/details?id=com.mains.ai"
}
```

### 7. Testing

To test the update checker:

1. **Change your app version** in `pubspec.yaml`:
   ```yaml
   version: 1.0.0+1  # Change to a lower version
   ```

2. **Set up your API** to return a higher version:
   ```json
   {
     "latest_version": "1.0.2"
   }
   ```

3. **Run the app** and you should see the update dialog after 2 seconds

### 8. Deployment

1. **Update your app version** in `pubspec.yaml` before releasing
2. **Update your API** to return the new version number
3. **Upload to Play Store**
4. **Users will automatically see the update dialog**

## Files Created/Modified

- ✅ `lib/common/app_update_checker.dart` - Main update checker logic
- ✅ `lib/common/app_config.dart` - Configuration settings
- ✅ `lib/main.dart` - Integrated update checker
- ✅ `pubspec.yaml` - Added upgrader dependency

## Troubleshooting

### Update Dialog Not Showing
- Check your API endpoint is working
- Verify app version in `pubspec.yaml`
- Check console logs for errors

### Play Store Link Not Working
- Verify `appId` in `app_config.dart` matches your Play Store app ID
- Test the URL manually: `https://play.google.com/store/apps/details?id=YOUR_APP_ID`

### API Connection Issues
- Check your API endpoint URL
- Verify network permissions in `android/app/src/main/AndroidManifest.xml`
- Test API endpoint manually

## Security Notes

- Always use HTTPS for your API endpoint
- Consider adding API authentication if needed
- Validate version numbers on your server
- Rate limit update checks to prevent abuse

## Support

If you need help setting up the API endpoint or have questions, let me know!
