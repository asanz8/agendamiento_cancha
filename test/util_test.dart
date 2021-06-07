import 'package:flutter_test/flutter_test.dart';

import 'package:agendamiento_cancha/src/common/util.dart';

void main() {
  final DateTime dt = DateTime(1970, 1, 1, 16);

  group('Util', () {

    test('Retorna la fecha a las 00:00:00 en milisegundos', () {
      expect(util.formatDateMilliStart(dt), equals(14400000));
    });

    test('Formatea la fecha a "YYYY-MM-DD"', () {
      expect(util.dateFormat(dt), equals("1970-01-01"));
    });

  });

}