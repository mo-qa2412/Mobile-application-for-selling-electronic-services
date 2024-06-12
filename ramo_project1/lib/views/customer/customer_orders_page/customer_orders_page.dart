import 'package:flutter/material.dart';
import '../../../models/enums.dart';
import '../../../shared/utils/toast_service.dart';
import '../../../models/db_helpers/developer_dbhelper.dart';
import '../../../models/db_helpers/service_dbhelper.dart';
import '../../../models/db_helpers/service_order_dbhelper.dart';
import '../../../models/entities/service_order.dart';

class CustomerOrdersPage extends StatefulWidget {
  const CustomerOrdersPage({super.key});

  @override
  State<CustomerOrdersPage> createState() => _CustomerOrdersPageState();
}

class _CustomerOrdersPageState extends State<CustomerOrdersPage> {
  bool isDone = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 15,
        right: 15,
        top: MediaQuery.of(context).padding.top + 10,
      ),
      child: SizedBox.expand(
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Switch(
                          value: isDone,
                          onChanged: (switchVal) {
                            isDone = switchVal;
                            setState(() {});
                          }),
                      const SizedBox(width: 10),
                      Text(
                        isDone
                            ? 'Showing Finished Orders'
                            : 'Showing Ongoing Orders',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
            FutureBuilder<List<ServiceOrder>>(
              future: ServiceOrderDBHelper.getCustomerServiceOrders(
                  isFinished: isDone),
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                      ],
                    ),
                  );
                }
                if (snapshot.data!.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .4,
                      ),
                      Text('No ${isDone ? 'Finished' : 'Ongoing'} Orders'),
                    ],
                  );
                }
                return Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white.withOpacity(.2),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        clipBehavior: Clip.antiAlias,
                        margin: EdgeInsets.zero,
                        child: ExpansionTile(
                          title: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                  "Order Ref. No. ${snapshot.data![index].id}"),
                            ],
                          ),
                          children: [
                            AspectRatio(
                              aspectRatio: 10 / 3,
                              child: Container(
                                color: Colors.white.withOpacity(.2),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Wrap(
                                          children: [
                                            FutureBuilder(
                                              future: DeveloperDBHelper
                                                  .getByServiceId(
                                                      serviceId: snapshot
                                                          .data![index]
                                                          .serviceId),
                                              builder: (context, snapshot) {
                                                if (snapshot.data == null ||
                                                    !snapshot.hasData) {
                                                  return const Text(
                                                      'Developer Name: [LOADING]');
                                                }
                                                return Text(
                                                  'Developer Name: "${snapshot.data!.name}", Email: "${snapshot.data!.email}"',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Wrap(
                                          alignment: WrapAlignment.start,
                                          children: [
                                            FutureBuilder(
                                              future: ServiceDBHelper
                                                  .getByARangeOfIds([
                                                snapshot.data![index].serviceId
                                              ]),
                                              builder: (context, snapshot) {
                                                if (snapshot.data == null ||
                                                    !snapshot.hasData) {
                                                  return const Text(
                                                      'Service Info: [LOADING]');
                                                }
                                                return Text(
                                                    'Service Info: "${snapshot.data![0].title}", "${snapshot.data![0].price}" SYP');
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (snapshot.data![index].likeStatus !=
                                        ServiceOrderLikeStatus.none.index)
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              snapshot.data![index]
                                                          .likeStatus ==
                                                      ServiceOrderLikeStatus
                                                          .isLiked.index
                                                  ? Icons.thumb_up
                                                  : Icons.thumb_down,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              snapshot.data![index]
                                                          .likeStatus ==
                                                      ServiceOrderLikeStatus
                                                          .isLiked.index
                                                  ? 'You Have Liked This Service'
                                                  : 'You Did Not Like This Service',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (isDone &&
                                        snapshot.data![index].likeStatus ==
                                            ServiceOrderLikeStatus.none.index)
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                bool res =
                                                    await ServiceOrderDBHelper
                                                        .updateServiceOrder(
                                                  serviceOrder: snapshot
                                                      .data![index]
                                                      .copyWith(
                                                    likeStatus:
                                                        ServiceOrderLikeStatus
                                                            .isLiked.index,
                                                  ),
                                                );
                                                setState(() {});
                                                if (res) {
                                                  ToastService.showSuccessToast(
                                                      message:
                                                          'Liked Service Successfully');
                                                  return;
                                                }
                                                ToastService.showSuccessToast(
                                                  message:
                                                      'An Error Ocurred Whilst Liking Service',
                                                );
                                              },
                                              child: const Row(
                                                children: [
                                                  Icon(Icons.thumb_up),
                                                  SizedBox(width: 10),
                                                  Text('Like'),
                                                ],
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                bool res =
                                                    await ServiceOrderDBHelper
                                                        .updateServiceOrder(
                                                  serviceOrder: snapshot
                                                      .data![index]
                                                      .copyWith(
                                                    likeStatus:
                                                        ServiceOrderLikeStatus
                                                            .isDisliked.index,
                                                  ),
                                                );
                                                setState(() {});
                                                if (res) {
                                                  ToastService.showSuccessToast(
                                                      message:
                                                          'Disliked Service Successfully');
                                                  return;
                                                }
                                                ToastService.showSuccessToast(
                                                  message:
                                                      'An Error Ocurred Whilst Disliking Service',
                                                );
                                              },
                                              child: const Row(
                                                children: [
                                                  Icon(Icons.thumb_up),
                                                  SizedBox(width: 10),
                                                  Text('Dislike'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (!isDone)
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                bool res =
                                                    await ServiceOrderDBHelper
                                                        .setServiceOrderAsFinished(
                                                  serviceOrderId:
                                                      snapshot.data![index].id,
                                                );
                                                if (!res) {
                                                  ToastService.showErrorToast(
                                                      message:
                                                          'An Error Occurred While Marking Order As Done');
                                                  return;
                                                }
                                                ToastService.showSuccessToast(
                                                    message:
                                                        'Marked Order As Done Successfully. Thank You!');
                                                setState(() {});
                                              },
                                              child: const Text('Finish Order'),
                                            ),
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
