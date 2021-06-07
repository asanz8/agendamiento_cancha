import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class _DbProvider {

  var database;

  Future<Database> openDb() async {
    return openDatabase(
      join(await getDatabasesPath(), 'agendamiento_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE agenda(id INTEGER PRIMARY KEY, cancha TEXT, usuario TEXT, fecha INTEGER, probLluvia REAL)',
        );
      },
      version: 1,
    );
  }

}

final dbProvider = new _DbProvider();