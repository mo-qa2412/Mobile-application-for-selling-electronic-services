import 'package:flutter/material.dart';
import '../../../controllers/global_variables.dart';
import '../../../models/db_helpers/service_dbhelper.dart';
import '../../../models/entities/ramo_service.dart';
import '../add_service_page/add_service_page.dart';

import '../../customer/homepage/widgets/ramo_service_homepage_card.dart';

class DeveloperHomePage extends StatefulWidget {
  const DeveloperHomePage({super.key});

  @override
  State<DeveloperHomePage> createState() => _DeveloperHomePageState();
}

class _DeveloperHomePageState extends State<DeveloperHomePage> {
  late Future<List<RAMOService>> myServices;
  @override
  void initState() {
    AddServicePageChangeStreamer.streamer.addListener(() {
      if (mounted) {
        setState(() {
          myServices = getMyServices();
        });
      }
    });
    myServices = getMyServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        myServices = getMyServices();
        setState(() {});
      },
      child: SizedBox.expand(
        child: Padding(
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
            top: MediaQuery.of(context).padding.top + 10,
          ),
          child: FutureBuilder(
            future: myServices,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List<RAMOService> services = snapshot.data!;
                  if (services.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.work,
                          size: 45,
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        Text(
                          'No Services Yet',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Add a service using the button below',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 85),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      return RAMOServiceHomePageCard(
                        service: services[index],
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 13,
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error loading services'),
                  );
                }
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Future<List<RAMOService>> getMyServices() async {
    return await ServiceDBHelper.getAllServicesForDeveloper(
      GlobalVariables.globalUserInfo.userId,
    );
  }
}
