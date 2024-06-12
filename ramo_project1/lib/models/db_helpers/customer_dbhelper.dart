import 'package:mysql1/mysql1.dart';
import 'package:ramo/controllers/global_variables.dart';
import '../entities/ramo_service.dart';
import '../entities/customer.dart';
import '../entities/dbhelper.dart';

class CustomerDBHelper {
  static Future<int?> login({
    //***********************************/
    required String userName,
    required String password,
  }) async {
    Results result = await DBHelper.instance.connectAndExecute(
      '''
        select ${_CustomerDBHelperConstants.tableName}.id as 'id'
        from ${_CustomerDBHelperConstants.tableName}
        where ${_CustomerDBHelperConstants.tableName}.userName="$userName"
        and ${_CustomerDBHelperConstants.tableName}.password="$password";
      ''',
    );
    if (result.isEmpty) {
      return null;
    }
    return (result.first.fields['id'] as int);
  }

  static Future<Customer?> updateName({
    //*******************************/
    required String name,
  }) async {
    try {
      await DBHelper.instance.connectAndExecute(
        '''
      UPDATE `customer` SET `Name`='$name' WHERE `Id`=${(GlobalVariables.currentUser as Customer).id};
      ''',
      );

      return await getById((GlobalVariables.currentUser as Customer).id);
    } catch (e) {
      return null;
    }
  }

  static Future<Customer> getById(int id) async {
    Results results = await DBHelper.instance.connectAndExecute(
      '''
        select *
        from ${_CustomerDBHelperConstants.tableName}
        where ${_CustomerDBHelperConstants.tableName}.id=$id;
      ''',
    );
    if (results.isEmpty) {
      throw Exception('Customer not found for id: $id');
    }
    return Customer.fromMap(results.first.fields);
  }

  static Future<int> signUp(Customer customer) async {
    //**********************************/
    Map<String, dynamic> values = customer.toMap();
    values.remove('id');
    int id = await DBHelper.instance
        .insert(_CustomerDBHelperConstants.tableName, values);
    return id;
  }

  static Future<bool> orderService(
      //**************************************/
      {required RAMOService service,
      required int customerId}) async {
    print(customerId);
    print(service.id);
    try {
      await DBHelper.instance.connectAndExecute(
        '''
        SELECT orderService(${service.id},$customerId) as orderService;
      ''',
      );
      return true;
    } catch (e) {
      print('Error Occurred: $e');
      return false;
    }
  }

  static Future<List<Customer>> getAll() async {
    Results results = await DBHelper.instance.connectAndExecute(
      '''
        select *
        from ${_CustomerDBHelperConstants.tableName};
      ''',
    );
    List<Customer> customers = [];
    for (var element in results) {
      customers.add(
        Customer.fromMap(element.fields),
      );
    }
    return customers;
  }

  static Future<bool> validateUserNameExistence(String userName) async {
    Results result = await DBHelper.instance.connectAndExecute(
      '''
        select * from ${_CustomerDBHelperConstants.tableName}
        where ${_CustomerDBHelperConstants.tableName}.userName='$userName'
      ''',
    );
    if (result.isEmpty) {
      return false;
    }
    return true;
  }
}

class _CustomerDBHelperConstants {
  static String get tableName => 'customer';
}
