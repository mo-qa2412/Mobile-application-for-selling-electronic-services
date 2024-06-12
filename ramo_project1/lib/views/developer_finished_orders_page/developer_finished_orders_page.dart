import 'package:flutter/material.dart';
import '../../models/db_helpers/customer_dbhelper.dart';
import '../../models/db_helpers/service_dbhelper.dart';

import '../../../models/entities/service_order.dart';

class DeveloperFinishedOrdersPage extends StatefulWidget {
  const DeveloperFinishedOrdersPage({super.key});

  @override
  State<DeveloperFinishedOrdersPage> createState() =>
      _DeveloperFinishedOrdersPageState();
}

class _DeveloperFinishedOrdersPageState
    extends State<DeveloperFinishedOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 15,
        right: 15,
        top: MediaQuery.of(context).padding.top + 10,
      ),
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SizedBox.expand(
          child: FutureBuilder<List<ServiceOrder>>(
            future: ServiceDBHelper.getDeveloperServiceOrders(isFinished: true),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No Orders'),
                );
              }
              return ListView.separated(
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
                          Text("Order Ref. No. ${snapshot.data![index].id}"),
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
                                      horizontal: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        FutureBuilder(
                                          future: CustomerDBHelper.getById(
                                              snapshot.data![index].customerId),
                                          builder: (context, snapshot) {
                                            if (snapshot.data == null ||
                                                !snapshot.hasData) {
                                              return const Text(
                                                  'Customer Name: [LOADING]');
                                            }
                                            return Text(
                                                'Customer Name: "${snapshot.data!.name}", Email: "${snapshot.data!.email}"');
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
                                          future:
                                              ServiceDBHelper.getByARangeOfIds([
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
              );
            },
          ),
        ),
      ),
    );
  }
}
