import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/db_helpers/customer_dbhelper.dart';
import '../../../models/entities/customer.dart';
import '../../../models/enums.dart';
import '../../../models/shared_prefs_helper.dart';
import '../../../models/user_info.dart';
import '../customer_login_page/customer_login.dart';

import '../../../controllers/global_variables.dart';
import '../../../shared/ui/custom_appbar.dart';
import '../../../shared/ui/custom_scaffold.dart';
import '../../../shared/utils/toast_service.dart';
import '../navigation_page/customer_navigation_page.dart';

class CustomerSignUpPage extends StatefulWidget {
  const CustomerSignUpPage({super.key});

  @override
  State<CustomerSignUpPage> createState() => _CustomerSignUpPageState();
}

class _CustomerSignUpPageState extends State<CustomerSignUpPage> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController reEnterPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(
        title: 'Customer Sign Up',
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
                controller: fullNameController,
                decoration: const InputDecoration(
                  hintText: 'Full Name',
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: userNameController,
                decoration: const InputDecoration(
                  hintText: 'User Name',
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 30),
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
              const SizedBox(height: 30),
              TextField(
                controller: reEnterPasswordController,
                decoration: const InputDecoration(
                  hintText: 'Re-Enter Password',
                ),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: signUp,
                      child: const Text('Sign Up'),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.off(() => const CustomerLoginPage());
                      },
                      child: const Text('Already Have An Account? Login'),
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
    if (userNameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        emailController.text.isEmpty ||
        reEnterPasswordController.text.isEmpty ||
        fullNameController.text.isEmpty) {
      return 'Please fill all fields';
    }
    if (!emailController.text.isEmail) {
      return 'Please Enter a valid email format';
    }
    if (passwordController.text != reEnterPasswordController.text) {
      return 'Password and Re-Enter password fields don\'t match';
    }
    return null;
  }

  Future<void> signUp() async {
    String? validationMessage = validateFields();
    if (validationMessage != null) {
      await ToastService.showErrorToast(message: validationMessage);
      return;
    }
    if (await CustomerDBHelper.validateUserNameExistence(
            userNameController.text) ==
        true) {
      await ToastService.showErrorToast(
          message: 'This User Name already exists, please pick a new one');
      return;
    }
    Customer customer = Customer(
      id: -1,
      name: fullNameController.text,
      password: passwordController.text,
      email: emailController.text,
      balance: 100000,
      userName: userNameController.text,
    );
    customer = customer.copyWith(
      id: await CustomerDBHelper.signUp(
        customer,
      ),
    );
    GlobalVariables.currentUser = await CustomerDBHelper.getById(
      customer.id,
    );
    await SharedPreferencesHelper.instance.login(
      UserInfo(
        userId: customer.id,
        loginStatus: LoginStatus.customer,
      ),
    );
    Get.offAll(() => const CustomerNavigationPage());
  }
}
