import 'package:mysql1/mysql1.dart';

class DBHelper {
  DBHelper._();
  String get _host => 'MYSQL8001.site4now.net';
  String get _dbName => 'db_a9a72c_ramomob';
  String get _userName => 'a9a72c_ramomob';
  String get _password => 'Ramo100200300';
  ConnectionSettings get _connectionSettings => ConnectionSettings(
        host: _host,
        db: _dbName,
        user: _userName,
        password: _password,
      );

  static DBHelper get instance => DBHelper._();
  Future<Results> connectAndExecute(String query) async {
    // print('Connecting');
    MySqlConnection connection =
        await MySqlConnection.connect(_connectionSettings);
    // String query = 'DESCRIBE db_a9a72c_ramomob.developer;';
    Results results = await connection.query(query);
    // print('Finished Query');
    // ignore: avoid_print
    print('Query Results: $results');
    await connection.close();
    return results;
  }

  Future<int> insert(String tableName, Map<String, dynamic> fields) async {
    MySqlConnection connection =
        await MySqlConnection.connect(_connectionSettings);
    String query = '''
                    insert into $tableName (${fields.keys.join(',')})
                    values (${fields.keys.map((e) => '?').toList().join(',')});
                    ''';
    // print(query);
    await connection.query(
      query,
      fields.values.toList(),
    );
    Results result = await connection.query('select LAST_INSERT_ID()');
    // print('Finished Insert');
    // print('Insert Query Result: $result');
    connection.close();
    return (result.first.fields['LAST_INSERT_ID()'] as int);
  }
}
