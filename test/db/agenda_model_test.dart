import 'package:agendamiento_cancha/src/db/data/agenda_data.dart';
import 'package:agendamiento_cancha/src/db/db_provider.dart';
import 'package:agendamiento_cancha/src/db/models/agenda_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  dbProvider.database = await dbProvider.openDb();
  final db = dbProvider.database;

  final agenda1 = new Agenda(id: 1, cancha: 'A', usuario: 'Test1', fecha: 1583035200000, probLluvia: 0.50);

  final agenda2 = new Agenda(id: 2, cancha: 'A', usuario: 'Test2', fecha: 1583035200000, probLluvia: 0.50);

  final agenda3 = new Agenda(id: 3, cancha: 'A', usuario: 'Test3', fecha: 1583035200000, probLluvia: 0.50);

  final agenda4 = new Agenda(id: 4, cancha: 'A', usuario: 'Test4', fecha: 1583035200000, probLluvia: 0.50);

  // Restar un dia al actual
  final agenda5 = new Agenda(
      id: 5,
      cancha: 'A',
      usuario: 'Test5',
      fecha: DateTime.now().subtract(Duration(days: 1)).millisecondsSinceEpoch,
      probLluvia: 0.50
  );

  // Sumar un dia al actual
  final agenda6 = new Agenda(
      id: 6,
      cancha: 'B',
      usuario: 'Test6',
      fecha: DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch,
      probLluvia: 0.50
  );

  // Sumar 2 dias al actual
  final agenda7 = new Agenda(
      id: 7,
      cancha: 'C',
      usuario: 'Test7',
      fecha: DateTime.now().add(Duration(days: 2)).millisecondsSinceEpoch,
      probLluvia: 0.50
  );

  setUp(() async {
    await db.delete('agenda');
  });

  tearDownAll(() async {
    await db.delete('agenda');
  });

  group('agenda_model', () {

    test('tabla vacia al inicializar', () async {
      expect((await agendaModel.all()).isEmpty, true);
    });

    test('insertar 1 elemento', () async {
      await agendaModel.insert(agenda1);
      expect((await agendaModel.all()).length, 1);
    });

    test('insertar 3 elementos', () async {
      await agendaModel.insert(agenda1);
      await agendaModel.insert(agenda2);
      await agendaModel.insert(agenda3);
      expect((await agendaModel.all()).length, 3);
    });

    test('validar que cancha "A" ya posee 3 agendas para el mismo dia', () async {
      await agendaModel.insert(agenda1);
      await agendaModel.insert(agenda2);
      await agendaModel.insert(agenda3);
      expect(await agendaModel.checkDisponibilidad(agenda4.fecha, agenda4.cancha), 3);
    });

    test('eliminar un elemento y agregar otro', () async {
      await agendaModel.insert(agenda1);
      await agendaModel.insert(agenda2);
      await agendaModel.insert(agenda3);

      await agendaModel.delete(agenda3);
      await agendaModel.insert(agenda4);
      expect((await agendaModel.all()).length, 3);
    });

    test('fecha de primer elemento menor o igual a fecha del segundo', () async {
      await agendaModel.insert(agenda5);
      await agendaModel.insert(agenda6);
      await agendaModel.insert(agenda7);

      final maps = await agendaModel.select();

      expect(maps[0].fecha, lessThanOrEqualTo(maps[1].fecha));
    });

    test('fecha del segundo elemento mayor al tercero', () async {
      await agendaModel.insert(agenda5);
      await agendaModel.insert(agenda6);
      await agendaModel.insert(agenda7);

      final maps = await agendaModel.select();

      expect(maps[1].fecha, greaterThan(maps[2].fecha));
    });

  });
}