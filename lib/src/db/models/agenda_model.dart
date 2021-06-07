import 'package:sqflite/sqflite.dart';

import 'package:agendamiento_cancha/src/db/data/agenda_data.dart';
import '../db_provider.dart';
import 'package:agendamiento_cancha/src/common/util.dart';

class _AgendaModel {

  Future<List<Agenda>> select() async {
    final db = await dbProvider.database;
    final now = DateTime.now();
    final todayMilli = util.formatDateMilliStart(now);

    final List<Map<String, dynamic>> agendasNew = await db.rawQuery('SELECT * FROM agenda WHERE fecha >= $todayMilli ORDER BY fecha ASC');
    final List<Map<String, dynamic>> agendasOld = await db.rawQuery('SELECT * FROM agenda WHERE fecha < $todayMilli ORDER BY fecha DESC');

    final l1 = List.generate(agendasNew.length, (i) {
      return Agenda(
        id: agendasNew[i]['id'],
        cancha: agendasNew[i]['cancha'],
        usuario: agendasNew[i]['usuario'],
        fecha: agendasNew[i]['fecha'],
        probLluvia: agendasNew[i]['probLluvia'],
      );
    });

    final l2 = List.generate(agendasOld.length, (i) {
      return Agenda(
        id: agendasOld[i]['id'],
        cancha: agendasOld[i]['cancha'],
        usuario: agendasOld[i]['usuario'],
        fecha: agendasOld[i]['fecha'],
        probLluvia: agendasOld[i]['probLluvia'],
      );
    });

    l1.addAll(l2);

    return l1;
  }

  Future<List<Map<String, dynamic>>> all() async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM agenda');

    return maps;
  }

    Future<int> checkDisponibilidad(int fecha, String cancha) async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT COUNT(id) FROM agenda WHERE fecha = $fecha AND cancha = "$cancha"');
    return result[0]['COUNT(id)'];
  }

  Future<void> insert(Agenda agenda) async {
    final db = await dbProvider.database;
    await db.insert('agenda', agenda.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  delete(Agenda agenda) async {
    final db = await dbProvider.database;
    await db.delete(
      'agenda',
      where: 'id = ?',
      whereArgs: [agenda.id],
    );
  }

}

final agendaModel = new _AgendaModel();