import 'package:get/get.dart';

import '../models/enums.dart';
import '../models/shared_prefs_helper.dart';
import '../views/shared/landing_page/landing_page.dart';
import 'customer_favorites_controller.dart';
import 'global_variables.dart';

class AccountController {
  static Future<void> signOut() async {
    if (GlobalVariables.globalUserInfo.loginStatus == LoginStatus.customer) {
      CustomerFavoritesController.instance.clearCurrentList();
    }
    await SharedPreferencesHelper.instance.logout();
    Get.offAll(() => const LandingPage());
  }
}
