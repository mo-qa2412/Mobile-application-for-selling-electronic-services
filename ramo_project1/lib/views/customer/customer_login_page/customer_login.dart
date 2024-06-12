import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/customer_favorites_controller.dart';
import '../../../controllers/global_variables.dart';
import '../../../models/db_helpers/customer_dbhelper.dart';
import '../../../shared/utils/toast_service.dart';
import '../signup_page/customer_signup_page.dart';

import '../../../models/enums.dart';
import '../../../models/shared_prefs_helper.dart';
import '../../../models/user_info.dart';
import '../../../shared/ui/custom_appbar.dart';
import '../../../shared/ui/custom_scaffold.dart';
import '../navigation_page/customer_navigation_page.dart';

class CustomerLoginPage extends StatefulWidget {
  const CustomerLoginPage({super.key});

  @override
  State<CustomerLoginPage> createState() => _CustomerLoginPageState();
}

class _CustomerLoginPageState extends State<CustomerLoginPage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(
        title: 'Customer Login',
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
                controller: userNameController,
                decoration: const InputDecoration(
                  hintText: 'User Name',
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
                        Get.off(() => const CustomerSignUpPage());
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
    if (userNameController.text.isEmpty || passwordController.text.isEmpty) {
      return 'Please fill all fields';
    }
    return null;
  }

  Future<void> login() async {
    try {
      String? validationMessage = validateFields();
      if (validationMessage != null) {
        await ToastService.showErrorToast(message: validationMessage);
        return;
      }
      int? id = await CustomerDBHelper.login(
        userName: userNameController.text,
        password: passwordController.text,
      );
      if (id == null) {
        ToastService.showErrorToast(message: 'Invalid Credentials');
        return;
      }
      GlobalVariables.currentUser = await CustomerDBHelper.getById(id);
      await SharedPreferencesHelper.instance.login(
        UserInfo(userId: id, loginStatus: LoginStatus.customer),
      );
      CustomerFavoritesController.instance.refreshListWithNewUser();
      Get.offAll(() => const CustomerNavigationPage());
    } catch (e) {
      await ToastService.showErrorToast(
        message: '''Couldn't login, please try again''',
      );
    }
  }
}
