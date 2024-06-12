import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/global_variables.dart';
import '../../../models/db_helpers/developer_dbhelper.dart';
import '../../../models/entities/developer.dart';
import '../../../shared/ui/custom_appbar.dart';
import '../../../shared/utils/toast_service.dart';
import '../developer_navigation_page/developer_navigation_page.dart';
import '../../../controllers/account_controller.dart';
import '../../../shared/ui/custom_scaffold.dart';

class DeveloperFinishSignUpPage extends StatefulWidget {
  const DeveloperFinishSignUpPage({super.key});

  @override
  State<DeveloperFinishSignUpPage> createState() =>
      _DeveloperFinishSignUpPageState();
}

class _DeveloperFinishSignUpPageState extends State<DeveloperFinishSignUpPage> {
  final Set<String> skills = {};
  final TextEditingController skillTxtCtrl = TextEditingController();
  final TextEditingController contactEmailTxtCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(
        title: 'Finish Profile',
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: contactEmailTxtCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Contact Email',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 70,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: skillTxtCtrl,
                          maxLength: 20,
                          decoration: const InputDecoration(
                            hintText: 'Skill ex: C#, C++, AdobeXD',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (skills.length == 20) {
                              ToastService.showErrorToast(
                                message: 'Maximum Skills Count Is 20',
                              );
                              skillTxtCtrl.clear();
                              return;
                            }
                            String value = skillTxtCtrl.text.trim();
                            if (value.contains(',')) {
                              ToastService.showErrorToast(
                                message:
                                    '''Skill name cannot contain the special character ',\'''',
                              );
                              return;
                            }
                            if (value.isEmpty) {
                              ToastService.showErrorToast(
                                message: 'Please Fill Skill Field',
                              );
                              return;
                            }
                            if (skills.contains(value)) {
                              ToastService.showErrorToast(
                                message: 'Skill Already Exists',
                              );
                              return;
                            }
                            skills.add(value.toLowerCase());
                            skillTxtCtrl.clear();
                            setState(() {});
                          },
                          child: const Text('Add Skill'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Text('You Have Added: ${skills.length} of 20 Skills'),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (skills.isEmpty) {
                      return const Center(
                        child: Text(
                          'No Skills Added',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: skills.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          height: 70,
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(
                            color: Color(0xFF3B7CAD),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  skills.elementAt(index).capitalizeFirst!,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  onPressed: () {
                                    skills.remove(skills.elementAt(index));
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context)
                            .colorScheme
                            .errorContainer
                            .withOpacity(.2),
                      ),
                    ),
                    onPressed: () => AccountController.signOut(),
                    child: Text(
                      'Sign out',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _completeProfile,
                    child: const Text('Complete Profile'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _completeProfile() async {
    if (contactEmailTxtCtrl.text.trim().isEmpty) {
      ToastService.showErrorToast(
        message: 'Contact Email Is Required',
      );
      return;
    }
    if (!contactEmailTxtCtrl.text.trim().isEmail) {
      ToastService.showErrorToast(
        message: 'Contact Email Is In Incorrect Format',
      );
      return;
    }
    if (skills.isEmpty) {
      ToastService.showErrorToast(
        message: 'Skills List Cannot Be Empty',
      );
      return;
    }
    Developer developer = GlobalVariables.currentUser as Developer;
    developer = developer.copyWith(
      contactEmail: contactEmailTxtCtrl.text,
      skills: skills.join(','),
    );
    if (!await DeveloperDBHelper.finishSignUp(developer)) {
      ToastService.showErrorToast(
        message:
            'Couldn\'t finish settings up your profile, please try again later!',
      );
      return;
    }
    GlobalVariables.currentUser = developer;
    Get.offAll(() => const DeveloperNavigationPage());
  }
}
