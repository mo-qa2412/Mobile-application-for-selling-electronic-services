import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../models/db_helpers/developer_dbhelper.dart';
import '../../../models/entities/developer.dart';
import '../../../shared/ui/custom_appbar.dart';
import '../../../shared/ui/custom_scaffold.dart';

import '../../../shared/utils/toast_service.dart';

class DeveloperEditProfilePage extends StatefulWidget {
  const DeveloperEditProfilePage({
    super.key,
    required this.developer,
  });

  final Developer developer;

  @override
  State<DeveloperEditProfilePage> createState() =>
      _DeveloperEditProfilePageState();
}

class _DeveloperEditProfilePageState extends State<DeveloperEditProfilePage> {
  List<String> skills = [];
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController contactEmail = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController skillTxtCtrl = TextEditingController();

  @override
  void initState() {
    skills = widget.developer.skills?.split(',') ?? [];
    fullNameController.text = widget.developer.name;
    emailController.text = widget.developer.email;
    passwordController.text = widget.developer.password;
    contactEmail.text = widget.developer.contactEmail ?? '';
    phoneNumberController.text = widget.developer.phoneNumber;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(
        title: 'Edit Profile',
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.only(
            right: 20,
            left: 20,
          ),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: ListView(
                  children: [
                    TextField(
                      controller: fullNameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: contactEmail,
                      decoration: const InputDecoration(
                        labelText: 'Contact Email',
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: phoneNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: skillTxtCtrl,
                            maxLength: 20,
                            decoration: const InputDecoration(
                              hintText: 'Skill ex: C#, C++, AdobeXD',
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
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
                                skills.add(
                                  value.toLowerCase(),
                                );
                                skillTxtCtrl.clear();
                                setState(() {});
                              },
                              child: const Text('Add Skill'),
                            ),
                          ),
                        )
                      ],
                    ),
                    Text('You Have Added: ${skills.length} of 20 Skills'),
                    const SizedBox(height: 10),
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
                          return ListView.separated(
                            itemCount: skills.length,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 0,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                height: 50,
                                clipBehavior: Clip.hardEdge,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF3B7CAD),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        skills
                                            .elementAt(index)
                                            .capitalizeFirst!,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          skills
                                              .remove(skills.elementAt(index));
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
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => updateProfile(),
                    child: const Text('Update Profile'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String? validateFields() {
    if (passwordController.text.isEmpty ||
        emailController.text.isEmpty ||
        fullNameController.text.isEmpty ||
        phoneNumberController.text.isEmpty) {
      return 'Please fill all fields';
    }
    if (!emailController.text.isEmail) {
      return 'Please Enter a valid email format';
    }
    if (phoneNumberController.text.length != 10 ||
        phoneNumberController.text[0] != '0' ||
        phoneNumberController.text[1] != '9') {
      return 'Please Enter a valid Syrian Phone Number';
    }
    if (contactEmail.text.trim().isEmpty) {
      return 'Contact Email Is Required';
    }
    if (!contactEmail.text.trim().isEmail) {
      return 'Contact Email Is In Incorrect Format';
    }
    if (skills.isEmpty) {
      return 'Skills List Cannot Be Empty';
    }
    return null;
  }

  Future<void> updateProfile() async {
    String? validationMessage = validateFields();
    if (validationMessage != null) {
      await ToastService.showErrorToast(message: validationMessage);
      return;
    }
    final Developer newDeveloper = widget.developer.copyWith(
      name: fullNameController.text,
      email: emailController.text,
      password: passwordController.text,
      contactEmail: contactEmail.text,
      phoneNumber: phoneNumberController.text,
      skills: skills.join(','),
    );
    await DeveloperDBHelper.updateProfile(newDeveloper);
    Get.back(result: newDeveloper);
  }
}
