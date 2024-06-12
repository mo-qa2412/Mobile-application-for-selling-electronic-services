import 'package:mysql1/mysql1.dart';
import '../entities/developer.dart';

import '../entities/dbhelper.dart';

class DeveloperDBHelper {
  static Future<int?> login({//**************************** */
    required String email,
    required String password,
  }) async {
    Results result = await DBHelper.instance.connectAndExecute(
      '''
          select ${_DeveloperDBHelperConstants.tableName}.id as 'id'
          from ${_DeveloperDBHelperConstants.tableName}
          where ${_DeveloperDBHelperConstants.tableName}.email="$email"
          and ${_DeveloperDBHelperConstants.tableName}.password="$password";
        ''',
    );
    if (result.isEmpty) {
      return null;
    }
    return (result.first.fields['id'] as int);
  }

  static Future<int?> update(Developer developer) async {
    Results result = await DBHelper.instance.connectAndExecute(
      '''
          UPDATE `developer` SET `Name`='[value-2]',
          `Password`='[value-3]',`Balance`='[value-4]',`PhoneNumber`='[value-5]',
          `Email`='[value-6]',`UserName`='[value-7]',`HasFinishedSignUp`=${developer.hasFinishedSignUp ? 1 : 0},
          `ContactEmail`='${developer.contactEmail!}',`Skills`='${developer.skills!}' WHERE `Id` = ${developer.id}
        ''',
    );
    if (result.isEmpty) {
      return null;
    }
    return (result.first.fields['id'] as int);
  }

  static Future<int?> updateProfile(Developer developer) async {//***************************** */
    Results result = await DBHelper.instance.connectAndExecute(
      '''
          UPDATE `developer` SET 
          `Name`='${developer.name}',
          `Password`='${developer.password}',
          `PhoneNumber`='${developer.phoneNumber}',
          `Email`='${developer.email}',
          `ContactEmail`='${developer.contactEmail!}',
          `Skills`='${developer.skills!}' 
          WHERE `Id` = ${developer.id}
        ''',
    );
    if (result.isEmpty) {
      return null;
    }
    return (result.first.fields['id'] as int);
  }

  static Future<bool> finishSignUp(Developer developer) async {
    await DBHelper.instance.connectAndExecute(
      '''
        UPDATE `developer` SET `HasFinishedSignUp` = '1',
        `ContactEmail` = '${developer.contactEmail}',
        `Skills` = '${developer.skills}'
        WHERE `developer`.`Id` = ${developer.id};
      ''',
    );
    return true;
  }

  static Future<int?> signUp(Developer developer) async {
    Map<String, dynamic> values = developer.toMap();
    values.remove('id');
    int id = await DBHelper.instance
        .insert(_DeveloperDBHelperConstants.tableName, values);
    return id;
  }

  static Future<List<Developer>> getAll() async {
    Results results = await DBHelper.instance.connectAndExecute(
      '''
        select *
        from ${_DeveloperDBHelperConstants.tableName};
      ''',
    );
    List<Developer> developers = [];
    for (var element in results) {
      developers.add(
        Developer.fromMap(element.fields),
      );
    }
    return developers;
  }

  static Future<List<Developer>> searchForDevelopers(String searchTerm) async {//*********************** */
    List<Developer> res = await getAll();
    return res.where(
      (element) {
        return element
                .toString()
                .toLowerCase()
                .trim()
                .contains(searchTerm.toLowerCase().trim()) &&
            element.hasFinishedSignUp;
      },
    ).toList();
  }

  static Future<Developer> getById(int id) async {
    Results results = await DBHelper.instance.connectAndExecute(
      '''
        select *
        from ${_DeveloperDBHelperConstants.tableName}
        where ${_DeveloperDBHelperConstants.tableName}.id=$id;
      ''',
    );
    if (results.isEmpty) {
      throw Exception('Developer not found for id: $id');
    }
    return Developer.fromMap(results.first.fields);
  }

  static Future<Developer> getByServiceId({required int serviceId}) async {
    Results results = await DBHelper.instance.connectAndExecute('''
      SELECT * from `developer` WHERE `developer`.`Id` in
      (SELECT (`service`.`DeveloperId`) FROM `service` WHERE `service`.`Id` = $serviceId);
    ''');
    if (results.isEmpty) {
      throw Exception('Cannot get developer by ServiceID$serviceId');
    }
    return Developer.fromMap(results.first.fields);
  }

  static Future<bool> validateUserNameExistence(String userName) async {
    Results result = await DBHelper.instance.connectAndExecute(
      '''
        select * from ${_DeveloperDBHelperConstants.tableName}
        where ${_DeveloperDBHelperConstants.tableName}.userName='$userName'
      ''',
    );
    if (result.isEmpty) {
      return false;
    }
    return true;
  }
}

class _DeveloperDBHelperConstants {
  static String get tableName => 'developer';
}
