import 'package:mysql1/mysql1.dart';

import '../../controllers/global_variables.dart';
import '../entities/customer.dart';
import '../entities/dbhelper.dart';
import '../entities/service_order.dart';

abstract class ServiceOrderDBHelper {
  static Future<bool> updateServiceOrder(//************************* */
      {required ServiceOrder serviceOrder}) async {
    await DBHelper.instance.connectAndExecute(
      '''
      UPDATE `serviceorder` SET 
      `ServiceId`=${serviceOrder.serviceId},
      `CustomerId`=${serviceOrder.customerId},
      `IsFinished`=${serviceOrder.isFinished == 1 ? '1' : '0'},
      `LikeStatus`=${serviceOrder.likeStatus} 
      WHERE `Id`=${serviceOrder.id}
      ''',
    );
    return true;
  }

  static Future<bool> setServiceOrderAsFinished(//*************************/
      {required int serviceOrderId}) async {
    try {
      await DBHelper.instance.connectAndExecute(
        '''
      SELECT markServiceAsFinished($serviceOrderId) as markServiceAsFinished
      ''',
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<List<ServiceOrder>> getCustomerServiceOrders(//**************************/
      {bool isFinished = false}) async {
    Results results = await DBHelper.instance.connectAndExecute(
      '''
        SELECT * FROM `serviceorder` WHERE
        `serviceorder`.`CustomerId` = ${(GlobalVariables.currentUser as Customer).id}
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

  
}
