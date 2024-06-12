import 'package:flutter/material.dart';
import '../../../controllers/customer_favorites_controller.dart';
import '../../../models/db_helpers/service_dbhelper.dart';
import '../../../models/entities/ramo_service.dart';
import '../homepage/widgets/ramo_service_homepage_card.dart';

class CustomerFavoritesPage extends StatefulWidget {
  const CustomerFavoritesPage({super.key});

  @override
  State<CustomerFavoritesPage> createState() => _CustomerFavoritesPageState();
}

class _CustomerFavoritesPageState extends State<CustomerFavoritesPage> {
  late Future<List<RAMOService>> favorites;
  @override
  void initState() {
    CustomerFavoritesController.instance.addListener(() {
      if (mounted) {
        setState(() {
          favorites = getFavorites();
        });
      }
    });
    favorites = getFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FutureBuilder(
        future: favorites,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.favorite,
                        size: 130,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        'No Favorites Yet',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                );
              }
              List<RAMOService> services = snapshot.data!;
              return ListView.separated(
                padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: MediaQuery.of(context).padding.top + 10,
                  bottom: 20,
                ),
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
    );
  }

  Future<List<RAMOService>> getFavorites() async {
    List<int> favoritesIds = CustomerFavoritesController.instance.favoriteItems;
    if (favoritesIds.isEmpty) {
      return [];
    }
    return await ServiceDBHelper.getByARangeOfIds(favoritesIds);
  }
}
