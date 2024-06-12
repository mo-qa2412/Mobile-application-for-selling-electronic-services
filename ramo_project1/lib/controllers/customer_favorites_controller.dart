import 'package:flutter/material.dart';
import 'global_variables.dart';
import '../models/entities/customer.dart';
import '../models/shared_prefs_helper.dart';

class CustomerFavoritesController with ChangeNotifier {
  CustomerFavoritesController._({required this.favoriteItems});
  List<int> favoriteItems;

  static CustomerFavoritesController get instance =>
      _isInitialized ? _instance : init();
  static late CustomerFavoritesController _instance;
  static bool _isInitialized = false;

  static CustomerFavoritesController init() {
    if (_isInitialized) {
      return instance;
    }
    _instance = CustomerFavoritesController._(
      favoriteItems: SharedPreferencesHelper.instance
          .getFavoritesForUser((GlobalVariables.currentUser as Customer).id),
    );
    _isInitialized = true;
    return instance;
  }

  void toggleFavoriteService(int serviceId) {
    if (favoriteItems.contains(serviceId)) {
      removeServiceFromFavorites(serviceId);
      return;
    }
    addServiceToFavorites(serviceId);
  }

  Future<void> addServiceToFavorites(int serviceId) async {
    favoriteItems.add(serviceId);
    notifyListeners();
    updateList();
  }

  Future<void> removeServiceFromFavorites(int serviceId) async {
    favoriteItems.remove(serviceId);
    notifyListeners();
    updateList();
  }

  refreshListWithNewUser() {
    favoriteItems = SharedPreferencesHelper.instance
        .getFavoritesForUser((GlobalVariables.currentUser as Customer).id);
  }

  void clearCurrentList() {
    favoriteItems.clear();
  }

  Future<void> updateList() async {
    await SharedPreferencesHelper.instance.updateFavoritesForUser(
      (GlobalVariables.currentUser as Customer).id,
      favoriteItems,
    );
  }
}
