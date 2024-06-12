import 'package:mysql1/mysql1.dart';
import '../entities/developer.dart';
import '../entities/service_order.dart';

import '../../controllers/global_variables.dart';
import '../entities/dbhelper.dart';
import '../entities/ramo_service.dart';

class ServiceDBHelper {
  static Future<List<RAMOService>> getLatestServices() async {//**************************/
    Results results = await DBHelper.instance.connectAndExecute(
      '''
        select *
        from ${_RAMOServiceDBHelperConstants.tableName}
        order by ${_RAMOServiceDBHelperConstants.tableName}.id desc
        limit 10;
      ''',
    );
    List<RAMOService> services = [];
    for (var element in results) {
      services.add(
        RAMOService.fromMap(element.fields),
      );
    }
    return services;
  }

  static Future<List<RAMOService>> getAll() async {
    Results results = await DBHelper.instance.connectAndExecute(
      '''
        select *
        from ${_RAMOServiceDBHelperConstants.tableName};
      ''',
    );
    List<RAMOService> services = [];
    for (var element in results) {
      services.add(
        RAMOService.fromMap(element.fields),
      );
    }
    return services;
  }

  static Future<bool> checkIfCustomerHasAlreadyOrderedService({//************************/
    required int serviceId,
    required int customerId,
  }) async {
    Results result = await DBHelper.instance.connectAndExecute('''
        SELECT EXISTS
          (SELECT * 
          FROM serviceorder 
          WHERE serviceorder.ServiceId = $serviceId 
          and serviceorder.CustomerId = $customerId 
          and serviceorder.IsFinished = 0) 
        as 'alreadyOrdered';
      ''');
    return result.first['alreadyOrdered'] == 1;
  }

  static getAllServicesForDeveloper(int developerId) async {//*********************** */
    Results results = await DBHelper.instance.connectAndExecute(
      '''
      SELECT *
      FROM service
      WHERE service.DeveloperId = $developerId;
      ''',
    );
    List<RAMOService> services = [];
    for (var element in results) {
      services.add(
        RAMOService.fromMap(element.fields),
      );
    }
    return services;
  }

  static Future<int> addService(RAMOService service) async {//********************** */
    Map<String, dynamic> serviceAsMap = service.toMap();
    serviceAsMap.remove('id');
    return await DBHelper.instance.insert('service', serviceAsMap);
  }

  static Future<bool> editService(RAMOService service) async {//********************* */
    await DBHelper.instance.connectAndExecute('''
        UPDATE `service` SET 
        `Title` = '${service.title}', 
        `Category` = ${service.category.index}, 
        `Details` = '${service.details}' 
        WHERE `service`.`Id` = ${service.id};
      ''');
    return true;
  }

  static Future<List<RAMOService>> searchByServiceName(String name) async {//************************/
    Results results = await DBHelper.instance.connectAndExecute(
      '''
        select *
        from ${_RAMOServiceDBHelperConstants.tableName};
      ''',
    );
    List<RAMOService> services = [];
    for (var element in results) {
      services.add(
        RAMOService.fromMap(element.fields),
      );
    }
    return services.where((element) {
      return element
          .toString()
          .toLowerCase()
          .trim()
          .contains(name.toLowerCase().trim());
    }).toList();
  }

  static Future<List<RAMOService>> getByARangeOfIds(List<int> range) async {
    String ids = range.join(',');
    Results results = await DBHelper.instance.connectAndExecute(
      '''
        select *
        from ${_RAMOServiceDBHelperConstants.tableName}
        where ${_RAMOServiceDBHelperConstants.tableName}.id in ($ids)
      ''',
    );
    List<RAMOService> services = [];
    for (var element in results) {
      services.add(
        RAMOService.fromMap(element.fields),
      );
    }
    return services;
  }

  static Future<List<ServiceOrder>> getDeveloperServiceOrders(//************************ */
      {bool isFinished = false}) async {
    Results results = await DBHelper.instance.connectAndExecute(
      '''
        SELECT * FROM `serviceorder` WHERE
        `serviceorder`.`ServiceId` IN 
        (SELECT Id FROM `service` WHERE `service`.`DeveloperId` = ${(GlobalVariables.currentUser as Developer).id})
        AND `serviceorder`.`isFinished` = ${isFinished ? "1" : "0"}; 
      ''',
    );

    List<ServiceOrder> services = [];
    for (var element in results) {
      services.add(
        ServiceOrder.fromMap(element.fields),
      );
    }
    return services;
  }

  static Future<int> getLikeCountForService(int serviceId) async {//*********************** */
    Results result = await DBHelper.instance.connectAndExecute(
      '''
        SELECT count(1) as 'likeCount'
        FROM serviceorder
        WHERE serviceorder.ServiceId = $serviceId
        AND serviceorder.LikeStatus = 1;
      ''',
    );
    return result.first['likeCount'];
  }

  static Future<int> getDislikeCountForService(int serviceId) async {//**************************** */
    Results result = await DBHelper.instance.connectAndExecute(
      '''
        SELECT count(1) as 'dislikeCount'
        FROM serviceorder
        WHERE serviceorder.ServiceId = $serviceId
        AND serviceorder.LikeStatus = 2;
      ''',
    );
    return result.first['dislikeCount'];
  }
}

class _RAMOServiceDBHelperConstants {
  static String get tableName => 'service';
}
