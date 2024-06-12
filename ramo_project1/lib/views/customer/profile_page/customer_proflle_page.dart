import 'package:flutter/material.dart';
import 'package:ramo/controllers/global_variables.dart';
import 'package:ramo/models/db_helpers/customer_dbhelper.dart';
import 'package:ramo/models/entities/customer.dart';
import 'package:ramo/shared/utils/toast_service.dart';
import '../../../controllers/account_controller.dart';

class CustomerProfilePage extends StatefulWidget {
  const CustomerProfilePage({super.key});

  @override
  State<CustomerProfilePage> createState() => CustomerProfilePageState();
}

class CustomerProfilePageState extends State<CustomerProfilePage> {
  final TextEditingController nameField = TextEditingController();
  bool isEditMode = false;
  late Customer currentUser;

  @override
  Widget build(BuildContext context) {
    currentUser = (GlobalVariables.currentUser as Customer);
    nameField.text = currentUser.name;
    return SizedBox.expand(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      isEditMode = !isEditMode;
                      setState(() {});
                    },
                    icon: Icon(isEditMode ? Icons.cancel : Icons.edit),
                    tooltip: isEditMode ? 'Cancel Edit' : 'Edit Profile',
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.alternate_email_sharp,
                    color: Theme.of(context).colorScheme.primary,
                    size: 30,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    currentUser.userName,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.monetization_on,
                    color: Theme.of(context).colorScheme.primary,
                    size: 30,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${currentUser.balance} SYP',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (!isEditMode)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.credit_card,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      currentUser.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              if (isEditMode)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: AbsorbPointer(
                    absorbing: !isEditMode,
                    child: TextField(
                      controller: nameField,
                      decoration: const InputDecoration(
                        hintText: 'Name',
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              if (isEditMode)
                ElevatedButton(
                  onPressed: () async {
                    Customer? customerRes = await CustomerDBHelper.updateName(
                        name: nameField.text.trim());
                    if (customerRes == null) {
                      ToastService.showErrorToast(
                          message: 'An Error Occurred While Editing Name');
                      return;
                    }
                    ToastService.showSuccessToast(
                        message: 'Name Edited Successfully');
                    GlobalVariables.currentUser = customerRes;
                    isEditMode = false;
                    setState(() {});
                  },
                  child: const Text('Apply Changes'),
                ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => AccountController.signOut(),
                child: const Text('Sign out'),
              ),
              const SizedBox(height: 40),
              Text(
                'Contact Admin Via Email: admin@ramo.com',
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void resetState() {
    if (mounted) {
      setState(() {});
    }
  }
}
