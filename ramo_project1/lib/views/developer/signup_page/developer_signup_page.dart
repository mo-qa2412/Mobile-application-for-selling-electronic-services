import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../controllers/global_variables.dart';
import '../../../models/db_helpers/developer_dbhelper.dart';
import '../../../models/entities/developer.dart';
import '../../../models/enums.dart';
import '../../../models/shared_prefs_helper.dart';
import '../../../models/user_info.dart';
import '../../../shared/ui/custom_appbar.dart';
import '../../../shared/ui/custom_scaffold.dart';
import '../../../shared/utils/toast_service.dart';
import '../finish_signup_page/finish_signup_page.dart';
import '../login_page/developer_login.dart';

class DeveloperSignUpPage extends StatefulWidget {
  const DeveloperSignUpPage({super.key});

  @override
  State<DeveloperSignUpPage> createState() => _DeveloperSignUpPageState();
}

class _DeveloperSignUpPageState extends State<DeveloperSignUpPage> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController reEnterPasswordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(
        title: 'Developer Sign Up',
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
                  labelText: 'Full Name',
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 25),
              TextField(
                controller: userNameController,
                decoration: const InputDecoration(
                  labelText: 'User Name',
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 25),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 25),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 25),
              TextField(
                controller: reEnterPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Re-Enter Password',
                ),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 25),
              TextField(
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                        Get.off(() => const DeveloperLoginPage());
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
        reEnterPasswordController.text.isEmpty ||
        emailController.text.isEmpty ||
        fullNameController.text.isEmpty ||
        phoneNumberController.text.isEmpty) {
      return 'Please fill all fields';
    }
    if (!emailController.text.isEmail) {
      return 'Please Enter a valid email format';
    }
    if (passwordController.text != reEnterPasswordController.text) {
      return 'Password and Re-Enter password fields don\'t match';
    }
    if (phoneNumberController.text.length != 10 ||
        phoneNumberController.text[0] != '0' ||
        phoneNumberController.text[1] != '9') {
      return 'Please Enter a valid Syrian Phone Number';
    }
    return null;
  }

  Future<void> signUp() async {
    String? validationMessage = validateFields();
    if (validationMessage != null) {
      await ToastService.showErrorToast(message: validationMessage);
      return;
    }
    if (await DeveloperDBHelper.validateUserNameExistence(
            userNameController.text) ==
        true) {
      await ToastService.showErrorToast(
          message: 'This User Name already exists, please pick a new one');
      return;
    }
    Developer developer = Developer(
      id: -1,
      name: fullNameController.text,
      password: passwordController.text,
      balance: 100000,
      phoneNumber: phoneNumberController.text,
      email: emailController.text,
      userName: userNameController.text,
    );
    developer = developer.copyWith(
        id: await DeveloperDBHelper.signUp(
      developer,
    ));
    SharedPreferencesHelper.instance.login(
      UserInfo(userId: developer.id, loginStatus: LoginStatus.developer),
    );
    GlobalVariables.globalUserInfo = UserInfo(
      userId: developer.id,
      loginStatus: LoginStatus.developer,
    );
    GlobalVariables.currentUser = developer;
    Get.offAll(
      () => const DeveloperFinishSignUpPage(),
    );
  }
}
