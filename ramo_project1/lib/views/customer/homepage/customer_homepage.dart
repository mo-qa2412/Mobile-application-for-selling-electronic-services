import 'package:flutter/material.dart';
import '../../../models/db_helpers/service_dbhelper.dart';
import '../../../models/entities/ramo_service.dart';
import 'widgets/ramo_service_homepage_card.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  late Future<List<RAMOService>> services;
  @override
  void initState() {
    services = ServiceDBHelper.getLatestServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 10),
          child: Row(
            children: [
              Text(
                'Latest services',
                style: textTheme.titleLarge,
              ),
              const Spacer(),
              IconButton(
                onPressed: () => setState(() {
                  services = ServiceDBHelper.getLatestServices();
                }),
                icon: const Icon(Icons.refresh),
              )
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: services,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List<RAMOService> services = snapshot.data!;
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
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
      ],
    );
  }
}
