import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/search_results_widget.dart';

class CustomerSearchPage extends StatefulWidget {
  const CustomerSearchPage({super.key});

  @override
  State<CustomerSearchPage> createState() => _CustomerSearchPageState();
}

class _CustomerSearchPageState extends State<CustomerSearchPage> {
  CustomerSearchOptions currentSearchOption = CustomerSearchOptions.service;
  final TextEditingController searchBarController = TextEditingController();
  String searchTerm = '';
  GlobalKey<SearchResultsPageState> searchWidgetKey =
      GlobalKey<SearchResultsPageState>();

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return SizedBox.expand(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.2),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              20,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 7),
                        child: TextField(
                          controller: searchBarController,
                          decoration: const InputDecoration(
                            hintText: 'Search..',
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await performSearch();
                      },
                      icon: const Icon(Icons.search),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Text(
                        'Search for:',
                        style: textTheme.titleMedium,
                      ),
                      const Spacer(),
                      DropdownButton<CustomerSearchOptions>(
                        value: currentSearchOption,
                        items: CustomerSearchOptions.values
                            .map(
                              (e) => DropdownMenuItem<CustomerSearchOptions>(
                                value: e,
                                child: Text(
                                  e.toString().split('.')[1].capitalizeFirst!,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(
                              () {
                                currentSearchOption = value;
                                if (searchWidgetKey.currentState != null) {
                                  searchWidgetKey.currentState!.search(
                                    searchTerm: searchTerm,
                                    selectedOption: currentSearchOption,
                                  );
                                }
                              },
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          const SizedBox(height: 10),
          Expanded(
            child: SearchResultsPage(
              key: searchWidgetKey,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> performSearch() async {
    searchTerm = searchBarController.text;
    if (searchWidgetKey.currentState != null) {
      searchWidgetKey.currentState!.search(
        searchTerm: searchTerm,
        selectedOption: currentSearchOption,
      );
    }
  }
}

enum CustomerSearchOptions { service, developer }
