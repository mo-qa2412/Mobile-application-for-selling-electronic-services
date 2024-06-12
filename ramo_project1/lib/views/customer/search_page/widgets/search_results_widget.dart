import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/db_helpers/developer_dbhelper.dart';
import '../../../../models/db_helpers/service_dbhelper.dart';
import '../../../developer/profile_page/developer_profile_page.dart';

import '../../../../models/entities/developer.dart';
import '../../../../models/entities/ramo_service.dart';
import '../../homepage/widgets/ramo_service_homepage_card.dart';
import '../customer_search_page.dart';

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({
    super.key,
  });

  @override
  State<SearchResultsPage> createState() => SearchResultsPageState();
}

class SearchResultsPageState extends State<SearchResultsPage> {
  late Future<List<RAMOService>> serviceSearchResults;
  late Future<List<Developer>> developerSearchResults;
  String searchTerm = '';
  CustomerSearchOptions selectedOption = CustomerSearchOptions.service;

  @override
  void initState() {
    serviceSearchResults = searchForServices();
    developerSearchResults = searchForDevelopers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (searchTerm.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 130,
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              'Enter a search term and click on the search icon to start searching',
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
    }
    return Material(
      color: Colors.transparent,
      child: FutureBuilder(
        future: selectedOption == CustomerSearchOptions.service
            ? serviceSearchResults
            : developerSearchResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data! is List<Developer> && snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No Results Found'),
                );
              }
              switch (selectedOption) {
                case CustomerSearchOptions.service:
                  {
                    List<RAMOService> services =
                        snapshot.data! as List<RAMOService>;
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
                case CustomerSearchOptions.developer:
                  {
                    List<Developer> developers =
                        snapshot.data! as List<Developer>;
                    ColorScheme colorScheme = Theme.of(context).colorScheme;
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      itemCount: developers.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () async {
                            await Get.to(
                              () =>
                                  DeveloperProfilePage(dev: developers[index]),
                            );
                          },
                          leading: Icon(
                            Icons.code,
                            color: colorScheme.primary,
                          ),
                          title: Text(developers[index].name.capitalizeFirst!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          tileColor: colorScheme.surfaceVariant.withOpacity(.4),
                          titleTextStyle: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: colorScheme.primary),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(developers[index].email),
                              if (developers[index].skills != null)
                                Row(
                                  children: List.generate(
                                    developers[index].skills!.split(',').length,
                                    (subIndex) {
                                      return Text(
                                          '${developers[index].skills!.split(',')[subIndex].capitalizeFirst!}, ');
                                    },
                                  ),
                                )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 13,
                      ),
                    );
                  }
              }
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
    );
  }

  search(
      {required String searchTerm,
      required CustomerSearchOptions selectedOption}) {
    this.searchTerm = searchTerm;
    this.selectedOption = selectedOption;
    if (selectedOption == CustomerSearchOptions.service) {
      serviceSearchResults = searchForServices();
    }
    if (selectedOption == CustomerSearchOptions.developer) {
      developerSearchResults = searchForDevelopers();
    }
    setState(() {});
  }

  Future<List<Developer>> searchForDevelopers() async {
    return await DeveloperDBHelper.searchForDevelopers(searchTerm);
  }

  Future<List<RAMOService>> searchForServices() async {
    return ServiceDBHelper.searchByServiceName(searchTerm);
  }
}
