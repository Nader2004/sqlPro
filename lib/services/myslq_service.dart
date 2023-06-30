import 'package:mysql1/mysql1.dart';

class MySqlDatabase {
  static Future<MySqlConnection> connectDatabase() async {
    final MySqlConnection _connection = await MySqlConnection.connect(
      ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'root',
        password: 'Looper@2023',
        db: 'employees',
      ),
    );
    return _connection;
  }
}
