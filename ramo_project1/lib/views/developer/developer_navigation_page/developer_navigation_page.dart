import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../add_service_page/add_service_page.dart';
import '../homepage/developer_homepage.dart';
import '../../../shared/ui/custom_appbar.dart';
import '../../../shared/ui/custom_scaffold.dart';
import '../../developer_finished_orders_page/developer_finished_orders_page.dart';
import '../developer_current_orders_page/developer_current_orders_page.dart';
import '../profile_page/developer_profile_page.dart';

class DeveloperNavigationPage extends StatefulWidget {
  const DeveloperNavigationPage({super.key});

  @override
  State<DeveloperNavigationPage> createState() =>
      _DeveloperNavigationPageState();
}

class _DeveloperNavigationPageState extends State<DeveloperNavigationPage> {
  List<String> get titles => [
        'My Services',
        'Current Orders',
        'Finished Orders',
        'Profile',
      ];
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      floatingActionButton: pageIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => addService(),
              label: const Row(
                children: [
                  Icon(Icons.add),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Add Service',
                  ),
                ],
              ),
            )
          : null,
      appBar: CustomAppBar(title: titles[pageIndex]),
      body: SizedBox.expand(
        child: IndexedStack(
          index: pageIndex,
          children: [
            const DeveloperHomePage(),
            const DeveloperCurrentOrdersPage(),
            const DeveloperFinishedOrdersPage(),
            DeveloperProfilePage(
              subView: true,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor:
            Theme.of(context).colorScheme.onSurface.withOpacity(.5),
        currentIndex: pageIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (value) => setState(() {
          pageIndex = value;
        }),
        items: [
          BottomNavigationBarItem(
            label: titles[0],
            icon: const Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: titles[1],
            icon: const Icon(Icons.timelapse_sharp),
          ),
          BottomNavigationBarItem(
            label: titles[2],
            icon: const Icon(Icons.done),
          ),
          BottomNavigationBarItem(
            label: titles[3],
            icon: const Icon(Icons.person),
          ),
        ],
      ),
    );
  }

  Future<void> addService() async {
    var result = await Get.to(() => AddServicePage());
    if (result == true) {
      AddServicePageChangeStreamer.streamer.streamChanges();
    }
  }
}
