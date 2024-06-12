import 'package:flutter/material.dart';
import '../search_page/customer_search_page.dart';
import '../../../shared/ui/custom_appbar.dart';
import '../../../shared/ui/custom_scaffold.dart';
import '../customer_orders_page/customer_orders_page.dart';
import '../homepage/customer_homepage.dart';
import '../profile_page/customer_proflle_page.dart';

import '../favorites_page/favorites_page.dart';

class CustomerNavigationPage extends StatefulWidget {
  const CustomerNavigationPage({super.key});

  @override
  State<CustomerNavigationPage> createState() => _CustomerNavigationPageState();
}

class _CustomerNavigationPageState extends State<CustomerNavigationPage> {
  List<String> titles = [
    'Home',
    'Search',
    'Orders',
    'Favorites',
    'Profile',
  ];
  int pageIndex = 0;
  GlobalKey<CustomerProfilePageState> customerProfileState = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: titles[pageIndex]),
      body: SizedBox.expand(
        child: IndexedStack(
          index: pageIndex,
          children: [
            const CustomerHomePage(),
            const CustomerSearchPage(),
            const CustomerOrdersPage(),
            const CustomerFavoritesPage(),
            CustomerProfilePage(key: customerProfileState),
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
                if (value == 4) {
                  if (customerProfileState.currentState != null) {
                    customerProfileState.currentState!.resetState();
                  }
                }
              }),
          items: const [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'Search',
              icon: Icon(Icons.search),
            ),
            BottomNavigationBarItem(
              label: 'Orders',
              icon: Icon(Icons.timelapse_sharp),
            ),
            BottomNavigationBarItem(
              label: 'Favorites',
              icon: Icon(Icons.favorite),
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: Icon(Icons.person),
            ),
          ]),
    );
  }
}
