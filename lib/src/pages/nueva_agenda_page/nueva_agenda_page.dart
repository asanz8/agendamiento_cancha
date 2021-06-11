import 'package:agendamiento_cancha/src/remote/weather_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import 'package:agendamiento_cancha/src/models/lista_agenda.dart';
import 'package:agendamiento_cancha/src/db/data/agenda_data.dart';
import 'package:agendamiento_cancha/src/common/util.dart';
import 'package:agendamiento_cancha/messages/NuevaAgendaPageMsg.i18n.dart';
import 'package:agendamiento_cancha/messages/CommonMsg.i18n.dart';
import 'package:agendamiento_cancha/src/pages/nueva_agenda_page/boton_cancha.dart';
import 'package:agendamiento_cancha/src/pages/nueva_agenda_page/pronostico_tag.dart';

final nuevaAgendaPageMsg = NuevaAgendaPageMsg();
final commonMsg = CommonMsg();

class NuevaAgendaPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NuevaAgendaPageState();
}

class _NuevaAgendaPageState extends State {
  String canchaSelected = '';
  int fecha = -1;
  String usuario = '';
  double probLluvia = -2.0;

  final _formKey = GlobalKey<FormState>();

  TextEditingController datePickerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nuevaAgendaPageMsg.appbar_title),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Text(nuevaAgendaPageMsg.complete_form,
                    style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold, fontSize: 14),
                  )
              ),
              _crearTextFieldUsuario(),
              _crearDatePicker(),
              PronosticoTag(probLluvia: probLluvia),
              _crearRowCanchas(),
              Container(
                margin: EdgeInsets.only(top: 100),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          padding: EdgeInsets.only(right: 90, left: 90, top: 18, bottom: 18)
                      ),
                      onPressed: () => _crearAgenda(),
                      child: Text(nuevaAgendaPageMsg.create_agenda.toUpperCase())
                  ),
                ),
              )
            ],
          ),
        )
      )
    );
  }

  void _crearAgenda() async {
    if(_formKey.currentState!.validate()){
      if(canchaSelected.isNotEmpty){
        var listaAgenda = context.read<ListaAgendaModel>();
        final disponible = await listaAgenda.validate(fecha, canchaSelected);

        if(disponible){
          final id = DateTime.now().millisecondsSinceEpoch;

          final newAgenda = Agenda(
            id: id,
            cancha: canchaSelected,
            usuario: usuario,
            fecha: fecha,
            probLluvia: probLluvia,
          );

          listaAgenda.add(newAgenda);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(nuevaAgendaPageMsg.success_create_agenda)));
          Navigator.pop(context);
        } // if disponible
        else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(nuevaAgendaPageMsg.field_full)));
        }
      } // if canchaSelected.isNotEmpty
      else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(nuevaAgendaPageMsg.select_field)));
      }
    }
  }

  Widget _crearTextFieldUsuario() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return nuevaAgendaPageMsg.text_input_user_invalid;
          }
          return null;
        },
        style: TextStyle(color: Theme.of(context).accentColor),
        decoration: InputDecoration(
          hintText: nuevaAgendaPageMsg.text_input_user_hint,
          hintStyle: TextStyle(color: Theme.of(context).accentColor),
          suffixIcon: Icon(Icons.person, color: Theme.of(context).accentColor),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2),
            borderRadius: BorderRadius.circular(0)
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor, width: 1),
            borderRadius: BorderRadius.circular(0)
          )
        ),
        onChanged: (text) {
          setState(() => usuario = text);
        },
      )
    );
  }

  Widget _crearDatePicker() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return nuevaAgendaPageMsg.date_picker_invalid;
          }
          return null;
        },
        style: TextStyle(color: Theme.of(context).accentColor),
        enableInteractiveSelection: false,
        controller: datePickerController,
        decoration: InputDecoration(
          hintText: nuevaAgendaPageMsg.date_picker_hint,
          hintStyle: TextStyle(color: Theme.of(context).accentColor),
          suffixIcon: Icon(Icons.calendar_today, color: Theme.of(context).accentColor),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor, width: 1),
            borderRadius: BorderRadius.circular(0)
          )
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          _selectFecha();
        },
      ),
    );
  }

  void _selectFecha() async {

    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: fecha == -1 ? DateTime.now() : DateTime.fromMillisecondsSinceEpoch(fecha),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 1)
    );

    if(picked != null) {
      setState(() => fecha = picked.millisecondsSinceEpoch);
      datePickerController.text = '${picked.day}-${picked.month}-${picked.year}';
      
      final sevenDays = DateTime.fromMillisecondsSinceEpoch(util.formatDateMilliStart(DateTime.now())).add(Duration(days: 7));
      if(fecha <= sevenDays.millisecondsSinceEpoch){
        _checkClima();
      }
      else {
        probLluvia = -1.0;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(nuevaAgendaPageMsg.forecast_no_available)));
        setState(() {});
      }
    }
  }

  Widget _crearRowCanchas() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Text(nuevaAgendaPageMsg.select_field,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BotonCancha(cancha: 'A', onPress: _onSelectCancha, canchaSelected: canchaSelected),
              BotonCancha(cancha: 'B', onPress: _onSelectCancha, canchaSelected: canchaSelected),
              BotonCancha(cancha: 'C', onPress: _onSelectCancha, canchaSelected: canchaSelected),
            ],
          )
        ],
      ),
    );
  }

  void _onSelectCancha(String cancha) {
    setState(() => canchaSelected = cancha);
  }

  _checkClima() async {
    try {
      final Response<dynamic> response = await WeatherApi.getWeather();
      final List pronostico = response.data['daily'];

      for(int i=0; i<=pronostico.length-1; i++){
        final fechaPronostico = util.formatDateMilliStart(DateTime.fromMillisecondsSinceEpoch(pronostico[i]['dt'] * 1000));
        if(fecha == fechaPronostico){
          probLluvia = pronostico[i]['pop'] is int ? pronostico[i]['pop'].toDouble() : pronostico[i]['pop'];
          break;
        }
      }
      setState(() {});
    }
    catch(e) {
      probLluvia = -2.0;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(commonMsg.error_weather_api)));
      setState(() {});
    }
  }

}