import 'user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/global_variables.dart';
import 'enums.dart';

class SharedPreferencesHelper {
  SharedPreferencesHelper({required this.preferencesInstance});
  static late SharedPreferencesHelper instance;
  late SharedPreferences preferencesInstance;

  static Future<SharedPreferencesHelper> init() async {
    SharedPreferences prefsInstance = await SharedPreferences.getInstance();
    instance = SharedPreferencesHelper(preferencesInstance: prefsInstance);
    return instance;
  }

  Future<void> login(UserInfo userInfo) async {
    await _setUserId(userInfo.userId);
    await _setLoginStatus(userInfo.loginStatus);
    GlobalVariables.globalUserInfo = userInfo;
  }

  Future<void> logout() async {
    await _setLoginStatus(LoginStatus.notLoggedIn);
    await _setUserId(-1);
  }

  Future<void> updateFavoritesForUser(
      int userId, List<int> favoritesItems) async {
    await preferencesInstance.setStringList(
      userId.toString(),
      favoritesItems
          .map(
            (e) => e.toString(),
          )
          .toList(),
    );
  }

  List<int> getFavoritesForUser(int userId) {
    return (preferencesInstance.getStringList(userId.toString()) ?? [])
        .map((e) => int.parse(e))
        .toList();
  }

  UserInfo getUserInfo() {
    return UserInfo(userId: _getUserId(), loginStatus: _getLoginStatus());
  }

  Future<void> _setUserId(int userId) async {
    await preferencesInstance.setInt('userId', userId);
  }

  int _getUserId() {
    return preferencesInstance.getInt('userId') ?? -1;
  }

  LoginStatus _getLoginStatus() {
    return LoginStatus.values[preferencesInstance.getInt('loginStatus') ?? 0];
  }

  Future<void> _setLoginStatus(LoginStatus loginStatus) async {
    await preferencesInstance.setInt('loginStatus', loginStatus.index);
  }
}
