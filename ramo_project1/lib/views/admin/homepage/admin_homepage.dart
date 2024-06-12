import 'package:flutter/material.dart';
import 'package:ramo/models/db_helpers/admin_dbhelper.dart';
import '../../../controllers/account_controller.dart';
import '../../../controllers/global_variables.dart';
import '../../../shared/ui/custom_appbar.dart';

import '../../../shared/ui/custom_scaffold.dart';

import '../../../models/db_helpers/developer_dbhelper.dart';
import '../../../models/db_helpers/service_dbhelper.dart';
import '../../../models/entities/service_order.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: 'All Orders',
        actions: [
          IconButton(
            onPressed: () {
              AccountController.signOut();
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Log Out',
          )
        ],
      ),
      body: const _OrdersPage(),
    );
  }
}

class _OrdersPage extends StatefulWidget {
  const _OrdersPage();

  @override
  State<_OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<_OrdersPage> {
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
            Text(
              'Current Balance: ${GlobalVariables.currentUser.balance} SYP',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
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
              future: AdminDBHelper.getAll(isFinished: isDone),
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
