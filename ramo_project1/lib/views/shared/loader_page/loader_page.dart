import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import '../../developer/developer_navigation_page/developer_navigation_page.dart';
import '../../../models/db_helpers/admin_dbhelper.dart';
import '../../../models/db_helpers/customer_dbhelper.dart';
import '../../../models/db_helpers/developer_dbhelper.dart';
import '../../../models/entities/developer.dart';
import '../../../models/shared_prefs_helper.dart';
import '../../../shared/ui/custom_scaffold.dart';
import '../../customer/navigation_page/customer_navigation_page.dart';
import '../../developer/finish_signup_page/finish_signup_page.dart';
import '../../admin/homepage/admin_homepage.dart';
import '../landing_page/landing_page.dart';

import '../../../controllers/global_variables.dart';
import '../../../models/enums.dart';

class LoaderPage extends StatelessWidget {
  const LoaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      handleNavigation();
    });
    ThemeData themeData = Theme.of(context);
    // TextTheme textTheme = themeData.textTheme;
    ColorScheme colorScheme = themeData.colorScheme;
    return CustomScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Hero(
            tag: 'landing_page_icon',
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 330,
                height: 330,
                foregroundDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  backgroundBlendMode: BlendMode.hue,
                ),
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(.4),
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: Theme.of(context).colorScheme.primary),
                  image: const DecorationImage(
                    image: AssetImage('assets/icon/landing_page.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 200,
            child: LinearProgressIndicator(),
          ),
        ],
      ),
    );
  }

  Future<void> handleNavigation() async {
    GlobalVariables.globalUserInfo =
        SharedPreferencesHelper.instance.getUserInfo();
    switch (GlobalVariables.globalUserInfo.loginStatus) {
      case LoginStatus.notLoggedIn:
        {
          await Future.delayed(const Duration(seconds: 2));
          Get.offAll(() => const LandingPage());
          return;
        }
      case LoginStatus.admin:
        {
          GlobalVariables.currentUser = await AdminDBHelper.getById(
            GlobalVariables.globalUserInfo.userId,
          );
          Get.offAll(() => const AdminHomePage());
          return;
        }
      case LoginStatus.customer:
        {
          GlobalVariables.currentUser = await CustomerDBHelper.getById(
            GlobalVariables.globalUserInfo.userId,
          );
          Get.offAll(() => const CustomerNavigationPage());
          return;
        }
      case LoginStatus.developer:
        {
          Developer developer = await DeveloperDBHelper.getById(
            GlobalVariables.globalUserInfo.userId,
          );
          GlobalVariables.currentUser = developer;
          if (developer.hasFinishedSignUp) {
            Get.offAll(() => const DeveloperNavigationPage());
            return;
          }
          Get.offAll(() => const DeveloperFinishSignUpPage());
          return;
        }
    }
  }
}
