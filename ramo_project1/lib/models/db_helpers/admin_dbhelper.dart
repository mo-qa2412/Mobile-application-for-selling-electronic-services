import 'package:mysql1/mysql1.dart';
import '../entities/admin.dart';

import '../entities/dbhelper.dart';
import '../entities/service_order.dart';

class AdminDBHelper {
  static Future<int?> login({//************************/
    required String email,
    required String password,
  }) async {
    Results result = await DBHelper.instance.connectAndExecute(
      '''
        select ${_AdminDBHelperConstants.tableName}.id as 'id'
        from ${_AdminDBHelperConstants.tableName}
        where ${_AdminDBHelperConstants.tableName}.email="$email"
        and ${_AdminDBHelperConstants.tableName}.password="$password";
      ''',
    );
    if (result.isEmpty) {
      return null;
    }
    return (result.first.fields['id'] as int);
  }

  static Future<Admin> getById(int id) async {
    Results results = await DBHelper.instance.connectAndExecute(
      '''
        select *
        from ${_AdminDBHelperConstants.tableName}
        where ${_AdminDBHelperConstants.tableName}.id=$id;
      ''',
    );
    if (results.isEmpty) {
      throw Exception('Admin not found for id: $id');
    }
    return Admin.fromMap(results.first.fields);
  }

  static Future<List<ServiceOrder>> getAll({bool isFinished = false}) async {//*****************************/
    Results results = await DBHelper.instance.connectAndExecute(
      '''
        SELECT * FROM `serviceorder` WHERE `serviceorder`.`isFinished` = ${isFinished ? "1" : "0"}; 
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

class _AdminDBHelperConstants {
  static String get tableName => 'admin';
}
