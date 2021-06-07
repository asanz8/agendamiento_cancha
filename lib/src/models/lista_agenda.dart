import 'package:flutter/cupertino.dart';

import 'package:agendamiento_cancha/src/db/data/agenda_data.dart';
import 'package:agendamiento_cancha/src/db/models/agenda_model.dart';

class ListaAgendaModel extends ChangeNotifier {
  final List<Agenda> _agendas = [];

  ListaAgendaModel() {
    _init();
  }

  void _init() async {
    final agendas = await agendaModel.select();
    _agendas.addAll(agendas);
    notifyListeners();
  }

  void _reset() async {
    final agendas = await agendaModel.select();
    _agendas.clear();
    _agendas.addAll(agendas);
    notifyListeners();
  }

  Agenda getIndex(int index) => _agendas[index];

  int getSize() => _agendas.length;

  Future<bool> validate(int fecha, String cancha) async {
    final disponible = await agendaModel.checkDisponibilidad(fecha, cancha);
    return disponible <= 2;
  }

  void add(Agenda agenda) async {
    await agendaModel.insert(agenda);
    _reset();
  }

  void remove(Agenda agenda, int index) async {
    await agendaModel.delete(agenda);
    _agendas.removeAt(index);
    notifyListeners();
  }
}