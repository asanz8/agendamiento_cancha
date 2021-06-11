import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agendamiento_cancha/src/db/data/agenda_data.dart';
import 'package:agendamiento_cancha/src/models/lista_agenda.dart';
import 'package:agendamiento_cancha/messages/CommonMsg.i18n.dart';
import 'package:agendamiento_cancha/messages/HomePageMsg.i18n.dart';
import 'package:agendamiento_cancha/src/common/util.dart';
import 'package:agendamiento_cancha/src/pages/home_page/empty_list_view_agenda.dart';
import 'package:agendamiento_cancha/src/pages/home_page/clima_tag.dart';

final homePageMsg = HomePageMsg();
final commonMsg = CommonMsg();

class ListViewAgenda extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Consumer<ListaAgendaModel>(
        builder: (context, listaAgenda, child) {
          final listSize = listaAgenda.getSize();

          if(listSize == 0){
            return EmptyListViewAgenda();
          }

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Text(homePageMsg.list_agenda_header,
                  style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold, fontSize: 14),
                )
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: listSize,
                  itemBuilder: (context, i) {
                    return Column(
                      children: [
                        _crearRow(context, listaAgenda, i),
                      ],
                    );
                  }
                ),
              )
            ],
          );
        }
    );
  }

  Widget _crearRow(BuildContext context, ListaAgendaModel listaAgenda, int index) {
    final agenda = listaAgenda.getIndex(index);
    final date = DateTime.fromMillisecondsSinceEpoch(agenda.fecha);

    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Material(
        elevation: 6.0,
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(date.day.toString().padLeft(2, '0'), style: TextStyle(fontSize: 28, color: Colors.blueGrey)),
                  Text(commonMsgMap['month${date.month}']!, style: TextStyle(color: Colors.blueGrey, fontSize: 12))
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                color: Colors.grey,
                child: SizedBox(width: 1, height: 25),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('${agenda.usuario}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).accentColor)),
                      Text(' | ${commonMsg.field} ${agenda.cancha}', style: TextStyle(color: Theme.of(context).accentColor, fontSize: 14))
                    ],
                  ),
                  ClimaTag(probLluvia: agenda.probLluvia)
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        _showAlertBorrar(context, agenda, index);
                      },
                    ),
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );


    // return ListTile(
    //   contentPadding: index == 0 ? EdgeInsets.only(top: 8, left: 16, right: 16) : null,
    //   title: Row(
    //     children: [
    //       Text('${agenda.usuario}', style: TextStyle(fontWeight: FontWeight.bold),),
    //       Text(' - ${commonMsg.field} ${agenda.cancha}')
    //     ],
    //   ),
    //   subtitle: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Text(util.dateFormat(DateTime.fromMillisecondsSinceEpoch(agenda.fecha)), style: TextStyle(fontWeight: FontWeight.w500),),
    //       Text('${commonMsg.prob_lluvia}: $probLluvia')
    //     ],
    //   ),
    //   trailing: IconButton(
    //     icon: Icon(Icons.remove_circle, color: Colors.red),
    //     onPressed: () {
    //       _showAlertBorrar(context, agenda, index);
    //     },
    //   ),
    // );
  }

  Future<void> _showAlertBorrar(BuildContext context, Agenda agenda, int index) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(homePageMsg.delete_agenda),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(homePageMsg.delete_agenda_alert_title),
                Text(agenda.usuario),
                Text('${commonMsg.field} ${agenda.cancha}'),
                Text(util.dateFormat(DateTime.fromMillisecondsSinceEpoch(agenda.fecha)))
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                context.read<ListaAgendaModel>().remove(agenda, index);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(homePageMsg.success_delete_agenda), duration: Duration(seconds: 2)));
                Navigator.pop(context);
              },
              child: Text(commonMsg.delete, style: TextStyle(color: Colors.red)),
            ),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(commonMsg.cancel)
            )
          ],
        );
      },
    );
  }

}