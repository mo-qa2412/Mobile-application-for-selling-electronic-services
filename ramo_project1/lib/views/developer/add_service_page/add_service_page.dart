import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../controllers/global_variables.dart';
import '../../../models/db_helpers/service_dbhelper.dart';
import '../../../models/entities/ramo_service.dart';
import '../../../models/enums.dart';
import '../../../shared/ui/custom_appbar.dart';
import '../../../shared/ui/custom_scaffold.dart';
import '../../../shared/utils/toast_service.dart';

// ignore: must_be_immutable
class AddServicePage extends StatefulWidget {
  AddServicePage({super.key, this.service});

  RAMOService? service;
  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  late final bool isEditMode;
  ServiceCategory category = ServiceCategory.web;
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  @override
  void initState() {
    if (widget.service == null) {
      isEditMode = false;
    } else {
      isEditMode = true;
      titleController.text = widget.service!.title;
      priceController.text = widget.service!.price.toString();
      detailsController.text = widget.service!.details;
      category = widget.service!.category;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: isEditMode ? 'Edit Service' : 'Add Service',
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).padding.top + 80,
          horizontal: 20,
        ),
        shrinkWrap: true,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              label: Text('Title'),
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: priceController,
            decoration: const InputDecoration(
              label: Text('Price (in SYP)'),
            ),
            enabled: !isEditMode,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: detailsController,
            decoration: const InputDecoration(
              label: Text('Details'),
            ),
            textInputAction: TextInputAction.done,
            maxLines: 3,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Container(
                  height: 75,
                  width: 75,
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  child: Image.asset(
                    'assets/category_icons/${category.index}.png',
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Category',
                  ),
                  DropdownButton<ServiceCategory>(
                    value: category,
                    items: ServiceCategory.values
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              categoriesAsString[e]!,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(
                          () {
                            category = value;
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () => isEditMode ? editService() : addService(),
            child: Text(
              isEditMode ? 'Edit Service' : 'Add Service',
            ),
          ),
        ],
      ),
    );
  }

  String? validateFields() {
    if (titleController.text.isEmpty ||
        priceController.text.isEmpty ||
        detailsController.text.isEmpty) {
      ToastService.showErrorToast(
        message: 'Please fill all fields',
      );
    }
    return null;
  }

  Future<void> editService() async {
    String? validationMessage = validateFields();
    if (validationMessage != null) {
      ToastService.showErrorToast(message: validationMessage);
      return;
    }

    RAMOService newService = widget.service!.copyWith(
      title: titleController.text,
      details: detailsController.text,
      category: category,
    );
    await ServiceDBHelper.editService(
      newService,
    );
    ToastService.showSuccessToast(message: 'Service Updated Successfully!');
    Get.back(
      result: newService,
    );
  }

  Future<void> addService() async {
    String? validationMessage = validateFields();
    if (validationMessage != null) {
      ToastService.showErrorToast(message: validationMessage);
      return;
    }
    await ServiceDBHelper.addService(
      RAMOService(
          id: -1,
          title: titleController.text,
          category: category,
          price: int.parse(priceController.text),
          developerId: GlobalVariables.globalUserInfo.userId,
          details: detailsController.text),
    );
    Get.back(result: true);
  }
}

class AddServicePageChangeStreamer with ChangeNotifier {
  static AddServicePageChangeStreamer streamer = AddServicePageChangeStreamer();

  void streamChanges() {
    streamer.notifyListeners();
  }
}
