import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import '../../../controllers/global_variables.dart';
import '../../../models/db_helpers/developer_dbhelper.dart';
import '../../../models/db_helpers/service_dbhelper.dart';
import '../../../models/entities/developer.dart';
import '../../../models/entities/ramo_service.dart';
import '../../../models/enums.dart';
import '../../../shared/ui/custom_appbar.dart';
import '../../../shared/ui/custom_scaffold.dart';
import '../../../shared/utils/toast_service.dart';
import '../edit_profile_page/developer_edit_profile_page.dart';
import 'widgets/developer_contact_info_widget.dart';
import 'widgets/ramo_service_profile_card.dart';

import '../../../controllers/account_controller.dart';

// ignore: must_be_immutable
class DeveloperProfilePage extends StatefulWidget {
  DeveloperProfilePage({
    super.key,
    Developer? dev,
    this.subView = false,
  }) {
    if (dev == null) {
      developer = GlobalVariables.currentUser as Developer;
    } else {
      developer = dev;
    }
  }

  late Developer developer;
  bool subView;

  @override
  State<DeveloperProfilePage> createState() => _DeveloperProfilePageState();
}

class _DeveloperProfilePageState extends State<DeveloperProfilePage> {
  late bool isMe;
  bool isLoading = false;
  late Future<List<RAMOService>> developerServices;
  @override
  void initState() {
    isMe = GlobalVariables.globalUserInfo.loginStatus ==
            LoginStatus.developer &&
        (GlobalVariables.currentUser as Developer).id == widget.developer.id;
    developerServices = getDevServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.subView
        ? Material(
            color: Colors.transparent,
            child: _buildChild(),
          )
        : CustomScaffold(
            appBar: const CustomAppBar(
              title: "Developer profile",
            ),
            body: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 10,
              ),
              child: _buildChild(),
            ),
          );
  }

  Widget _buildChild() {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    final ColorScheme colorScheme = themeData.colorScheme;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SizedBox.expand(
            child: RefreshIndicator(
              onRefresh: () => refreshDevInfo(),
              child: ListView(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                ),
                children: [
                  SizedBox(
                    // height: MediaQuery.of(context).size.height * .34,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: 35,
                                    backgroundColor:
                                        colorScheme.primaryContainer,
                                    child: Icon(
                                      Icons.person,
                                      size: 40,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '@${widget.developer.userName}',
                                    style: textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 10),
                                  if (isMe)
                                    IconButton(
                                      onPressed: () =>
                                          AccountController.signOut(),
                                      icon: const Icon(Icons.logout),
                                      tooltip: 'Log Out',
                                    ),
                                ],
                              ),
                              const SizedBox(width: 30),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    isMe
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: FittedBox(
                                                  child: Text(
                                                    widget.developer.name,
                                                    style:
                                                        textTheme.displaySmall,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () => editProfile(),
                                                icon: const Icon(
                                                  Icons.edit,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            widget.developer.name,
                                            style: textTheme.displaySmall,
                                          ),
                                    if (isMe)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: DeveloperContactInfoWidget(
                                          info:
                                              '${widget.developer.balance} SYP',
                                          iconData: Icons.monetization_on_sharp,
                                        ),
                                      ),
                                    const SizedBox(height: 15),
                                    DeveloperContactInfoWidget(
                                      info: widget.developer.contactEmail ??
                                          'Contact Email Not Provided',
                                      iconData: Icons.email,
                                    ),
                                    const SizedBox(height: 15),
                                    DeveloperContactInfoWidget(
                                      info: widget.developer.phoneNumber,
                                      iconData: Icons.phone,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(indent: 20, endIndent: 20),
                        Container(
                          padding: const EdgeInsets.only(left: 20, bottom: 10),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Text(
                                  'Skills',
                                  style: textTheme.titleLarge,
                                ),
                              ),
                              const SizedBox(height: 15),
                              widget.developer.skills == null
                                  ? const Text(
                                      'This developer hasn\'t added their skills yet',
                                    )
                                  : Builder(
                                      builder: (context) {
                                        List<String> skills =
                                            widget.developer.skills!.split(',');
                                        return Flex(
                                          direction: Axis.horizontal,
                                          children: List.generate(
                                            skills.length,
                                            (index) => Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: Chip(
                                                label: Text(
                                                  skills[index],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ],
                          ),
                        ),
                        const Divider(indent: 20, endIndent: 20, height: 0),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Developer Services',
                            style: textTheme.titleLarge,
                          ),
                        ),
                        const SizedBox(height: 15),
                        FutureBuilder<List<RAMOService>>(
                          future: developerServices,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(
                                height: 300,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            if (snapshot.hasData &&
                                (snapshot.data as List<RAMOService>)
                                    .isNotEmpty) {
                              List<RAMOService> services =
                                  snapshot.data as List<RAMOService>;
                              return ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 0,
                                ),
                                itemCount: services.length,
                                itemBuilder: (context, index) {
                                  return RAMOServiceProfileCard(
                                    service: services[index],
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 10),
                              );
                            }
                            return Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  'This developer has no services at the moment...',
                                  textAlign: TextAlign.center,
                                  style: textTheme.titleLarge,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Future<void> refreshDevInfo() async {
    isLoading = true;
    setState(() {});
    widget.developer = await DeveloperDBHelper.getById(widget.developer.id);
    developerServices = getDevServices();
    isLoading = false;
    setState(() {});
    if (isMe) {
      GlobalVariables.currentUser = widget.developer;
    }
  }

  Future<List<RAMOService>> getDevServices() async {
    return await ServiceDBHelper.getAllServicesForDeveloper(
        widget.developer.id);
  }

  Future<void> editProfile() async {
    var result = await Get.to(
      () => DeveloperEditProfilePage(
        developer: widget.developer,
      ),
    );
    if (result is Developer) {
      widget.developer = result;
      ToastService.showSuccessToast(message: 'Profile Updated Successfully');
      setState(() {});
    }
  }
}
