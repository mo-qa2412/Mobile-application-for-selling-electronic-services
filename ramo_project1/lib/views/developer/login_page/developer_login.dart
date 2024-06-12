import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../developer_navigation_page/developer_navigation_page.dart';
import '../../../models/db_helpers/developer_dbhelper.dart';
import '../../../models/enums.dart';
import '../../../models/shared_prefs_helper.dart';
import '../../../models/user_info.dart';
import '../../../shared/utils/toast_service.dart';
import '../signup_page/developer_signup_page.dart';

import '../../../controllers/global_variables.dart';
import '../../../models/entities/developer.dart';
import '../../../shared/ui/custom_appbar.dart';
import '../../../shared/ui/custom_scaffold.dart';
import '../finish_signup_page/finish_signup_page.dart';

class DeveloperLoginPage extends StatefulWidget {
  const DeveloperLoginPage({super.key});

  @override
  State<DeveloperLoginPage> createState() => _DeveloperLoginPageState();
}

class _DeveloperLoginPageState extends State<DeveloperLoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(
        title: 'Developer Login',
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              const SizedBox(height: 70),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: login,
                      child: const Text('Login'),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.off(() => const DeveloperSignUpPage());
                      },
                      child: const Text('Don\'t Have An Account? Sign Up'),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validateFields() {
    if (emailController.text.isEmpty) {
      return 'Please fill the email field';
    }
    if (passwordController.text.isEmpty) {
      return 'Please fill the password field';
    }
    if (!emailController.text.isEmail) {
      return 'Please Enter a valid email format';
    }
    return null;
  }

  Future<void> login() async {
    String? validationMessage = validateFields();
    if (validationMessage != null) {
      ToastService.showErrorToast(message: validationMessage);
      return;
    }
    int? result = await DeveloperDBHelper.login(
      email: emailController.text,
      password: passwordController.text,
    );
    if (result == null) {
      ToastService.showErrorToast(message: 'Invalid Login Credentials');
      return;
    }
    await SharedPreferencesHelper.instance.login(
      UserInfo(userId: result, loginStatus: LoginStatus.developer),
    );
    Developer developer = await DeveloperDBHelper.getById(
      GlobalVariables.globalUserInfo.userId,
    );
    GlobalVariables.currentUser = developer;
    if (developer.hasFinishedSignUp) {
      Get.offAll(
        () => const DeveloperNavigationPage(),
      );
      return;
    }
    Get.offAll(
      () => const DeveloperFinishSignUpPage(),
    );
    return;
  }
}
