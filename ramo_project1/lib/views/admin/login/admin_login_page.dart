import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/global_variables.dart';
import '../../../models/db_helpers/admin_dbhelper.dart';
import '../../../models/enums.dart';
import '../../../models/shared_prefs_helper.dart';
import '../../../models/user_info.dart';
import '../../../shared/ui/custom_appbar.dart';
import '../../../shared/ui/custom_scaffold.dart';
import '../../../shared/utils/toast_service.dart';
import '../homepage/admin_homepage.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(
        title: 'Admin Login',
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: login,
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validateFields() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      return 'Please fill all fields';
    }
    if (!emailController.text.isEmail) {
      return 'Please Enter a valid email format';
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
      int? id = await AdminDBHelper.login(
        email: emailController.text,
        password: passwordController.text,
      );
      if (id == null) {
        ToastService.showErrorToast(message: 'Invalid Credentials');
        return;
      }
      GlobalVariables.currentUser = await AdminDBHelper.getById(
        id,
      );
      await SharedPreferencesHelper.instance.login(
        UserInfo(userId: id, loginStatus: LoginStatus.admin),
      );
      Get.offAll(
        () => const AdminHomePage(),
      );
    } catch (e) {
      log(e.toString());
      await ToastService.showErrorToast(
        message: '''Couldn't login, please try again''',
      );
    }
  }
}
