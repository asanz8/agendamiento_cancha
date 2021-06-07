import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agendamiento_cancha/src/models/lista_agenda.dart';
import 'package:agendamiento_cancha/src/common/util.dart';
import 'package:agendamiento_cancha/src/db/data/agenda_data.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Agendamiento"),
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(context, '/nueva-agenda'),
              icon: Icon(Icons.add),
              tooltip: 'Nueva agenda'
          ),
        ],
      ),
      body: _crearListaAgendas(),
    );
  }

  Widget _crearListaAgendas() {
    return Consumer<ListaAgendaModel>(
      builder: (context, listaAgenda, child) {

        return ListView.builder(
          itemCount: listaAgenda.getSize(),
          itemBuilder: (context, i) {
            return Column(
              children: [
                _crearRow(context, listaAgenda, i),
                Divider(),
              ],
            );
          }
        );
      }
    );
  }

  Widget _crearRow(BuildContext context, ListaAgendaModel listaAgenda, index) {
    final agenda = listaAgenda.getIndex(index);
    final now = DateTime.now();
    final nowMilli = util.formatDateMilliStart(now);
    final after = agenda.fecha >= nowMilli;
    final probLluvia = agenda.probLluvia.isNegative ? 'No disponible' : '${(agenda.probLluvia*100).ceil()}%';

    return ListTile(
      contentPadding: index == 0 ? EdgeInsets.only(top: 8, left: 16, right: 16) : null,
      title: Row(
        children: [
          Text('${agenda.usuario}', style: TextStyle(fontWeight: FontWeight.bold),),
          Text(' - Cancha ${agenda.cancha}')
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(util.dateFormat(DateTime.fromMillisecondsSinceEpoch(agenda.fecha)), style: TextStyle(fontWeight: FontWeight.w500),),
          Text('Prob. Lluvia: $probLluvia')
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.remove_circle, color: after ? Colors.red : Colors.blue),
        onPressed: () {
          _showAlertBorrar(context, agenda, index);
        },
      ),
    );
  }

  Future<void> _showAlertBorrar(BuildContext context, Agenda agenda, int index) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar agenda'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                const Text('¿Desea eliminar la siguiente agenda?'),
                Text(agenda.usuario),
                Text('Cancha ${agenda.cancha}'),
                Text(util.dateFormat(DateTime.fromMillisecondsSinceEpoch(agenda.fecha)))
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                context.read<ListaAgendaModel>().remove(agenda, index);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Agenda eliminada')));
                Navigator.pop(context);
              },
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')
            )
          ],
        );
      },
    );
  }
}