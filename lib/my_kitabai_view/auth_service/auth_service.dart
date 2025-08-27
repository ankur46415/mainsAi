import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/shred_pref.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  late SharedPreferences _prefs;
  final Rx<String?> _authToken = Rx<String?>(null);
  final RxBool _isLoggedIn = false.obs;
  final Rx<String?> _userId = Rx<String?>(null);
  final Rx<String?> _userEmail = Rx<String?>(null);
  final Rx<String?> _userName = Rx<String?>(null);
  final Rx<String?> _userPhone = Rx<String?>(null);

  String? get authToken => _authToken.value;
  bool get isLoggedIn => _isLoggedIn.value;
  String? get userId => _userId.value;
  String? get userEmail => _userEmail.value;
  String? get userName => _userName.value;
  String? get userPhone => _userPhone.value;

  Future<AuthService> init() async {
    _prefs = await SharedPreferences.getInstance();
    _authToken.value = _prefs.getString(Constants.authToken);
    _isLoggedIn.value = _prefs.getBool(Constants.isLoggedIn) ?? false;
    _userId.value = _prefs.getString(Constants.userId);
    _userEmail.value = _prefs.getString(Constants.userEmail);
    _userName.value = _prefs.getString(Constants.userName);
    _userPhone.value = _prefs.getString(Constants.userPhone);
    return this;
  }

  Future<void> setToken(String token) async {
    await _prefs.setString(Constants.authToken, token);
    await _prefs.setBool(Constants.isLoggedIn, true);
    _authToken.value = token;
    _isLoggedIn.value = true;
  }

  Future<void> setUserData({
    required String userId,
    required String userEmail,
    String? userName,
    String? userPhone,
  }) async {
    await _prefs.setString(Constants.userId, userId);
    await _prefs.setString(Constants.userEmail, userEmail);
    if (userName != null) {
      await _prefs.setString(Constants.userName, userName);
      _userName.value = userName;
    }
    if (userPhone != null) {
      await _prefs.setString(Constants.userPhone, userPhone);
      _userPhone.value = userPhone;
    }
    _userId.value = userId;
    _userEmail.value = userEmail;
  }

  Future<void> clearToken() async {
    await _prefs.remove(Constants.authToken);
    await _prefs.remove(Constants.userId);
    await _prefs.remove(Constants.userEmail);
    await _prefs.remove(Constants.userName);
    await _prefs.remove(Constants.userPhone);
    await _prefs.setBool(Constants.isLoggedIn, false);
    _authToken.value = null;
    _isLoggedIn.value = false;
    _userId.value = null;
    _userEmail.value = null;
    _userName.value = null;
    _userPhone.value = null;
  }

  Future<void> logout() async {
    await clearToken();
    _isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }

  Map<String, String> getAuthHeaders() {
    if (_authToken.value == null) return {};
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_authToken.value}',
    };
  }
}
