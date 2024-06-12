// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:ramo/models/db_helpers/customer_dbhelper.dart';
import 'package:ramo/models/db_helpers/developer_dbhelper.dart';
import 'package:ramo/models/db_helpers/service_dbhelper.dart';
import 'package:ramo/models/entities/customer.dart';
import 'package:ramo/models/entities/developer.dart';

import 'package:ramo/models/enums.dart';
import 'package:ramo/shared/utils/toast_service.dart';
import 'package:ramo/views/developer/add_service_page/add_service_page.dart';
import 'package:ramo/views/developer/profile_page/developer_profile_page.dart';
import 'package:ramo/views/shared/widgets/buy_service_captcha_dialog.dart';

import '../../../controllers/customer_favorites_controller.dart';
import '../../../controllers/global_variables.dart';
import '../../../models/entities/ramo_service.dart';
import '../../../shared/ui/custom_appbar.dart';
import '../../../shared/ui/custom_scaffold.dart';

// ignore: must_be_immutable
class ServiceDetailsPage extends StatefulWidget {
  ServiceDetailsPage({super.key, required this.service});

  RAMOService service;

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  late Future<ServiceRating> rating;
  late Future<Developer> developerInfo;
  @override
  void initState() {
    rating = getServiceRatings();
    developerInfo = getDeveloperInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    ColorScheme colorScheme = themeData.colorScheme;
    bool isCustomer =
        GlobalVariables.globalUserInfo.loginStatus == LoginStatus.customer;
    bool isDeveloper =
        GlobalVariables.globalUserInfo.loginStatus == LoginStatus.developer;
    return CustomScaffold(
      appBar: CustomAppBar(
        title: widget.service.title,
        actions: isCustomer
            ? [
                IconButton(
                  onPressed: () => setState(
                    () {
                      CustomerFavoritesController.instance
                          .toggleFavoriteService(widget.service.id);
                    },
                  ),
                  icon: Icon(
                    Icons.favorite,
                    color: CustomerFavoritesController.instance.favoriteItems
                            .contains(widget.service.id)
                        ? Colors.red
                        : Colors.white,
                  ),
                )
              ]
            : isDeveloper
                ? [
                    IconButton(
                      onPressed: () => editService(),
                      icon: const Icon(
                        Icons.edit,
                      ),
                    ),
                  ]
                : null,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              child: Image.asset(
                'assets/category_icons/${widget.service.category.index}.png',
                fit: BoxFit.contain,
              ),
            ),
            // const SizedBox(height: 10),
            Chip(
              label: Text(categoriesAsString[widget.service.category]!),
            ),
            //const SizedBox(height: 10),
            SizedBox(
              height: 90,
              width: double.infinity,
              child: FutureBuilder(
                future: developerInfo,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Text('Loading developer info...'),
                    );
                  } else {
                    if (snapshot.hasData) {
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Get.to(
                            () => DeveloperProfilePage(
                              dev: snapshot.data!,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 35,
                              vertical: 10,
                            ),
                            child: Row(children: [
                              const Icon(
                                Icons.person,
                                size: 30,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Developer Info'),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Row(
                                    children: [
                                      const Text('Name:'),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        snapshot.data!.name.toString(),
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Row(
                                    children: [
                                      const Text('Contact Email:'),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        (snapshot.data!.contactEmail ??
                                            'Not Specified'),
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        ),
                      );
                    }
                    return const Text('No ratings found for this service');
                  }
                },
              ),
            ),
            const Divider(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.description,
                        size: 30,
                      ),
                      title: const Text('Details'),
                      subtitle: Text(
                        widget.service.details,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.secondary,
                        ),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(
                        Icons.attach_money,
                        size: 30,
                      ),
                      title: const Text('Price'),
                      subtitle: Text(
                        '${widget.service.price} SYP',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.secondary,
                        ),
                      ),
                    ),
                    FutureBuilder(
                      future: rating,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Loading ratings...'),
                                SizedBox(height: 25),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 50),
                                  child: LinearProgressIndicator(),
                                ),
                              ],
                            ),
                          );
                        } else {
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                const Divider(),
                                ListTile(
                                  leading: const Icon(
                                    Icons.thumb_up,
                                    size: 30,
                                  ),
                                  title: const Text('Likes'),
                                  subtitle: Text(
                                    snapshot.data!.likes.toString(),
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.secondary,
                                    ),
                                  ),
                                ),
                                const Divider(),
                                ListTile(
                                  leading: const Icon(
                                    Icons.thumb_down,
                                    size: 30,
                                  ),
                                  title: const Text('Dislikes'),
                                  subtitle: Text(
                                    snapshot.data!.dislikes.toString(),
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.secondary,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          return const Text(
                              'No ratings found for this service');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            isCustomer
                ? ElevatedButton(
                    onPressed: () => orderService(),
                    child: const Text('Order Service'),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Future<void> editService() async {
    var result = await Get.to(
      () => AddServicePage(
        service: widget.service,
      ),
    );
    if (result is RAMOService) {
      widget.service = result;
      setState(() {});
    }
  }

  Future<void> orderService() async {
    Customer customer = GlobalVariables.currentUser as Customer;

    if (customer.balance < widget.service.price) {
      ToastService.showErrorToast(
        message:
            'You don\'t have enough money to buy this service,your current balance is: ${customer.balance}SYP',
      );
      return;
    }
    if (await ServiceDBHelper.checkIfCustomerHasAlreadyOrderedService(
        serviceId: widget.service.id, customerId: customer.id)) {
      ToastService.showErrorToast(
        message: 'Your already have this service ordered and in progress!',
      );
      return;
    }
    if (!await showConfirmationDialog()) {
      return;
    }
    if (!await CustomerDBHelper.orderService(
      service: widget.service,
      customerId: customer.id,
    )) {
      ToastService.showErrorToast(
        message: 'Couldn\'t order service, please try again later',
      );
      return;
    }
    GlobalVariables.currentUser = await CustomerDBHelper.getById(
        (GlobalVariables.currentUser as Customer).id);
    ToastService.showSuccessToast(
      message: 'Service Ordered Successfully!',
    );
    customer = customer.copyWith(
      balance: customer.balance - widget.service.price,
    );
  }

  Future<ServiceRating> getServiceRatings() async {
    int likes = await ServiceDBHelper.getLikeCountForService(widget.service.id);
    int dislikes =
        await ServiceDBHelper.getDislikeCountForService(widget.service.id);
    return ServiceRating(likes: likes, dislikes: dislikes);
  }

  Future<Developer> getDeveloperInfo() async {
    return await DeveloperDBHelper.getById(widget.service.developerId);
  }
}

Future<bool> showConfirmationDialog() async {
  var result = await Get.dialog(
    const BuyServiceCaptchaDialog(),
  );
  return result ?? false;
}

class ServiceRating {
  final int likes;
  final int dislikes;
  ServiceRating({
    required this.likes,
    required this.dislikes,
  });
}
